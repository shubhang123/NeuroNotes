import 'package:neuronotes/core/app/app.dart';
import 'package:neuronotes/feature/hive/model/chat_bot/chat_bot.dart';
import 'package:neuronotes/feature/notes/controllers/authController.dart';
import 'package:neuronotes/feature/notes/controllers/userController.dart';
import 'package:neuronotes/feature/notes/firebase_options.dart';
import 'package:neuronotes/feature/notes/utils/root.dart';
import 'package:neuronotes/feature/notes/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:loggy/loggy.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initLoggy();
  initGoogleFonts();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDir.path)
    ..registerAdapter(ChatBotAdapter());
  await Hive.openBox<ChatBot>('chatbots');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    Get.put<AuthController>(AuthController());
    Get.put<UserController>(UserController());
  });

  runApp(
    ProviderScope(
      child: NeuroNotes(),
    ),
  );
}

void initLoggy() {
  Loggy.initLoggy(
    logOptions: const LogOptions(
      LogLevel.all,
      stackTraceLevel: LogLevel.warning,
    ),
    logPrinter: const PrettyPrinter(),
  );
}

void initGoogleFonts() {
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
}
