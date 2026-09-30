import 'package:flutter/material.dart';

import '../data/countries.dart';
import '../models/player.dart';
import '../services/player_service.dart';
import 'country_screen.dart';
import 'goals_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  Player? player;

  bool isLoading = true;

  int? worldRank;

  @override
  void initState() {
    super.initState();

    loadPlayer();
  }

  Future<void> loadPlayer() async {
    try {
      final loadedPlayer =
          await PlayerService.getPlayer();

      if (!mounted) return;

      setState(() {
        player = loadedPlayer;
        isLoading = false;
      });

      // Le classement est indépendant du chargement
      // du profil.
      try {
        final loadedWorldRank =
            await PlayerService.getWorldRank();

        if (mounted) {
          setState(() {
            worldRank = loadedWorldRank;
          });
        }
      } catch (e) {
        debugPrint(
          'Unable to load world rank: $e',
        );
      }
    } catch (e) {
      debugPrint(
        'Unable to load profile: $e',
      );

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> chooseCountry() async {
    final selectedCountry =
        await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => CountryScreen(
          selectedCountry: player?.country,
        ),
      ),
    );

    if (selectedCountry != null) {
      await loadPlayer();
    }
  }

  void showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature is coming soon.',
        ),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  String getCountryFlag(
    String? countryName,
  ) {
    if (countryName == null ||
        countryName.isEmpty) {
      return '🌍';
    }

    for (final country in countries) {
      if (country.name == countryName) {
        return country.flag;
      }
    }

    return '🌍';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
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
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.fromLTRB(
                      20,
                      12,
                      20,
                      32,
                    ),
                    children: [
                      const SizedBox(height: 16),

                      _buildProfileHeader(),

                      const SizedBox(height: 28),

                      _buildMainStats(),

                      const SizedBox(height: 16),

                      _buildRecordCard(),

                      const SizedBox(height: 16),

                      _buildRankCard(),

                      const SizedBox(height: 28),

                      _buildGoalsSection(),

                      const SizedBox(height: 16),

                      _buildSettingsButton(),
                    ],
                  ),
                ),
    );
  }

  // ─────────────────────────────────────
  // PROFILE HEADER
  // ─────────────────────────────────────

  Widget _buildProfileHeader() {
    final username =
        player!.username ?? 'Player';

    final hasCountry =
        player!.country != null &&
        player!.country!.isNotEmpty;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showComingSoon(
              'Profile customization',
            );
          },
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color:
                  const Color(0xFFE53935),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset:
                      const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons
                  .person_outline_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ─────────────────────────────
        // PSEUDO
        // ─────────────────────────────

        Text(
          username,
          style: const TextStyle(
            fontSize: 26,
            fontWeight:
                FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 7),

        // ─────────────────────────────
        // COUNTRY
        // ─────────────────────────────

        GestureDetector(
          onTap: chooseCountry,
          child: Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration:
                BoxDecoration(
              color: hasCountry
                  ? Colors.white
                  : const Color(
                      0xFFECECE8,
                    ),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Text(
                  getCountryFlag(
                    player!.country,
                  ),
                  style:
                      const TextStyle(
                    fontSize: 18,
                  ),
                ),

                const SizedBox(
                  width: 7,
                ),

                Text(
                  hasCountry
                      ? player!.country!
                      : 'Choose your country',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        hasCountry
                            ? FontWeight.w700
                            : FontWeight.w600,
                    color: hasCountry
                        ? Colors.black87
                        : Colors.black54,
                  ),
                ),

                const SizedBox(
                  width: 3,
                ),

                Icon(
                  Icons
                      .chevron_right_rounded,
                  size: 17,
                  color: Colors.black
                      .withValues(
                    alpha: 0.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────
  // MAIN STATS
  // ─────────────────────────────────────

  Widget _buildMainStats() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon:
                Icons.touch_app_outlined,
            label: 'TAPS',
            value:
                _formatNumber(
              player!.presses,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _StatCard(
            icon: Icons
                .monetization_on_outlined,
            label: 'COINS',
            value:
                _formatNumber(
              player!.coins,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────
  // BEST TAP STREAK
  // ─────────────────────────────────────

  Widget _buildRecordCard() {
    return _LargeInfoCard(
      icon: Icons
          .local_fire_department_outlined,
      title: 'BEST TAP STREAK',
      value:
          _formatNumber(
        player!.bestTapStreak,
      ),
      subtitle:
          'Your best consecutive taps',
      onTap: () {},
    );
  }

  // ─────────────────────────────────────
  // WORLD RANK
  // ─────────────────────────────────────

  Widget _buildRankCard() {
    return _LargeInfoCard(
      icon:
          Icons.emoji_events_outlined,
      title: 'WORLD RANK',
      value: worldRank != null
          ? '#${_formatNumber(worldRank!)}'
          : '—',
      subtitle:
          'Your position in the world',
      onTap: () {},
    );
  }

  // ─────────────────────────────────────
  // GOALS
  // ─────────────────────────────────────

  Widget _buildGoalsSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 4,
            bottom: 10,
          ),
          child: Text(
            'PROGRESSION',
            style: TextStyle(
              fontSize: 11,
              fontWeight:
                  FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(18),
          ),
          child: Material(
            color:
                Colors.transparent,
            borderRadius:
                BorderRadius.circular(
              18,
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const GoalsScreen(),
                  ),
                );
              },
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
              child: const Padding(
                padding:
                    EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 17,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons
                          .track_changes_outlined,
                      size: 22,
                    ),

                    SizedBox(
                      width: 14,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            'Goals',
                            style:
                                TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),

                          SizedBox(
                            height: 3,
                          ),

                          Text(
                            'Milestones & achievements',
                            style:
                                TextStyle(
                              fontSize: 12,
                              color: Colors
                                  .black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Icon(
                      Icons
                          .chevron_right_rounded,
                      color:
                          Colors.black45,
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

  // ─────────────────────────────────────
  // SETTINGS
  // ─────────────────────────────────────

  Widget _buildSettingsButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Material(
        color:
            Colors.transparent,
        borderRadius:
            BorderRadius.circular(18),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const SettingsScreen(),
              ),
            );
          },
          borderRadius:
              BorderRadius.circular(18),
          child: const Padding(
            padding:
                EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 17,
            ),
            child: Row(
              children: [
                Icon(
                  Icons
                      .settings_outlined,
                  size: 22,
                ),

                SizedBox(
                  width: 14,
                ),

                Expanded(
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),

                Icon(
                  Icons
                      .chevron_right_rounded,
                  color:
                      Colors.black45,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // NUMBER FORMAT
  // ─────────────────────────────────────

  String _formatNumber(int number) {
    return number
        .toString()
        .replaceAllMapped(
          RegExp(
            r'\B(?=(\d{3})+(?!\d))',
          ),
          (match) => ' ',
        );
  }
}

// ─────────────────────────────────────────
// STAT CARD
// ─────────────────────────────────────────

class _StatCard
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
          ),

          const SizedBox(
            height: 18,
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight:
                  FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight:
                  FontWeight.w700,
              letterSpacing: 1.8,
              color:
                  Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// LARGE INFO CARD
// ─────────────────────────────────────────

class _LargeInfoCard
    extends StatelessWidget {
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
  Widget build(
    BuildContext context,
  ) {
    return Material(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(18),
        child: Padding(
          padding:
              const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFF4F4F0,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 24,
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(
                        fontSize: 10,
                        fontWeight:
                            FontWeight
                                .w700,
                        letterSpacing:
                            1.7,
                        color: Colors
                            .black54,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      subtitle,
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color:
                            Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Text(
                value,
                style:
                    const TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(
                width: 4,
              ),

              const Icon(
                Icons
                    .chevron_right_rounded,
                color:
                    Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}