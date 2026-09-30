import 'package:flutter/material.dart';

import '../widgets/bottom_navigation.dart';
import 'market_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'rank_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int currentIndex = 0;

  final screens = const [
    HomeScreen(),
    RankScreen(),
    MarketScreen(),
    ProfileScreen(),
  ];

  @override
    Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F0),
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
        bottomNavigationBar: ButtonWorldBottomNavigation(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
