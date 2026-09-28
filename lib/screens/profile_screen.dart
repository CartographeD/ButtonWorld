import 'package:flutter/material.dart';

import '../models/player.dart';
import '../services/player_service.dart';
import 'username_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Player? player;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadPlayer();
  }

  Future<void> loadPlayer() async {
    try {
      final loadedPlayer = await PlayerService.getPlayer();

      if (mounted) {
        setState(() {
          player = loadedPlayer;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> editUsername() async {
    final username = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const UsernameScreen(),
      ),
    );

    if (username != null) {
      await loadPlayer();
    }
  }

  void showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature is coming soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F0),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : player == null
                ? const Center(
                    child: Text(
                      'Unable to load profile.',
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: loadPlayer,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        12,
                        20,
                        32,
                      ),
                      children: [
                        _buildTopBar(),
                        const SizedBox(height: 28),
                        _buildProfileHeader(),
                        const SizedBox(height: 28),
                        _buildMainStats(),
                        const SizedBox(height: 16),
                        _buildRecordCard(),
                        const SizedBox(height: 16),
                        _buildRankCard(),
                        const SizedBox(height: 28),
                        _buildAccountSection(),
                        const SizedBox(height: 16),
                        _buildSettingsButton(),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        _SmallIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        const Spacer(),
        const Text(
          'PROFILE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
          ),
        ),
        const Spacer(),
        const SizedBox(
          width: 44,
          height: 44,
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    final username = player!.username ?? 'Player';

    return Column(
      children: [
        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            color: const Color(0xFFE53935),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: Colors.white,
            size: 38,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: editUsername,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                username,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 7),
              const Icon(
                Icons.edit_outlined,
                size: 17,
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        GestureDetector(
          onTap: () {
            showComingSoon('Country selection');
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                player!.country ?? 'Country not set',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.chevron_right_rounded,
                size: 17,
                color: Colors.black.withValues(alpha: 0.45),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainStats() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.touch_app_outlined,
            label: 'PRESSES',
            value: _formatNumber(player!.presses),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.monetization_on_outlined,
            label: 'COINS',
            value: _formatNumber(player!.coins),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordCard() {
    return _LargeInfoCard(
      icon: Icons.local_fire_department_outlined,
      title: 'BEST TAP STREAK',
      value: '—',
      subtitle: 'Your best consecutive tap streak',
      onTap: () {
        showComingSoon('Tap streak statistics');
      },
    );
  }

  Widget _buildRankCard() {
    return _LargeInfoCard(
      icon: Icons.emoji_events_outlined,
      title: 'WORLD RANK',
      value: '—',
      subtitle: 'Leaderboard coming soon',
      onTap: () {
        showComingSoon('Leaderboard');
      },
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'ACCOUNT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              onTap: () {
                showComingSoon('Google Play account linking');
              },
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F0),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.account_circle_outlined,
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Link your account',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Save your progress across devices',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: () {
            showComingSoon('Settings');
          },
          borderRadius: BorderRadius.circular(18),
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 17,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.settings_outlined,
                  size: 22,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ' ',
        );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
          ),
          const SizedBox(height: 18),
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _LargeInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final VoidCallback onTap;

  const _LargeInfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.7,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SmallIconButton({
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
          width: 44,
          height: 44,
          child: Icon(
            icon,
            size: 21,
          ),
        ),
      ),
    );
  }
}