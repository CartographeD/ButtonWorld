import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool soundEnabled = true;
  bool hapticEnabled = true;
  bool notificationsEnabled = true;

  bool isGoogleLinked = false;
  bool isLinkingGoogle = false;

  @override
  void initState() {
    super.initState();

    loadSettings();
  }

  // ─────────────────────────────────────
  // LOAD
  // ─────────────────────────────────────

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) {
      return;
    }

    setState(() {
      soundEnabled =
          prefs.getBool('sound_enabled') ?? true;

      hapticEnabled =
          prefs.getBool('haptic_enabled') ?? true;

      notificationsEnabled =
          prefs.getBool('notifications_enabled') ?? true;

      isGoogleLinked =
          AuthService.isGoogleLinked;
    });
  }

  // ─────────────────────────────────────
  // SOUND
  // ─────────────────────────────────────

  Future<void> setSoundEnabled(bool value) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      'sound_enabled',
      value,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      soundEnabled = value;
    });
  }

  // ─────────────────────────────────────
  // HAPTIC
  // ─────────────────────────────────────

  Future<void> setHapticEnabled(bool value) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      'haptic_enabled',
      value,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      hapticEnabled = value;
    });
  }

  // ─────────────────────────────────────
  // NOTIFICATIONS
  // ─────────────────────────────────────

  Future<void> setNotificationsEnabled(
    bool value,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      'notifications_enabled',
      value,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      notificationsEnabled = value;
    });
  }

  // ─────────────────────────────────────
  // GOOGLE
  // ─────────────────────────────────────

  Future<void> linkGoogle() async {
    if (isGoogleLinked || isLinkingGoogle) {
      return;
    }

    setState(() {
      isLinkingGoogle = true;
    });

    try {
      await AuthService.linkGoogleAccount();

      if (!mounted) {
        return;
      }

      setState(() {
        isGoogleLinked = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Google account linked successfully.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      String message =
          'Unable to link Google account.';

      final error = e.toString();

      if (error.contains(
        'credential-already-in-use',
      )) {
        message =
            'This Google account is already linked to another account.';
      } else if (error.contains(
        'provider-already-linked',
      )) {
        message =
            'Google account is already linked.';
      } else if (error.contains(
        'canceled',
      )) {
        message =
            'Google sign-in was cancelled.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLinkingGoogle = false;
        });
      }
    }
  }

  // ─────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF4F4F0),
      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            40,
          ),
          children: [
            _buildTopBar(),

            const SizedBox(height: 24),

            _buildHeader(),

            const SizedBox(height: 28),

            // ─────────────────────────────
            // GAME
            // ─────────────────────────────

            _buildSectionTitle('GAME'),

            const SizedBox(height: 12),

            _buildSwitchCard(
              icon:
                  Icons.volume_up_outlined,
              title: 'SOUND',
              description:
                  'Press sounds & effects',
              value: soundEnabled,
              onChanged:
                  setSoundEnabled,
            ),

            const SizedBox(height: 10),

            _buildSwitchCard(
              icon:
                  Icons.vibration_outlined,
              title: 'HAPTIC FEEDBACK',
              description:
                  'Vibration on press',
              value: hapticEnabled,
              onChanged:
                  setHapticEnabled,
            ),

            const SizedBox(height: 10),

            _buildSwitchCard(
              icon:
                  Icons.notifications_outlined,
              title: 'NOTIFICATIONS',
              description:
                  'Reminders & game events',
              value: notificationsEnabled,
              onChanged:
                  setNotificationsEnabled,
            ),

            const SizedBox(height: 28),

            // ─────────────────────────────
            // ACCOUNT
            // ─────────────────────────────

            _buildSectionTitle('ACCOUNT'),

            const SizedBox(height: 12),

            _buildGoogleCard(),

            const SizedBox(height: 28),

            // ─────────────────────────────
            // APP
            // ─────────────────────────────

            _buildSectionTitle('APP'),

            const SizedBox(height: 12),

            _buildActionCard(
              icon:
                  Icons.language_outlined,
              title: 'LANGUAGE',
              description: 'English',
              onTap: () {
                showComingSoon(
                  'Language selection',
                );
              },
            ),

            const SizedBox(height: 10),

            _buildActionCard(
              icon:
                  Icons.info_outline_rounded,
              title: 'ABOUT BUTTONWORLD',
              description:
                  'Version 1.0.0',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName:
                      'ButtonWorld',
                  applicationVersion:
                      '1.0.0',
                  applicationLegalese:
                      '© ButtonWorld',
                );
              },
            ),

            const SizedBox(height: 28),

            // ─────────────────────────────
            // SUPPORT
            // ─────────────────────────────

            _buildSectionTitle('SUPPORT'),

            const SizedBox(height: 12),

            _buildActionCard(
              icon:
                  Icons.favorite_border_rounded,
              title: 'RATE BUTTONWORLD',
              description:
                  'Google Play page coming soon',
              onTap: () {
                showComingSoon(
                  'Google Play rating',
                );
              },
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // TOP BAR
  // ─────────────────────────────────────

  Widget _buildTopBar() {
    return Row(
      children: [
        _SmallIconButton(
          icon:
              Icons.arrow_back_rounded,
          onTap: () {
            Navigator.pop(context);
          },
        ),

        const Spacer(),

        const SizedBox(
          width: 44,
          height: 44,
        ),
      ],
    );
  }

  // ─────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding:
          const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.05),
            blurRadius: 25,
            offset:
                const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color:
                  const Color(0xFFE53935),
              borderRadius:
                  BorderRadius.circular(19),
            ),
            child: const Icon(
              Icons.settings_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'SETTINGS',
            style: TextStyle(
              fontSize: 30,
              fontWeight:
                  FontWeight.w900,
              letterSpacing: -1,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Customize your experience.',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────
  // SECTION
  // ─────────────────────────────────────

  Widget _buildSectionTitle(
    String title,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight:
              FontWeight.w900,
          letterSpacing: 2.2,
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // SWITCH CARD
  // ─────────────────────────────────────

  Widget _buildSwitchCard({
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool>
        onChanged,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _IconBox(icon: icon),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style:
                      const TextStyle(
                    fontSize: 12,
                    color:
                        Colors.black45,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────
  // GOOGLE
  // ─────────────────────────────────────

  Widget _buildGoogleCard() {
    final linked =
        isGoogleLinked;

    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: linked
              ? const Color(0xFFE53935)
                  .withValues(alpha: 0.12)
              : Colors.transparent,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              linked ||
                      isLinkingGoogle
                  ? null
                  : linkGoogle,
          borderRadius:
              BorderRadius.circular(20),
          child: Row(
            children: [
              _IconBox(
                icon: Icons
                    .account_circle_outlined,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const Text(
                      'GOOGLE ACCOUNT',
                      style:
                          TextStyle(
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w900,
                        letterSpacing:
                            0.8,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      isLinkingGoogle
                          ? 'Connecting...'
                          : linked
                              ? 'Account linked'
                              : 'Link your Google account',
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color:
                            Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              if (isLinkingGoogle)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              else if (linked)
                Container(
                  width: 30,
                  height: 30,
                  decoration:
                      const BoxDecoration(
                    color:
                        Color(0xFFE53935),
                    shape:
                        BoxShape.circle,
                  ),
                  child:
                      const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                )
              else
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

  // ─────────────────────────────────────
  // ACTION CARD
  // ─────────────────────────────────────

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(20),
          child: Row(
            children: [
              _IconBox(icon: icon),

              const SizedBox(width: 14),

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
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w900,
                        letterSpacing:
                            0.8,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      description,
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color:
                            Colors.black45,
                      ),
                    ),
                  ],
                ),
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

  // ─────────────────────────────────────
  // COMING SOON
  // ─────────────────────────────────────

  void showComingSoon(
    String feature,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          '$feature is coming soon.',
        ),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }
}

// ─────────────────────────────────────────
// ICON BOX
// ─────────────────────────────────────────

class _IconBox
    extends StatelessWidget {
  final IconData icon;

  const _IconBox({
    required this.icon,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color:
            const Color(0xFFF4F4F0),
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: Icon(
        icon,
        size: 22,
      ),
    );
  }
}

// ─────────────────────────────────────────
// SMALL ICON BUTTON
// ─────────────────────────────────────────

class _SmallIconButton
    extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SmallIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Material(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(14),
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