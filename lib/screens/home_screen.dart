import 'package:flutter/material.dart';

import '../services/press_service.dart';
import '../services/cosmetics_service.dart';
import '../widgets/press_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PressService pressService = PressService();

  Color buttonColor = const Color(0xFFE53935);

  @override
  void initState() {
    super.initState();

    loadHome();
  }

  Future<void> loadHome() async {
    await pressService.load();
    await loadEquippedButton();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadEquippedButton() async {
    try {
      final equipped =
          await CosmeticsService.getEquippedCosmetics();

      final buttonId = equipped['button'];

      final color = _getButtonColor(buttonId);

      if (mounted) {
        setState(() {
          buttonColor = color;
        });
      }
    } catch (_) {
      // Si le chargement échoue,
      // on garde le bouton rouge par défaut.
    }
  }

  Color _getButtonColor(String? buttonId) {
    switch (buttonId) {
      case 'button_ocean_blue':
        return const Color(0xFF1976D2);

      case 'button_neon_purple':
        return const Color(0xFF8E24AA);

      case 'button_golden':
        return const Color(0xFFFFB300);

      case 'button_holographic':
        return const Color(0xFF7E57C2);

      case 'button_void':
        return const Color(0xFF171717);

      case 'button_classic':
      default:
        return const Color(0xFFE53935);
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
    return SafeArea(
      bottom: false,
      child: Center(
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
              color: buttonColor,
              onPressed: onPress,
            ),
          ],
        ),
      ),
    );
  }
}