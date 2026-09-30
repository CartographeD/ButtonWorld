import 'package:flutter/material.dart';

import '../services/cosmetics_service.dart';
import '../services/player_service.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
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
        description: 'The original ButtonWorld button.',
        price: 0,
        type: MarketItemType.button,
        previewColor: Color(0xFFE53935),
      ),
      const MarketItem(
        id: 'button_ocean_blue',
        name: 'Ocean Blue',
        description: 'A clean deep blue finish.',
        price: 500,
        type: MarketItemType.button,
        previewColor: Color(0xFF1976D2),
      ),
      const MarketItem(
        id: 'button_neon_purple',
        name: 'Neon Purple',
        description: 'A bright neon purple button.',
        price: 1000,
        type: MarketItemType.button,
        previewColor: Color(0xFF8E24AA),
      ),
      const MarketItem(
        id: 'button_golden',
        name: 'Golden',
        description: 'A special golden finish.',
        price: 2500,
        type: MarketItemType.button,
        previewColor: Color(0xFFFFB300),
      ),
      const MarketItem(
        id: 'button_holographic',
        name: 'Holographic',
        description: 'A rare holographic appearance.',
        price: 5000,
        type: MarketItemType.button,
        previewColor: Color(0xFF7E57C2),
      ),
      const MarketItem(
        id: 'button_void',
        name: 'Void',
        description: 'Dark. Simple. Absolute.',
        price: 7500,
        type: MarketItemType.button,
        previewColor: Color(0xFF171717),
      ),
    ],
    'EFFECT': [
      const MarketItem(
        id: 'effect_default',
        name: 'Default',
        description: 'The classic press effect.',
        price: 0,
        type: MarketItemType.effect,
        previewColor: Color(0xFFE53935),
      ),
      const MarketItem(
        id: 'effect_sparks',
        name: 'Sparks',
        description: 'Small sparks burst from the button.',
        price: 500,
        type: MarketItemType.effect,
        previewColor: Color(0xFFFFB300),
      ),
      const MarketItem(
        id: 'effect_electric',
        name: 'Electric',
        description: 'An electric pulse on every press.',
        price: 1000,
        type: MarketItemType.effect,
        previewColor: Color(0xFF42A5F5),
      ),
      const MarketItem(
        id: 'effect_fire',
        name: 'Fire',
        description: 'A short burst of flames.',
        price: 1500,
        type: MarketItemType.effect,
        previewColor: Color(0xFFFF7043),
      ),
      const MarketItem(
        id: 'effect_glitch',
        name: 'Glitch',
        description: 'A digital glitch effect.',
        price: 2500,
        type: MarketItemType.effect,
        previewColor: Color(0xFF7E57C2),
      ),
      const MarketItem(
        id: 'effect_cosmic',
        name: 'Cosmic',
        description: 'A small cosmic explosion.',
        price: 5000,
        type: MarketItemType.effect,
        previewColor: Color(0xFF5C6BC0),
      ),
    ],
    'SOUND': [
      const MarketItem(
        id: 'sound_classic',
        name: 'Classic',
        description: 'The original ButtonWorld sound.',
        price: 0,
        type: MarketItemType.sound,
        previewColor: Color(0xFFE53935),
      ),
      const MarketItem(
        id: 'sound_arcade',
        name: 'Arcade',
        description: 'A satisfying arcade-style click.',
        price: 500,
        type: MarketItemType.sound,
        previewColor: Color(0xFF42A5F5),
      ),
      const MarketItem(
        id: 'sound_mechanical',
        name: 'Mechanical',
        description: 'A heavier mechanical press.',
        price: 750,
        type: MarketItemType.sound,
        previewColor: Color(0xFF78909C),
      ),
      const MarketItem(
        id: 'sound_laser',
        name: 'Laser',
        description: 'A short futuristic laser sound.',
        price: 1000,
        type: MarketItemType.sound,
        previewColor: Color(0xFF26A69A),
      ),
      const MarketItem(
        id: 'sound_glitch',
        name: 'Glitch',
        description: 'A distorted digital click.',
        price: 1500,
        type: MarketItemType.sound,
        previewColor: Color(0xFFAB47BC),
      ),
      const MarketItem(
        id: 'sound_retro',
        name: 'Retro',
        description: 'A classic retro game sound.',
        price: 2000,
        type: MarketItemType.sound,
        previewColor: Color(0xFFFFA726),
      ),
    ],
    'COUNTER': [
      const MarketItem(
        id: 'counter_classic',
        name: 'Classic',
        description: 'The clean default counter animation.',
        price: 0,
        type: MarketItemType.counter,
        previewColor: Color(0xFFE53935),
      ),
      const MarketItem(
        id: 'counter_bounce',
        name: 'Bounce',
        description: 'The number bounces when it changes.',
        price: 500,
        type: MarketItemType.counter,
        previewColor: Color(0xFF42A5F5),
      ),
      const MarketItem(
        id: 'counter_float',
        name: 'Float',
        description: 'Numbers gently float upward.',
        price: 750,
        type: MarketItemType.counter,
        previewColor: Color(0xFF26A69A),
      ),
      const MarketItem(
        id: 'counter_glitch',
        name: 'Glitch',
        description: 'A quick digital glitch animation.',
        price: 1500,
        type: MarketItemType.counter,
        previewColor: Color(0xFF8E24AA),
      ),
      const MarketItem(
        id: 'counter_particles',
        name: 'Particles',
        description: 'Small particles appear around the score.',
        price: 2500,
        type: MarketItemType.counter,
        previewColor: Color(0xFFFFB300),
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
      final player = await PlayerService.getPlayer();
      final owned = await CosmeticsService.getOwnedCosmetics();
      final equipped = await CosmeticsService.getEquippedCosmetics();

      if (!mounted) return;

      setState(() {
        coins = player.coins;
        ownedCosmetics = owned;
        equippedCosmetics = equipped;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  String _categoryKey(MarketItemType type) {
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

  bool _isOwned(MarketItem item) {
    return ownedCosmetics.contains(item.id);
  }

  bool _isEquipped(MarketItem item) {
    final category = _categoryKey(item.type);

    return equippedCosmetics[category] == item.id;
  }

  Future<void> _buyOrEquip(MarketItem item) async {
    final owned = _isOwned(item);
    final equipped = _isEquipped(item);

    if (equipped) {
      return;
    }

    try {
      if (owned) {
        await CosmeticsService.equipCosmetic(
          cosmeticId: item.id,
          category: _categoryKey(item.type),
        );
      } else {
        if (coins < item.price) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Not enough COINS.'),
              behavior: SnackBarBehavior.floating,
            ),
          );

          return;
        }

        await CosmeticsService.purchaseCosmetic(
          cosmeticId: item.id,
          category: _categoryKey(item.type),
          price: item.price,
        );
      }

      await loadMarket();

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            owned
                ? '${item.name} equipped.'
                : '${item.name} purchased and equipped.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().contains('Not enough coins')
                ? 'Not enough COINS.'
                : 'Something went wrong.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final category = categories[selectedCategory];
    final categoryItems = items[category]!;

    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),

          const SizedBox(height: 18),

          _buildCategorySelector(),

          const SizedBox(height: 18),

          Expanded(
            child: RefreshIndicator(
              onRefresh: loadMarket,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  18,
                  0,
                  18,
                  24,
                ),
                children: [
                  ...categoryItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _MarketItemCard(
                        item: item,
                        owned: _isOwned(item),
                        equipped: _isEquipped(item),
                        onTap: () => _openItem(item),
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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'MARKET',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.monetization_on_outlined,
                  size: 17,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatNumber(coins),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
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
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: selected ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: Text(
                categories[index],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
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

  void _openItem(MarketItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return _ItemDetailsSheet(
          item: item,
          owned: _isOwned(item),
          equipped: _isEquipped(item),
          onAction: () => _buyOrEquip(item),
        );
      },
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ' ',
        );
  }
}

enum MarketItemType {
  button,
  effect,
  sound,
  counter,
}

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

class _MarketItemCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              _ItemPreview(item: item),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _ItemStatus(
                item: item,
                owned: owned,
                equipped: equipped,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemPreview extends StatelessWidget {
  final MarketItem item;

  const _ItemPreview({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    if (item.type == MarketItemType.button) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: item.previewColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: item.previewColor.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'PRESS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F0),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Icon(
          _iconForType(item.type),
          color: item.previewColor,
          size: 28,
        ),
      ),
    );
  }

  IconData _iconForType(MarketItemType type) {
    switch (type) {
      case MarketItemType.effect:
        return Icons.auto_awesome;
      case MarketItemType.sound:
        return Icons.volume_up_outlined;
      case MarketItemType.counter:
        return Icons.tag;
      case MarketItemType.button:
        return Icons.touch_app_outlined;
    }
  }
}

class _ItemStatus extends StatelessWidget {
  final MarketItem item;
  final bool owned;
  final bool equipped;

  const _ItemStatus({
    required this.item,
    required this.owned,
    required this.equipped,
  });

  @override
  Widget build(BuildContext context) {
    if (equipped) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 19,
          ),
          SizedBox(height: 4),
          Text(
            'EQUIPPED',
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      );
    }

    if (owned) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 19,
            color: Colors.black54,
          ),
          SizedBox(height: 4),
          Text(
            'OWNED',
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: Colors.black54,
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.monetization_on_outlined,
              size: 14,
            ),
            const SizedBox(width: 3),
            Text(
              _formatPrice(item.price),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'BUY',
          style: TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ' ',
        );
  }
}

class _ItemDetailsSheet extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final actionText = equipped
        ? 'EQUIPPED'
        : owned
            ? 'EQUIP'
            : 'BUY FOR ${_formatPrice(item.price)} COINS';

    return Container(
      padding: const EdgeInsets.fromLTRB(
        22,
        12,
        22,
        28,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF4F4F0),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            _LargePreview(item: item),
            const SizedBox(height: 20),
            Text(
              item.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              item.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: equipped ? null : onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.black12,
                  disabledForegroundColor: Colors.black45,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  actionText,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _LargePreview({
    required MarketItem item,
  }) {
    if (item.type == MarketItemType.button) {
      return Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: item.previewColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: item.previewColor.withValues(alpha: 0.3),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'PRESS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Center(
        child: Icon(
          _iconForType(item.type),
          size: 64,
          color: item.previewColor,
        ),
      ),
    );
  }

  IconData _iconForType(MarketItemType type) {
    switch (type) {
      case MarketItemType.effect:
        return Icons.auto_awesome;
      case MarketItemType.sound:
        return Icons.volume_up_outlined;
      case MarketItemType.counter:
        return Icons.tag;
      case MarketItemType.button:
        return Icons.touch_app_outlined;
    }
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ' ',
        );
  }
}