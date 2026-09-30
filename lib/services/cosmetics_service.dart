import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CosmeticsService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static DocumentReference<Map<String, dynamic>> get _playerRef {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user.');
    }

    return _firestore.collection('users').doc(user.uid);
  }

  // ─────────────────────────────────────
  // OWNED COSMETICS
  // ─────────────────────────────────────

  static Future<List<String>> getOwnedCosmetics() async {
    final snapshot = await _playerRef.get();

    final data = snapshot.data();

    if (data == null) {
      return [];
    }

    final owned = data['ownedCosmetics'];

    if (owned is! List) {
      return [];
    }

    return owned
        .map((item) => item.toString())
        .toList();
  }

  // ─────────────────────────────────────
  // EQUIPPED COSMETICS
  // ─────────────────────────────────────

  static Future<Map<String, String>> getEquippedCosmetics() async {
    final snapshot = await _playerRef.get();

    final data = snapshot.data();

    if (data == null) {
      return {};
    }

    final equipped = data['equippedCosmetics'];

    if (equipped is! Map) {
      return {};
    }

    return equipped.map(
      (key, value) => MapEntry(
        key.toString(),
        value.toString(),
      ),
    );
  }

  // ─────────────────────────────────────
  // CHECK OWNERSHIP
  // ─────────────────────────────────────

  static Future<bool> ownsCosmetic(String cosmeticId) async {
    final owned = await getOwnedCosmetics();

    return owned.contains(cosmeticId);
  }

  // ─────────────────────────────────────
  // EQUIP
  // ─────────────────────────────────────

  static Future<void> equipCosmetic({
    required String cosmeticId,
    required String category,
  }) async {
    final owned = await getOwnedCosmetics();

    if (!owned.contains(cosmeticId)) {
      throw Exception('Cosmetic is not owned.');
    }

    await _playerRef.set(
      {
        'equippedCosmetics': {
          category: cosmeticId,
        },
      },
      SetOptions(merge: true),
    );
  }

  // ─────────────────────────────────────
  // PURCHASE
  // ─────────────────────────────────────

  static Future<bool> purchaseCosmetic({
    required String cosmeticId,
    required String category,
    required int price,
  }) async {
    final playerRef = _playerRef;

    return _firestore.runTransaction<bool>(
      (transaction) async {
        final snapshot = await transaction.get(playerRef);

        final data = snapshot.data();

        if (data == null) {
          throw Exception('Player does not exist.');
        }

        final coins = (data['coins'] as num?)?.toInt() ?? 0;

        final ownedRaw = data['ownedCosmetics'];

        final List<String> owned = ownedRaw is List
            ? ownedRaw
                .map((item) => item.toString())
                .toList()
            : [];

        // Already owned
        if (owned.contains(cosmeticId)) {
          return false;
        }

        // Not enough coins
        if (coins < price) {
          throw Exception('Not enough coins.');
        }

        owned.add(cosmeticId);

        transaction.update(
          playerRef,
          {
            'coins': coins - price,
            'ownedCosmetics': owned,
            'equippedCosmetics': {
              category: cosmeticId,
            },
          },
        );

        return true;
      },
    );
  }
}