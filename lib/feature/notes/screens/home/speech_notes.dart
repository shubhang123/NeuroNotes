import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neuronotes/feature/notes/controllers/authController.dart';
import 'package:neuronotes/feature/notes/services/database.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechNotes extends StatefulWidget {
  const SpeechNotes({super.key});

  @override
  State<SpeechNotes> createState() => _SpeechNotesState();
}

class _SpeechNotesState extends State<SpeechNotes> {
  final AuthController authController = Get.find<AuthController>();
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'notListening') {
          setState(() {
            _isListening = false;
          });
        }
      },
    );
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(minutes: 5),
      pauseFor: const Duration(seconds: 5),
      partialResults: true,
    );
    setState(() {
      _isListening = true;
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
    });
  }

  void _copyAllToClipboard() {
    Clipboard.setData(ClipboardData(text: _wordsSpoken));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Copied to clipboard',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  void _saveToNotes() {
    _saveMessageToNotes(context, _wordsSpoken);
    setState(() {
      _wordsSpoken = "";
    });
  }

  void _saveMessageToNotes(BuildContext context, String message) {
    if (authController.user == null) {
      // Handle the case where the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'Failed to save message to notes: User is not logged in',
          style: TextStyle(color: Colors.black),
        )),
      );
      return;
    }

    final Database database = Database();

    // Use the first few words of the message as the title
    final title = message.split(' ').take(5).join(' ');
    final body = message;

    try {
      // Save the note
      database.addNote(authController.user!.uid, title, body);

      // Show a confirmation to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Message saved to notes',
                style: TextStyle(color: Colors.black))),
      );
    } catch (e) {
      // Handle the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to save message to notes: $e',
                style: const TextStyle(color: Colors.black))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!_isListening && _wordsSpoken.isNotEmpty)
            IconButton(
              onPressed: _copyAllToClipboard,
              icon: const Icon(Icons.copy),
              tooltip: 'Copy all to clipboard',
            ),
        ],
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Speech Notes',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                _isListening
                    ? "listening..."
                    : _speechEnabled
                        ? "Tap the microphone to start listening..."
                        : "Speech not available",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  _wordsSpoken,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            if (!_isListening && _confidenceLevel > 0)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 100,
                ),
                child: Text(
                  "Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!_isListening && _wordsSpoken.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: FloatingActionButton(
                onPressed: _saveToNotes,
                tooltip: 'Save to notes',
                child: const Icon(Icons.save),
                backgroundColor: Colors.amber,
              ),
            ),
          FloatingActionButton(
            onPressed: () {
              if (_isListening) {
                _stopListening();
              } else {
                _startListening();
              }
            },
            tooltip: 'Listen',
            child: Icon(
              _isListening ? Icons.mic_off : Icons.mic,
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
