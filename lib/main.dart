import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';

import 'services/player_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('1 - Flutter OK');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('2 - Firebase OK');

  await AuthService.ensureSignedIn();

  print('3 - Auth OK');

  await PlayerService.ensurePlayerExists();

  print('4 - Player OK');

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
      ),
      home: const HomeScreen(),
    );
  }
}