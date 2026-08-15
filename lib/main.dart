import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
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