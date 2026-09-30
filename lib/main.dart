import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/main_shell.dart';
import 'services/auth_service.dart';
import 'services/player_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AuthService.ensureSignedIn();
  await PlayerService.ensurePlayerExists();

  runApp(const ButtonWorldApp());
}

class ButtonWorldApp extends StatelessWidget {
  const ButtonWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ButtonWorld',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE53935)),
        scaffoldBackgroundColor: const Color(0xFFF4F4F0),
      ),
      home: const MainShell(),
    );
  }
}
