import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/menu_button.dart';
import '../widgets/press_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int presses = 0;
  int pulse = 0;

  @override
  void initState() {
    super.initState();
    loadPresses();
  }

  Future<void> loadPresses() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      presses = prefs.getInt('presses') ?? 0;
    });
  }

  Future<void> savePresses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('presses', presses);
  }

  void onPress() {
    setState(() {
      presses++;

      if (presses % 10 == 0) {
        pulse++;
      }
    });

    savePresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F0),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: MenuButton(
                icon: Icons.person_outline,
                onTap: () {},
              ),
            ),
            Positioned(
              top: 16,
              right: 68,
              child: MenuButton(
                icon: Icons.emoji_events_outlined,
                onTap: () {},
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: MenuButton(
                icon: Icons.settings_outlined,
                onTap: () {},
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$presses',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
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
                  TweenAnimationBuilder<double>(
                    key: ValueKey(pulse),
                    tween: Tween(begin: 1.0, end: 1.18),
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    builder: (context, scale, child) {
                      final s = 1.0 + (1.18 - scale);
                      return Transform.scale(scale: s, child: child);
                    },
                    child: PressButton(onPressed: onPress),
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