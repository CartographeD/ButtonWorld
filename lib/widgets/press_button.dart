import 'package:flutter/material.dart';

class PressButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PressButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 230,
        height: 230,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF6B6B),
              Color(0xFFFF2D2D),
              Color(0xFFC40000),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.45),
              blurRadius: 30,
              offset: const Offset(0, 18),
            ),
            const BoxShadow(
              color: Color(0xFF7A0000),
              blurRadius: 0,
              spreadRadius: -8,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 185,
            height: 185,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment(-0.3, -0.3),
                radius: 0.9,
                colors: [
                  Color(0xFFFF8A8A),
                  Color(0xFFFF3B3B),
                  Color(0xFFD50000),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}