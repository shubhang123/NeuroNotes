// ignore_for_file: inference_failure_on_function_invocation

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:neuronotes/core/logger/logger.dart';
import 'package:neuronotes/core/util/secure_storage.dart';
import 'package:neuronotes/feature/gemini/gemini.dart';
import 'package:neuronotes/feature/gemini/repository/base_gemini_repository.dart';
import 'package:dio/dio.dart';

class GeminiRepository extends BaseGeminiRepository {
  GeminiRepository();

  final dio = Dio();
  final splitter = const LineSplitter();
  static const baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  /// Streams content from the Gemini API based on the provided content
  /// and optional image.
  /// This method is used to generate content dynamically, potentially
  /// including image analysis.
  @override
  Stream<Candidates> streamContent({
    required Content content,
    Uint8List? image,
  }) async* {
    try {
      final geminiAPIKey = await SecureStorage().getApiKey();
      Object? mapData = {};
      final model = image == null ? 'gemini-pro' : 'gemini-pro-vision';
      if (image == null) {
        mapData = {
          'contents': [
            {
              'parts': content.parts
                      ?.map(
                        (part) => {'text': part.text},
                      )
                      .toList() ??
                  [],
            },
          ],
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_ONLY_HIGH',
            },
          ],
        };
      } else {
        final text = content.parts?.last.text;
        mapData = {
          'contents': [
            {
              'parts': [
                {'text': text},
                {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': base64Encode(image),
                  },
                },
              ],
            }
          ],
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_ONLY_HIGH',
            },
          ],
        };
      }
      final response = await dio.post(
        '$baseUrl/$model:streamGenerateContent?key=$geminiAPIKey',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          responseType: ResponseType.stream,
        ),
        data: jsonEncode(mapData),
      );

      if (response.statusCode == 200) {
        final ResponseBody rb = response.data as ResponseBody;
        int index = 0;
        String modelStr = '';
        List<int> cacheUnits = [];
        List<int> list = [];

        await for (final itemList in rb.stream) {
          list = cacheUnits + itemList;

          cacheUnits.clear();

          String res = '';
          try {
            res = utf8.decode(list);
          } catch (e) {
            cacheUnits = list;
            continue;
          }

          res = res.trim();

          if (index == 0 && res.startsWith('[')) {
            res = res.replaceFirst('[', '');
          }
          if (res.startsWith(',')) {
            res = res.replaceFirst(',', '');
          }
          if (res.endsWith(']')) {
            res = res.substring(0, res.length - 1);
          }

          res = res.trim();

          for (final line in splitter.convert(res)) {
            if (modelStr == '' && line == ',') {
              continue;
            }
            // ignore: use_string_buffers
            modelStr += line;
            try {
              final candidate = Candidates.fromJson(
                (jsonDecode(modelStr)['candidates'] as List?)!.firstOrNull
                    as Map<String, dynamic>,
              );
              yield candidate;
              modelStr = '';
            } catch (e) {
              continue;
            }
          }
          index++;
        }
      }
    } catch (e) {
      logError('Error in streamContent: $e');
      rethrow;
    }
  }

  /// Processes a batch of text chunks to generate embeddings,
  /// which are then returned in a map.
  /// This method is useful for pre-processing text data for
  /// further analysis or comparison.
  @override
  Future<Map<String, List<num>>> batchEmbedChunks({
    required List<String> textChunks,
  }) async {
    try {
      final geminiAPIKey = await SecureStorage().getApiKey();
      final Map<String, List<num>> embeddingsMap = {};
      const int chunkSize = 100;

      for (int i = 0; i < textChunks.length; i += chunkSize) {
        final chunkEnd = (i + chunkSize < textChunks.length)
            ? i + chunkSize
            : textChunks.length;
        final List<String> currentChunk = textChunks.sublist(i, chunkEnd);
        final response = await dio.post(
          '$baseUrl/embedding-001:batchEmbedContents?key=$geminiAPIKey',
          options: Options(headers: {'Content-Type': 'application/json'}),
          data: {
            'requests': currentChunk
                .map(
                  (text) => {
                    'model': 'models/embedding-001',
                    'content': {
                      'parts': [
                        {'text': text},
                      ],
                    },
                    'taskType': 'RETRIEVAL_DOCUMENT',
                  },
                )
                .toList(),
          },
        );
        final results = response.data['embeddings'];

        for (var j = 0; j < currentChunk.length; j++) {
          embeddingsMap[currentChunk[j]] =
              (results![j]['values'] as List).cast<num>();
        }
      }
      return embeddingsMap;
    } catch (e) {
      logError('Error in batchEmbedChunks: $e');
      rethrow;
    }
  }

  /// Generates a prompt for embedding based on the user's input and
  /// the pre-calculated embeddings.
  /// This method is designed to facilitate user interaction by
  /// providing contextually relevant prompts.
  @override
  Future<String> promptForEmbedding({
    required String userPrompt,
    required Map<String, List<num>>? embeddings,
  }) async {
    try {
      final geminiAPIKey = await SecureStorage().getApiKey();
      final response = await dio.post(
        '$baseUrl/embedding-001:embedContent?key=$geminiAPIKey',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode({
          'model': 'models/embedding-001',
          'content': {
            'parts': [
              {'text': userPrompt},
            ],
          },
          'taskType': 'RETRIEVAL_QUERY',
        }),
      );
      final currentEmbedding =
          (response.data['embedding']['values'] as List).cast<num>();
      if (embeddings == null) {
        return 'Error: Embedding calculation failed or no embeddings in state.';
      }

      final Map<String, double> distances = {};
      embeddings.forEach((key, value) {
        final double distance = calculateEuclideanDistance(
          vectorA: currentEmbedding,
          vectorB: value,
        );
        distances[key] = distance;
      });

      final List<MapEntry<String, double>> sortedDistances = distances.entries
          .toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      final StringBuffer mergedText = StringBuffer();
      for (int i = 0; i < 4 && i < sortedDistances.length; i++) {
        mergedText.write(sortedDistances[i].key);
        if (i < 3 && i < sortedDistances.length - 1) {
          mergedText.write('\n\n');
        }
      }

      final prompt = '''
You're an AI assistant for chatting about PDF contents. I'll provide you with the most relevant text from the user's PDF, delimited by ####. Your job is to carefully read this text word by word and answer the user's prompt, which will be prefaced by "Prompt:".
$mergedText
Prompt: $userPrompt
Please follow these guidelines when responding:

Provide comprehensive answers that fully address all aspects of the user's question. Break down complex responses into clear sections if needed.
Adjust your response length to match the question's complexity. Give concise answers for simple queries and detailed explanations for more complex topics.
Use clear, simple language and short paragraphs. Avoid buzzwords and jargon. Break up long responses with subheadings or bullet points when appropriate.
Consider the broader context of the PDF when answering. Include relevant information from other sections if it enhances your response.
After answering the main question, suggest related topics from the PDF that the user might find interesting.
If parts of the question can't be fully answered based on the PDF content, clearly state what information is available and what is not.
Respond in a friendly, helpful tone while remaining informative and precise.
For questions unrelated to the PDF content, politely explain that the information isn't covered in the document. Offer to assist with general knowledge if appropriate.
If you're unsure or don't have enough information to answer, say "I don't know" or "I'm not sure" rather than speculating.
When appropriate, use examples or analogies from the PDF to illustrate your points and make the information more relatable.
cover all the points and make sure the user is satisfied

This improved prompt should help generate more complete, engaging, and user-friendly responses while maintaining accuracy and relevance to the PDF content.
''';
      return prompt;
    } catch (e) {
      logError('Error in prompt generation: $e');
      return 'An error occurred, please try again.';
    }
  }

  /// Calculates the Euclidean distance between two vectors,
  /// providing a measure of similarity.
  /// This method is essential for operations like finding
  /// the closest embeddings.
  @override
  double calculateEuclideanDistance({
    required List<num> vectorA,
    required List<num> vectorB,
  }) {
    try {
      assert(
        vectorA.length == vectorB.length,
        'Vectors must be of the same length',
      );
      double sum = 0;
      for (int i = 0; i < vectorA.length; i++) {
        sum += (vectorA[i] - vectorB[i]) * (vectorA[i] - vectorB[i]);
      }
      return sqrt(sum);
    } catch (e) {
      logError('Error in calculating Euclidean distance: $e');
      rethrow;
    }
  }
}
