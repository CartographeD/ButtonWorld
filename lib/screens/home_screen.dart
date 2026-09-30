import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/cosmetics_service.dart';
import '../services/press_service.dart';
import '../widgets/press_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final PressService pressService = PressService();

  String buttonId = 'button_classic';
  String effectId = 'effect_default';
  String counterId = 'counter_classic';

  late AnimationController _counterController;
  late AnimationController _streakController;
  late AnimationController _effectController;

  @override
  void initState() {
    super.initState();

    _counterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _streakController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _effectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    loadHome();
  }

  @override
  void dispose() {
    _counterController.dispose();
    _streakController.dispose();
    _effectController.dispose();

    super.dispose();
  }

  // ─────────────────────────────────────
  // LOAD
  // ─────────────────────────────────────

  Future<void> loadHome() async {
    await pressService.load();
    await loadEquippedCosmetics();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> refreshCosmetics() async {
      await loadEquippedCosmetics();
  }

  Future<void> loadEquippedCosmetics() async {
    try {
      final equipped =
          await CosmeticsService.getEquippedCosmetics();

      if (!mounted) return;

      setState(() {
        buttonId = equipped['button'] ?? 'button_classic';
        effectId = equipped['effect'] ?? 'effect_default';
        counterId = equipped['counter'] ?? 'counter_classic';
      });
    } catch (_) {
      // Cosmétiques par défaut.
    }
  }

  // ─────────────────────────────────────
  // TAP
  // ─────────────────────────────────────

  Future<void> onPress() async {
    final previousStreak = pressService.tapStreak;

    await pressService.registerPress();

    _counterController.forward(from: 0);
    _effectController.forward(from: 0);

    if (pressService.tapStreak > previousStreak) {
      _streakController.forward(from: 0);
    }

    if (mounted) {
      setState(() {});
    }
  }

  // ─────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final streak = pressService.tapStreak;

    return SafeArea(
      bottom: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCounter(),

            const SizedBox(height: 8),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: streak >= 2
                  ? _buildStreak(streak)
                  : const SizedBox(height: 22),
            ),

            const SizedBox(height: 35),

            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                _buildEffect(),
                _buildButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // COUNTER
  // ─────────────────────────────────────

  Widget _buildCounter() {
    return AnimatedBuilder(
      animation: _counterController,
      builder: (context, child) {
        final progress = _counterController.value;

        double scale = 1;
        double y = 0;

        switch (counterId) {
          case 'counter_bounce':
            scale = 1 +
                Curves.elasticOut.transform(progress) * 0.18;
            break;

          case 'counter_float':
            y = -math.sin(progress * math.pi) * 12;
            scale = 1 +
                math.sin(progress * math.pi) * 0.04;
            break;

          case 'counter_glitch':
            final glitch =
                math.sin(progress * math.pi * 12);

            y = glitch * 2;
            scale = 1 + glitch * 0.035;
            break;

          case 'counter_particles':
            scale = 1 +
                math.sin(progress * math.pi) * 0.09;
            break;

          case 'counter_classic':
          default:
            scale = 1 +
                math.sin(progress * math.pi) * 0.035;
        }

        return Transform.translate(
          offset: Offset(0, y),
          child: Transform.scale(
            scale: scale,
            child: child,
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (counterId == 'counter_particles')
            AnimatedBuilder(
              animation: _counterController,
              builder: (context, _) {
                return SizedBox(
                  width: 150,
                  height: 70,
                  child: CustomPaint(
                    painter: _CounterParticlePainter(
                      progress: _counterController.value,
                    ),
                  ),
                );
              },
            ),

          if (counterId == 'counter_glitch')
            AnimatedBuilder(
              animation: _counterController,
              builder: (context, _) {
                final p = _counterController.value;
                final glitch =
                    math.sin(p * math.pi * 12);

                return Transform.translate(
                  offset: Offset(glitch * 5, 0),
                  child: Opacity(
                    opacity: 0.35,
                    child: Text(
                      _formatNumber(
                        pressService.presses,
                      ),
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                        color: Color(0xFF00BCD4),
                      ),
                    ),
                  ),
                );
              },
            ),

          Text(
            _formatNumber(
              pressService.presses,
            ),
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────
  // STREAK
  // ─────────────────────────────────────

  Widget _buildStreak(int streak) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.75,
        end: 1,
      ).animate(
        CurvedAnimation(
          parent: _streakController,
          curve: Curves.easeOutBack,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 18,
            color: _getStreakColor(streak),
          ),

          const SizedBox(width: 5),

          Text(
            '$streak',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: _getStreakColor(streak),
            ),
          ),

          const SizedBox(width: 5),

          const Text(
            'STREAK',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.7,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStreakColor(int streak) {
    if (streak >= 30) {
      return const Color(0xFFE53935);
    }

    if (streak >= 15) {
      return const Color(0xFFFF7043);
    }

    if (streak >= 5) {
      return const Color(0xFFFF9800);
    }

    return Colors.black87;
  }

  // ─────────────────────────────────────
  // BUTTON
  // ─────────────────────────────────────

  Widget _buildButton() {
    return Container(
      width: 210,
      height: 210,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: _getButtonGradient(),
        boxShadow: [
          BoxShadow(
            color: _getButtonShadowColor().withValues(
              alpha: 0.30,
            ),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _getButtonInnerGradient(),
          ),
          child: PressButton(
            color: Colors.transparent,
            onPressed: onPress,
          ),
        ),
      ),
    );
  }

  LinearGradient _getButtonGradient() {
    switch (buttonId) {
      case 'button_ocean_blue':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF42A5F5),
            Color(0xFF1565C0),
          ],
        );

      case 'button_neon_purple':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFCE93D8),
            Color(0xFF7B1FA2),
          ],
        );

      case 'button_golden':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFD54F),
            Color(0xFFFF8F00),
          ],
        );

      case 'button_holographic':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF80AB),
            Color(0xFF7C4DFF),
            Color(0xFF40C4FF),
          ],
        );

      case 'button_void':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF424242),
            Color(0xFF090909),
          ],
        );

      case 'button_classic':
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF5252),
            Color(0xFFC62828),
          ],
        );
    }
  }

  LinearGradient _getButtonInnerGradient() {
    switch (buttonId) {
      case 'button_holographic':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x66FFFFFF),
            Color(0x11FFFFFF),
          ],
        );

      case 'button_golden':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x66FFFFFF),
            Color(0x00FFFFFF),
          ],
        );

      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x44FFFFFF),
            Color(0x00FFFFFF),
          ],
        );
    }
  }

  Color _getButtonShadowColor() {
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
        return Colors.black;

      case 'button_classic':
      default:
        return const Color(0xFFE53935);
    }
  }

  // ─────────────────────────────────────
  // EFFECTS
  // ─────────────────────────────────────

  Widget _buildEffect() {
    if (effectId == 'effect_default') {
      return const SizedBox(
        width: 300,
        height: 300,
      );
    }

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _effectController,
        builder: (context, child) {
          return SizedBox(
            width: 300,
            height: 300,
            child: CustomPaint(
              painter: _EffectPainter(
                effectId: effectId,
                progress: _effectController.value,
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────
  // FORMAT
  // ─────────────────────────────────────

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ' ',
        );
  }
}

// ─────────────────────────────────────────
// EFFECT PAINTER
// ─────────────────────────────────────────

class _EffectPainter extends CustomPainter {
  final String effectId;
  final double progress;

  _EffectPainter({
    required this.effectId,
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    switch (effectId) {
      case 'effect_sparks':
        _paintSparks(canvas, center);
        break;

      case 'effect_electric':
        _paintElectric(canvas, center);
        break;

      case 'effect_fire':
        _paintFire(canvas, center);
        break;

      case 'effect_glitch':
        _paintGlitch(canvas, center);
        break;

      case 'effect_cosmic':
        _paintCosmic(canvas, center);
        break;
    }
  }

  void _paintSparks(
    Canvas canvas,
    Offset center,
  ) {
    final progress = this.progress;

    final paint = Paint()
      ..color = const Color(0xFFFFB300)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final radius = 70 + progress * 70;
    final opacity = 1 - progress;

    paint.color = const Color(0xFFFFB300).withValues(
      alpha: opacity,
    );

    for (int i = 0; i < 12; i++) {
      final angle =
          i * math.pi * 2 / 12;

      final startRadius = 62.0;
      final endRadius = radius;

      final start = Offset(
        center.dx +
            math.cos(angle) * startRadius,
        center.dy +
            math.sin(angle) * startRadius,
      );

      final end = Offset(
        center.dx +
            math.cos(angle) * endRadius,
        center.dy +
            math.sin(angle) * endRadius,
      );

      canvas.drawLine(
        start,
        end,
        paint,
      );

      canvas.drawCircle(
        end,
        3.5 * (1 - progress),
        paint,
      );
    }
  }

  void _paintElectric(
    Canvas canvas,
    Offset center,
  ) {
    final progress = this.progress;

    final paint = Paint()
      ..color = const Color(0xFF42A5F5).withValues(
        alpha: 1 - progress,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 4; i++) {
      final path = Path();

      final startAngle =
          i * math.pi / 2 +
              progress * 0.8;

      for (int p = 0; p <= 7; p++) {
        final t = p / 7;
        final angle =
            startAngle +
                t * math.pi / 2;

        final r =
            65 +
            math.sin(
                  p * 4.0 +
                      i * 2 +
                      progress * 12,
                ) *
                10;

        final point = Offset(
          center.dx +
              math.cos(angle) * r,
          center.dy +
              math.sin(angle) * r,
        );

        if (p == 0) {
          path.moveTo(
            point.dx,
            point.dy,
          );
        } else {
          path.lineTo(
            point.dx,
            point.dy,
          );
        }
      }

      canvas.drawPath(
        path,
        paint,
      );
    }
  }

  void _paintFire(
    Canvas canvas,
    Offset center,
  ) {
    final progress = this.progress;

    for (int i = 0; i < 16; i++) {
      final angle =
          i * math.pi * 2 / 16;

      final distance =
          72 +
          progress * 48;

      final x =
          center.dx +
              math.cos(angle) * distance;

      final y =
          center.dy +
              math.sin(angle) * distance -
              math.sin(progress * math.pi) *
                  18;

      final size =
          8 * (1 - progress) + 2;

      final paint = Paint()
        ..color = Color.lerp(
          const Color(0xFFFFD54F),
          const Color(0xFFE53935),
          progress,
        )!
            .withValues(
          alpha: 1 - progress,
        );

      canvas.drawCircle(
        Offset(x, y),
        size,
        paint,
      );
    }
  }

  void _paintGlitch(
    Canvas canvas,
    Offset center,
  ) {
    final progress = this.progress;

    final opacity =
        math.sin(progress * math.pi);

    final colors = [
      const Color(0xFFFF1744),
      const Color(0xFF00E5FF),
      const Color(0xFF7C4DFF),
    ];

    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..color = colors[i].withValues(
          alpha: opacity * 0.8,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5;

      final offset =
          math.sin(
                progress * math.pi * 18 +
                    i,
              ) *
              12;

      canvas.drawCircle(
        Offset(
          center.dx + offset,
          center.dy,
        ),
        72 + progress * 25,
        paint,
      );
    }

    final rectPaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(
        alpha: opacity * 0.7,
      );

    for (int i = 0; i < 5; i++) {
      final x =
          center.dx -
              70 +
              i * 35 +
              math.sin(
                    progress * math.pi * 20 +
                        i,
                  ) *
                  8;

      canvas.drawRect(
        Rect.fromLTWH(
          x,
          center.dy - 55 + i * 25,
          20 + i * 4,
          5,
        ),
        rectPaint,
      );
    }
  }

  void _paintCosmic(
    Canvas canvas,
    Offset center,
  ) {
    final progress = this.progress;

    final opacity = 1 - progress;

    for (int i = 0; i < 24; i++) {
      final angle =
          i * math.pi * 2 / 24 +
              progress * 2.5;

      final radius =
          55 +
          progress * 90;

      final point = Offset(
        center.dx +
            math.cos(angle) * radius,
        center.dy +
            math.sin(angle) * radius,
      );

      final paint = Paint()
        ..color = const Color(0xFF7E57C2).withValues(
          alpha: opacity,
        );

      canvas.drawCircle(
        point,
        2.5 + (1 - progress) * 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _EffectPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress ||
        oldDelegate.effectId != effectId;
  }
}

// ─────────────────────────────────────────
// COUNTER PARTICLES
// ─────────────────────────────────────────

class _CounterParticlePainter extends CustomPainter {
  final double progress;

  _CounterParticlePainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final paint = Paint();

    for (int i = 0; i < 8; i++) {
      final angle =
          i * math.pi * 2 / 8;

      final radius =
          25 + progress * 35;

      final point = Offset(
        center.dx +
            math.cos(angle) * radius,
        center.dy +
            math.sin(angle) * radius,
      );

      paint.color =
          const Color(0xFFFFB300).withValues(
        alpha: 1 - progress,
      );

      canvas.drawCircle(
        point,
        2.5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _CounterParticlePainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}