import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const MenuButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            size: 22,
          ),
        ),
      ),
    );
  }
}