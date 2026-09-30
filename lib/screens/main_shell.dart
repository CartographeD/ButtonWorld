import 'package:flutter/material.dart';

import '../widgets/bottom_navigation.dart';
import 'home_screen.dart';
import 'market_screen.dart';
import 'profile_screen.dart';
import 'rank_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int currentIndex = 0;

  // ─────────────────────────────────────
  // HOME KEY
  // ─────────────────────────────────────

  final GlobalKey<HomeScreenState> homeKey =
      GlobalKey<HomeScreenState>();

  // ─────────────────────────────────────
  // SCREENS
  // ─────────────────────────────────────

  late final List<Widget> screens = [
    HomeScreen(key: homeKey),
    const RankScreen(),
    const MarketScreen(),
    const ProfileScreen(),
  ];

  // ─────────────────────────────────────
  // NAVIGATION
  // ─────────────────────────────────────

  void onNavigationTap(int index) {
    setState(() {
      currentIndex = index;
    });

    // Quand on revient sur HOME,
    // on recharge les cosmétiques équipés.
    if (index == 0) {
      homeKey.currentState?.refreshCosmetics();
    }
  }

  // ─────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────

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

        bottomNavigationBar:
            ButtonWorldBottomNavigation(
          currentIndex: currentIndex,
          onTap: onNavigationTap,
        ),
      ),
    );
  }
}