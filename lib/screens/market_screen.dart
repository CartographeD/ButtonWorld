import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/cosmetics_service.dart';
import '../services/player_service.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() =>
      _MarketScreenState();
}

class _MarketScreenState
    extends State<MarketScreen> {
  int selectedCategory = 0;

  int coins = 0;
  bool isLoading = true;

  List<String> ownedCosmetics = [];
  Map<String, String> equippedCosmetics = {};

  final List<String> categories = [
    'BUTTON',
    'EFFECT',
    'SOUND',
    'COUNTER',
  ];

  final Map<String, List<MarketItem>> items = {
    'BUTTON': [
      const MarketItem(
        id: 'button_classic',
        name: 'Classic Red',
        description:
            'The original ButtonWorld button.',
        price: 0,
        type: MarketItemType.button,
        previewColor:
            Color(0xFFE53935),
      ),
      const MarketItem(
        id: 'button_ocean_blue',
        name: 'Ocean Blue',
        description:
            'A clean deep blue finish.',
        price: 500,
        type: MarketItemType.button,
        previewColor:
            Color(0xFF1976D2),
      ),
      const MarketItem(
        id: 'button_neon_purple',
        name: 'Neon Purple',
        description:
            'A bright neon purple button.',
        price: 1000,
        type: MarketItemType.button,
        previewColor:
            Color(0xFF8E24AA),
      ),
      const MarketItem(
        id: 'button_golden',
        name: 'Golden',
        description:
            'A special golden finish.',
        price: 2500,
        type: MarketItemType.button,
        previewColor:
            Color(0xFFFFB300),
      ),
      const MarketItem(
        id: 'button_holographic',
        name: 'Holographic',
        description:
            'A rare holographic appearance.',
        price: 5000,
        type: MarketItemType.button,
        previewColor:
            Color(0xFF7E57C2),
      ),
      const MarketItem(
        id: 'button_void',
        name: 'Void',
        description:
            'Dark. Simple. Absolute.',
        price: 7500,
        type: MarketItemType.button,
        previewColor:
            Color(0xFF171717),
      ),
    ],
    'EFFECT': [
      const MarketItem(
        id: 'effect_default',
        name: 'Default',
        description:
            'The classic press effect.',
        price: 0,
        type: MarketItemType.effect,
        previewColor:
            Color(0xFFE53935),
      ),
      const MarketItem(
        id: 'effect_sparks',
        name: 'Sparks',
        description:
            'Small sparks burst from the button.',
        price: 500,
        type: MarketItemType.effect,
        previewColor:
            Color(0xFFFFB300),
      ),
      const MarketItem(
        id: 'effect_electric',
        name: 'Electric',
        description:
            'An electric pulse on every press.',
        price: 1000,
        type: MarketItemType.effect,
        previewColor:
            Color(0xFF42A5F5),
      ),
      const MarketItem(
        id: 'effect_fire',
        name: 'Fire',
        description:
            'A short burst of flames.',
        price: 1500,
        type: MarketItemType.effect,
        previewColor:
            Color(0xFFFF7043),
      ),
      const MarketItem(
        id: 'effect_glitch',
        name: 'Glitch',
        description:
            'A digital glitch effect.',
        price: 2500,
        type: MarketItemType.effect,
        previewColor:
            Color(0xFF7E57C2),
      ),
      const MarketItem(
        id: 'effect_cosmic',
        name: 'Cosmic',
        description:
            'A small cosmic explosion.',
        price: 5000,
        type: MarketItemType.effect,
        previewColor:
            Color(0xFF5C6BC0),
      ),
    ],
    'SOUND': [
      const MarketItem(
        id: 'sound_classic',
        name: 'Classic',
        description:
            'The original ButtonWorld sound.',
        price: 0,
        type: MarketItemType.sound,
        previewColor:
            Color(0xFFE53935),
      ),
      const MarketItem(
        id: 'sound_arcade',
        name: 'Arcade',
        description:
            'A satisfying arcade-style click.',
        price: 500,
        type: MarketItemType.sound,
        previewColor:
            Color(0xFF42A5F5),
      ),
      const MarketItem(
        id: 'sound_mechanical',
        name: 'Mechanical',
        description:
            'A heavier mechanical press.',
        price: 750,
        type: MarketItemType.sound,
        previewColor:
            Color(0xFF78909C),
      ),
      const MarketItem(
        id: 'sound_laser',
        name: 'Laser',
        description:
            'A short futuristic laser sound.',
        price: 1000,
        type: MarketItemType.sound,
        previewColor:
            Color(0xFF26A69A),
      ),
      const MarketItem(
        id: 'sound_glitch',
        name: 'Glitch',
        description:
            'A distorted digital click.',
        price: 1500,
        type: MarketItemType.sound,
        previewColor:
            Color(0xFFAB47BC),
      ),
      const MarketItem(
        id: 'sound_retro',
        name: 'Retro',
        description:
            'A classic retro game sound.',
        price: 2000,
        type: MarketItemType.sound,
        previewColor:
            Color(0xFFFFA726),
      ),
    ],
    'COUNTER': [
      const MarketItem(
        id: 'counter_classic',
        name: 'Classic',
        description:
            'The clean default counter animation.',
        price: 0,
        type: MarketItemType.counter,
        previewColor:
            Color(0xFFE53935),
      ),
      const MarketItem(
        id: 'counter_bounce',
        name: 'Bounce',
        description:
            'The number bounces when it changes.',
        price: 500,
        type: MarketItemType.counter,
        previewColor:
            Color(0xFF42A5F5),
      ),
      const MarketItem(
        id: 'counter_float',
        name: 'Float',
        description:
            'Numbers gently float upward.',
        price: 750,
        type: MarketItemType.counter,
        previewColor:
            Color(0xFF26A69A),
      ),
      const MarketItem(
        id: 'counter_glitch',
        name: 'Glitch',
        description:
            'A quick digital glitch animation.',
        price: 1500,
        type: MarketItemType.counter,
        previewColor:
            Color(0xFF8E24AA),
      ),
      const MarketItem(
        id: 'counter_particles',
        name: 'Particles',
        description:
            'Small particles appear around the score.',
        price: 2500,
        type: MarketItemType.counter,
        previewColor:
            Color(0xFFFFB300),
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    loadMarket();
  }

  Future<void> loadMarket() async {
    try {
      final player =
          await PlayerService.getPlayer();

      final owned =
          await CosmeticsService
              .getOwnedCosmetics();

      final equipped =
          await CosmeticsService
              .getEquippedCosmetics();

      if (!mounted) return;

      setState(() {
        coins = player.coins;
        ownedCosmetics = owned;
        equippedCosmetics =
            equipped;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  String _categoryKey(
    MarketItemType type,
  ) {
    switch (type) {
      case MarketItemType.button:
        return 'button';
      case MarketItemType.effect:
        return 'effect';
      case MarketItemType.sound:
        return 'sound';
      case MarketItemType.counter:
        return 'counter';
    }
  }

  bool _isOwned(
    MarketItem item,
  ) {
    return ownedCosmetics
        .contains(item.id);
  }

  bool _isEquipped(
    MarketItem item,
  ) {
    final category =
        _categoryKey(item.type);

    return equippedCosmetics[
            category] ==
        item.id;
  }

  Future<void> _buyOrEquip(
    MarketItem item,
  ) async {
    final owned =
        _isOwned(item);

    final equipped =
        _isEquipped(item);

    if (equipped) return;

    try {
      if (owned) {
        await CosmeticsService
            .equipCosmetic(
          cosmeticId: item.id,
          category:
              _categoryKey(
            item.type,
          ),
        );
      } else {
        if (coins < item.price) {
          if (!mounted) return;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            const SnackBar(
              content: Text(
                'Not enough COINS.',
              ),
              behavior:
                  SnackBarBehavior
                      .floating,
            ),
          );

          return;
        }

        await CosmeticsService
            .purchaseCosmetic(
          cosmeticId: item.id,
          category:
              _categoryKey(
            item.type,
          ),
          price: item.price,
        );
      }

      await loadMarket();

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            owned
                ? '${item.name} equipped.'
                : '${item.name} purchased and equipped.',
          ),
          behavior:
              SnackBarBehavior
                  .floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong.',
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    if (isLoading) {
      return const SafeArea(
        child: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    final category =
        categories[
            selectedCategory];

    final categoryItems =
        items[category]!;

    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),

          const SizedBox(
            height: 18,
          ),

          _buildCategorySelector(),

          const SizedBox(
            height: 18,
          ),

          Expanded(
            child:
                RefreshIndicator(
              onRefresh:
                  loadMarket,
              child: ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.fromLTRB(
                  18,
                  0,
                  18,
                  24,
                ),
                children: [
                  ...categoryItems.map(
                    (item) => Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child:
                          _MarketItemCard(
                        item: item,
                        owned:
                            _isOwned(
                          item,
                        ),
                        equipped:
                            _isEquipped(
                          item,
                        ),
                        onTap: () =>
                            _openItem(
                          item,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        0,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'MARKET',
              style:
                  TextStyle(
                fontSize: 12,
                fontWeight:
                    FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 8,
            ),
            decoration:
                BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child: Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                const Icon(
                  Icons
                      .monetization_on_outlined,
                  size: 17,
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  _formatNumber(
                    coins,
                  ),
                  style:
                      const TextStyle(
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 42,
      child:
          ListView.separated(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        scrollDirection:
            Axis.horizontal,
        itemCount:
            categories.length,
        separatorBuilder:
            (_, __) =>
                const SizedBox(
          width: 8,
        ),
        itemBuilder:
            (context, index) {
          final selected =
              index ==
                  selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory =
                    index;
              });
            },
            child:
                AnimatedContainer(
              duration:
                  const Duration(
                milliseconds: 180,
              ),
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration:
                  BoxDecoration(
                color: selected
                    ? Colors.black
                    : Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
              alignment:
                  Alignment.center,
              child: Text(
                categories[index],
                style:
                    TextStyle(
                  fontSize: 10,
                  fontWeight:
                      FontWeight.w800,
                  letterSpacing:
                      1.2,
                  color: selected
                      ? Colors.white
                      : Colors.black54,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openItem(
    MarketItem item,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return _ItemDetailsSheet(
          item: item,
          owned:
              _isOwned(item),
          equipped:
              _isEquipped(item),
          onAction: () =>
              _buyOrEquip(item),
        );
      },
    );
  }

  String _formatNumber(
    int number,
  ) {
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
// ITEM TYPE
// ─────────────────────────────────────────

enum MarketItemType {
  button,
  effect,
  sound,
  counter,
}

// ─────────────────────────────────────────
// ITEM
// ─────────────────────────────────────────

class MarketItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final MarketItemType type;
  final Color previewColor;

  const MarketItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.previewColor,
  });
}

// ─────────────────────────────────────────
// ITEM CARD
// ─────────────────────────────────────────

class _MarketItemCard
    extends StatelessWidget {
  final MarketItem item;
  final bool owned;
  final bool equipped;
  final VoidCallback onTap;

  const _MarketItemCard({
    required this.item,
    required this.owned,
    required this.equipped,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Material(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(20),
        child: Padding(
          padding:
              const EdgeInsets.all(14),
          child: Row(
            children: [
              _ItemPreview(
                item: item,
              ),

              const SizedBox(
                width: 14,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style:
                          const TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      item.description,
                      maxLines: 2,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        fontSize: 11,
                        height: 1.35,
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

              _ItemStatus(
                item: item,
                owned: owned,
                equipped:
                    equipped,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// PREVIEW
// ─────────────────────────────────────────

class _ItemPreview
    extends StatelessWidget {
  final MarketItem item;

  const _ItemPreview({
    required this.item,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    switch (item.type) {
      case MarketItemType.button:
        return _ButtonPreview(
          item: item,
        );

      case MarketItemType.effect:
        return _EffectPreview(
          item: item,
        );

      case MarketItemType.sound:
        return _SoundPreview(
          item: item,
        );

      case MarketItemType.counter:
        return _CounterPreview(
          item: item,
        );
    }
  }
}

// ─────────────────────────────────────────
// BUTTON PREVIEW
// ─────────────────────────────────────────

class _ButtonPreview
    extends StatelessWidget {
  final MarketItem item;

  const _ButtonPreview({
    required this.item,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: 64,
      height: 64,
      decoration:
          BoxDecoration(
        shape: BoxShape.circle,
        gradient:
            _gradientForButton(
          item.id,
        ),
        boxShadow: [
          BoxShadow(
            color: item.previewColor
                .withValues(
              alpha: 0.28,
            ),
            blurRadius: 13,
            offset:
                const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        margin:
            const EdgeInsets.all(7),
        decoration:
            BoxDecoration(
          shape:
              BoxShape.circle,
          gradient:
              LinearGradient(
            begin:
                Alignment.topLeft,
            end:
                Alignment.bottomRight,
            colors: [
              Colors.white
                  .withValues(
                alpha: 0.22,
              ),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _gradientForButton(
    String id,
  ) {
    switch (id) {
      case 'button_ocean_blue':
        return const LinearGradient(
          colors: [
            Color(0xFF42A5F5),
            Color(0xFF1565C0),
          ],
        );

      case 'button_neon_purple':
        return const LinearGradient(
          colors: [
            Color(0xFFCE93D8),
            Color(0xFF7B1FA2),
          ],
        );

      case 'button_golden':
        return const LinearGradient(
          colors: [
            Color(0xFFFFD54F),
            Color(0xFFFF8F00),
          ],
        );

      case 'button_holographic':
        return const LinearGradient(
          colors: [
            Color(0xFFFF80AB),
            Color(0xFF7C4DFF),
            Color(0xFF40C4FF),
          ],
        );

      case 'button_void':
        return const LinearGradient(
          colors: [
            Color(0xFF424242),
            Color(0xFF090909),
          ],
        );

      default:
        return const LinearGradient(
          colors: [
            Color(0xFFFF5252),
            Color(0xFFC62828),
          ],
        );
    }
  }
}

// ─────────────────────────────────────────
// EFFECT PREVIEW
// ─────────────────────────────────────────

class _EffectPreview
    extends StatelessWidget {
  final MarketItem item;

  const _EffectPreview({
    required this.item,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: 64,
      height: 64,
      decoration:
          BoxDecoration(
        color:
            const Color(0xFFF4F4F0),
        borderRadius:
            BorderRadius.circular(
          17,
        ),
      ),
      child:
          CustomPaint(
        painter:
            _MarketEffectPainter(
          itemId: item.id,
          color:
              item.previewColor,
        ),
      ),
    );
  }
}

class _MarketEffectPainter
    extends CustomPainter {
  final String itemId;
  final Color color;

  _MarketEffectPainter({
    required this.itemId,
    required this.color,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center =
        Offset(
      size.width / 2,
      size.height / 2,
    );

    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2.5
          ..strokeCap =
              StrokeCap.round;

    if (itemId ==
        'effect_sparks') {
      for (int i = 0;
          i < 8;
          i++) {
        final angle =
            i *
                math.pi *
                2 /
                8;

        final start =
            Offset(
          center.dx +
              math.cos(angle) *
                  10,
          center.dy +
              math.sin(angle) *
                  10,
        );

        final end =
            Offset(
          center.dx +
              math.cos(angle) *
                  23,
          center.dy +
              math.sin(angle) *
                  23,
        );

        canvas.drawLine(
          start,
          end,
          paint,
        );
      }

      return;
    }

    if (itemId ==
        'effect_electric') {
      final path =
          Path();

      for (int i = 0;
          i < 9;
          i++) {
        final x =
            13.0 +
                i * 5.0;

        final y =
            32 +
                math.sin(
                      i * 2.5,
                    ) *
                    13;

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(
        path,
        paint,
      );

      return;
    }

    if (itemId ==
        'effect_fire') {
      for (int i = 0;
          i < 8;
          i++) {
        final double x =
            15.0 + i * 5.0;

        final double y =
            43 -
                (i % 3) *
                    8;

        canvas.drawCircle(
          Offset(x, y),
          3,
          paint,
        );
      }

      return;
    }

    if (itemId ==
        'effect_glitch') {
      final colors = [
        const Color(0xFFE91E63),
        const Color(0xFF00BCD4),
        const Color(0xFF7E57C2),
      ];

      for (int i = 0;
          i < colors.length;
          i++) {
        final p =
            Paint()
              ..color =
                  colors[i]
                      .withValues(
                alpha: 0.7,
              )
              ..style =
                  PaintingStyle.stroke
              ..strokeWidth = 3;

        canvas.drawCircle(
          Offset(
            center.dx +
                (i - 1) * 5,
            center.dy,
          ),
          18,
          p,
        );
      }

      return;
    }

    if (itemId ==
        'effect_cosmic') {
      for (int i = 0;
          i < 10;
          i++) {
        final angle =
            i *
                math.pi *
                2 /
                10;

        canvas.drawCircle(
          Offset(
            center.dx +
                math.cos(angle) *
                    22,
            center.dy +
                math.sin(angle) *
                    22,
          ),
          2,
          paint,
        );
      }

      canvas.drawCircle(
        center,
        9,
        paint,
      );

      return;
    }

    canvas.drawCircle(
      center,
      8,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _MarketEffectPainter
        oldDelegate,
  ) {
    return false;
  }
}

// ─────────────────────────────────────────
// SOUND PREVIEW
// ─────────────────────────────────────────

class _SoundPreview
    extends StatelessWidget {
  final MarketItem item;

  const _SoundPreview({
    required this.item,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: 64,
      height: 64,
      decoration:
          BoxDecoration(
        color:
            const Color(0xFFF4F4F0),
        borderRadius:
            BorderRadius.circular(
          17,
        ),
      ),
      child: Icon(
        _iconForSound(item.id),
        color:
            item.previewColor,
        size: 29,
      ),
    );
  }

  IconData _iconForSound(
    String id,
  ) {
    switch (id) {
      case 'sound_arcade':
        return Icons
            .sports_esports_outlined;

      case 'sound_mechanical':
        return Icons
            .precision_manufacturing_outlined;

      case 'sound_laser':
        return Icons
            .flash_on_outlined;

      case 'sound_glitch':
        return Icons
            .graphic_eq_outlined;

      case 'sound_retro':
        return Icons
            .music_note_outlined;

      default:
        return Icons
            .volume_up_outlined;
    }
  }
}

// ─────────────────────────────────────────
// COUNTER PREVIEW
// ─────────────────────────────────────────

class _CounterPreview
    extends StatelessWidget {
  final MarketItem item;

  const _CounterPreview({
    required this.item,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: 64,
      height: 64,
      decoration:
          BoxDecoration(
        color:
            const Color(0xFFF4F4F0),
        borderRadius:
            BorderRadius.circular(
          17,
        ),
      ),
      child: Center(
        child: _buildCounter(),
      ),
    );
  }

  Widget _buildCounter() {
    switch (item.id) {
      case 'counter_bounce':
        return Transform.scale(
          scale: 1.12,
          child:
              _number(),
        );

      case 'counter_float':
        return Transform.translate(
          offset:
              const Offset(0, -5),
          child:
              _number(),
        );

      case 'counter_glitch':
        return Stack(
          alignment:
              Alignment.center,
          children: [
            Text(
              '12 4',
              style:
                  TextStyle(
                color:
                    const Color(
                  0xFF00BCD4,
                ).withValues(
                  alpha: 0.7,
                ),
                fontSize: 15,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
            Text(
              '12 4',
              style:
                  TextStyle(
                color:
                    const Color(
                  0xFFE91E63,
                ).withValues(
                  alpha: 0.7,
                ),
                fontSize: 15,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
            _number(),
          ],
        );

      case 'counter_particles':
        return Stack(
          alignment:
              Alignment.center,
          children: [
            _number(),
            Positioned(
              top: 9,
              right: 11,
              child:
                  _dot(),
            ),
            Positioned(
              bottom: 12,
              left: 10,
              child:
                  _dot(),
            ),
            Positioned(
              top: 17,
              left: 8,
              child:
                  _dot(),
            ),
          ],
        );

      default:
        return _number();
    }
  }

  Widget _number() {
    return Text(
      '12 483',
      style: TextStyle(
        color:
            item.previewColor,
        fontSize: 15,
        fontWeight:
            FontWeight.w800,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 4,
      height: 4,
      decoration:
          BoxDecoration(
        color:
            item.previewColor,
        shape:
            BoxShape.circle,
      ),
    );
  }
}

// ─────────────────────────────────────────
// STATUS
// ─────────────────────────────────────────

class _ItemStatus
    extends StatelessWidget {
  final MarketItem item;
  final bool owned;
  final bool equipped;

  const _ItemStatus({
    required this.item,
    required this.owned,
    required this.equipped,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    if (equipped) {
      return const Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            Icons
                .check_circle_rounded,
            size: 19,
          ),
          SizedBox(height: 4),
          Text(
            'EQUIPPED',
            style: TextStyle(
              fontSize: 7,
              fontWeight:
                  FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      );
    }

    if (owned) {
      return const Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            Icons
                .check_circle_outline_rounded,
            size: 19,
            color:
                Colors.black54,
          ),
          SizedBox(height: 4),
          Text(
            'OWNED',
            style: TextStyle(
              fontSize: 7,
              fontWeight:
                  FontWeight.w800,
              letterSpacing: 0.8,
              color:
                  Colors.black54,
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        Row(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons
                  .monetization_on_outlined,
              size: 14,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              _formatPrice(
                item.price,
              ),
              style:
                  const TextStyle(
                fontSize: 12,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        const Text(
          'BUY',
          style:
              TextStyle(
            fontSize: 7,
            fontWeight:
                FontWeight.w800,
            letterSpacing:
                0.8,
          ),
        ),
      ],
    );
  }

  String _formatPrice(
    int price,
  ) {
    return price
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
// DETAILS SHEET
// ─────────────────────────────────────────

class _ItemDetailsSheet
    extends StatelessWidget {
  final MarketItem item;
  final bool owned;
  final bool equipped;
  final VoidCallback onAction;

  const _ItemDetailsSheet({
    required this.item,
    required this.owned,
    required this.equipped,
    required this.onAction,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final actionText =
        equipped
            ? 'EQUIPPED'
            : owned
                ? 'EQUIP'
                : 'BUY FOR ${_formatPrice(item.price)} COINS';

    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        22,
        12,
        22,
        28,
      ),
      decoration:
          const BoxDecoration(
        color:
            Color(0xFFF4F4F0),
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 4,
              decoration:
                  BoxDecoration(
                color:
                    Colors.black12,
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            _LargePreview(
              item: item,
            ),

            const SizedBox(
              height: 20,
            ),

            Text(
              item.name,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: 7,
            ),

            Text(
              item.description,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                fontSize: 13,
                color:
                    Colors.black54,
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            SizedBox(
              width:
                  double.infinity,
              height: 52,
              child:
                  ElevatedButton(
                onPressed:
                    equipped
                        ? null
                        : onAction,
                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      Colors.black,
                  foregroundColor:
                      Colors.white,
                  disabledBackgroundColor:
                      Colors.black12,
                  disabledForegroundColor:
                      Colors.black45,
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      16,
                    ),
                  ),
                ),
                child: Text(
                  actionText,
                  style:
                      const TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w800,
                    letterSpacing:
                        1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(
    int price,
  ) {
    return price
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
// LARGE PREVIEW
// ─────────────────────────────────────────

class _LargePreview
    extends StatelessWidget {
  final MarketItem item;

  const _LargePreview({
    required this.item,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    if (item.type ==
        MarketItemType.button) {
      return _LargeButton(
        item: item,
      );
    }

    if (item.type ==
        MarketItemType.effect) {
      return _LargeEffect(
        item: item,
      );
    }

    if (item.type ==
        MarketItemType.counter) {
      return _LargeCounter(
        item: item,
      );
    }

    return Container(
      width: 150,
      height: 150,
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          32,
        ),
      ),
      child: Icon(
        Icons.volume_up_outlined,
        size: 64,
        color:
            item.previewColor,
      ),
    );
  }
}

// ─────────────────────────────────────────
// LARGE BUTTON
// ─────────────────────────────────────────

class _LargeButton
    extends StatelessWidget {
  final MarketItem item;

  const _LargeButton({
    required this.item,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: 150,
      height: 150,
      decoration:
          BoxDecoration(
        shape:
            BoxShape.circle,
        gradient:
            _gradient(),
        boxShadow: [
          BoxShadow(
            color:
                item.previewColor
                    .withValues(
              alpha: 0.30,
            ),
            blurRadius: 28,
            offset:
                const Offset(0, 12),
          ),
        ],
      ),
      child: Container(
        margin:
            const EdgeInsets.all(10),
        decoration:
            BoxDecoration(
          shape:
              BoxShape.circle,
          gradient:
              LinearGradient(
            begin:
                Alignment.topLeft,
            end:
                Alignment.bottomRight,
            colors: [
              Colors.white
                  .withValues(
                alpha: 0.25,
              ),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _gradient() {
    switch (item.id) {
      case 'button_ocean_blue':
        return const LinearGradient(
          colors: [
            Color(0xFF42A5F5),
            Color(0xFF1565C0),
          ],
        );

      case 'button_neon_purple':
        return const LinearGradient(
          colors: [
            Color(0xFFCE93D8),
            Color(0xFF7B1FA2),
          ],
        );

      case 'button_golden':
        return const LinearGradient(
          colors: [
            Color(0xFFFFD54F),
            Color(0xFFFF8F00),
          ],
        );

      case 'button_holographic':
        return const LinearGradient(
          colors: [
            Color(0xFFFF80AB),
            Color(0xFF7C4DFF),
            Color(0xFF40C4FF),
          ],
        );

      case 'button_void':
        return const LinearGradient(
          colors: [
            Color(0xFF424242),
            Color(0xFF090909),
          ],
        );

      default:
        return const LinearGradient(
          colors: [
            Color(0xFFFF5252),
            Color(0xFFC62828),
          ],
        );
    }
  }
}

// ─────────────────────────────────────────
// LARGE EFFECT
// ─────────────────────────────────────────

class _LargeEffect
    extends StatelessWidget {
  final MarketItem item;

  const _LargeEffect({
    required this.item,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: 150,
      height: 150,
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          32,
        ),
      ),
      child: CustomPaint(
        painter:
            _LargeEffectPainter(
          item: item,
        ),
      ),
    );
  }
}

class _LargeEffectPainter
    extends CustomPainter {
  final MarketItem item;

  _LargeEffectPainter({
    required this.item,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center =
        Offset(
      size.width / 2,
      size.height / 2,
    );

    final paint =
        Paint()
          ..color =
              item.previewColor
          ..strokeWidth = 4
          ..strokeCap =
              StrokeCap.round;

    for (int i = 0;
        i < 12;
        i++) {
      final angle =
          i *
              math.pi *
              2 /
              12;

      final inner =
          item.id ==
                  'effect_default'
              ? 20
              : 28;

      final outer =
          item.id ==
                  'effect_default'
              ? 34
              : 55;

      final start =
          Offset(
        center.dx +
            math.cos(angle) *
                inner,
        center.dy +
            math.sin(angle) *
                inner,
      );

      final end =
          Offset(
        center.dx +
            math.cos(angle) *
                outer,
        center.dy +
            math.sin(angle) *
                outer,
      );

      canvas.drawLine(
        start,
        end,
        paint,
      );
    }

    canvas.drawCircle(
      center,
      14,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _LargeEffectPainter
        oldDelegate,
  ) {
    return false;
  }
}

// ─────────────────────────────────────────
// LARGE COUNTER
// ─────────────────────────────────────────

class _LargeCounter
    extends StatelessWidget {
  final MarketItem item;

  const _LargeCounter({
    required this.item,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: 150,
      height: 150,
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          32,
        ),
      ),
      child: Center(
        child: Text(
          '12 483',
          style: TextStyle(
            fontSize: 24,
            fontWeight:
                FontWeight.w800,
            letterSpacing: -1,
            color:
                item.previewColor,
          ),
        ),
      ),
    );
  }
}