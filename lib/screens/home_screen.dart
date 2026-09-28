import 'package:flutter/material.dart';
import 'profile_screen.dart';
import '../services/press_service.dart';
import '../widgets/menu_button.dart';
import '../widgets/press_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PressService pressService = PressService();

  @override
  void initState() {
    super.initState();

    loadScore();
  }

  Future<void> loadScore() async {
    await pressService.load();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> onPress() async {
    await pressService.registerPress();

    if (mounted) {
      setState(() {});
    }
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: MenuButton(
                icon: Icons.emoji_events_outlined,
                onTap: () {},
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${pressService.presses}',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'PRESSES',
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