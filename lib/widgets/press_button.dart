import 'package:flutter/material.dart';

class PressButton extends StatefulWidget {
  final VoidCallback onPressed;

  const PressButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<PressButton> createState() => _PressButtonState();
}

class _PressButtonState extends State<PressButton> {
  bool isPressed = false;

  void pressDown() {
    setState(() {
      isPressed = true;
    });
  }

  void pressUp() {
    setState(() {
      isPressed = false;
    });

    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => pressDown(),
      onTapUp: (_) => pressUp(),
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
        child: Container(
          width: 190,
          height: 190,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFE53935),            
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.20),
                blurRadius: isPressed ? 4 : 14,
                offset: Offset(0, isPressed ? 2 : 8),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'PRESS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}