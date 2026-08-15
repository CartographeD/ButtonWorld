import 'package:flutter/material.dart';

import '../widgets/menu_button.dart';
import '../widgets/press_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int presses = 0;

  void onPress() {
    setState(() {
      presses++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F0),
      body: SafeArea(
        child: Stack(
          children: [
            // Profil
            Positioned(
              top: 16,
              left: 16,
              child: MenuButton(
                icon: Icons.person_outline,
                onTap: () {},
              ),
            ),

            // Leaderboard
            Positioned(
              top: 16,
              right: 68,
              child: MenuButton(
                icon: Icons.emoji_events_outlined,
                onTap: () {},
              ),
            ),

            // Paramètres
            Positioned(
              top: 16,
              right: 16,
              child: MenuButton(
                icon: Icons.settings_outlined,
                onTap: () {},
              ),
            ),

            // Contenu central
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$presses',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'TAPS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3,
                    ),
                  ),

                  const SizedBox(height: 45),

                  PressButton(
                    onPressed: onPress,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}