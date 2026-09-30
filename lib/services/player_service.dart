import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/player.dart';

class PlayerService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth =
      FirebaseAuth.instance;

  static Timer? _syncTimer;

  // ─────────────────────────────────────
  // USERNAME
  // ─────────────────────────────────────

  static String _generatePlayerUsername() {
    final random = Random.secure();

    final number =
        100000000 + random.nextInt(900000000);

    return 'Player#$number';
  }

  // ─────────────────────────────────────
  // PLAYER
  // ─────────────────────────────────────

  static Future<void> ensurePlayerExists() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user.');
    }

    final playerRef =
        _firestore.collection('users').doc(user.uid);

    final snapshot = await playerRef.get();

    // ─────────────────────────────────────
    // NOUVEAU JOUEUR
    // ─────────────────────────────────────

    if (!snapshot.exists) {
      await playerRef.set({
        'presses': 0,
        'coins': 0,
        'country': null,
        'username': _generatePlayerUsername(),
        'googleLinked': false,
        'createdAt': FieldValue.serverTimestamp(),

        'ownedCosmetics': [
          'button_classic',
          'effect_default',
          'sound_classic',
          'counter_classic',
        ],

        'equippedCosmetics': {
          'button': 'button_classic',
          'effect': 'effect_default',
          'sound': 'sound_classic',
          'counter': 'counter_classic',
        },
      });

      return;
    }

    // ─────────────────────────────────────
    // JOUEUR EXISTANT
    // ─────────────────────────────────────

    final data = snapshot.data();

    if (data == null) {
      return;
    }

    // ─────────────────────────────────────
    // USERNAME
    // ─────────────────────────────────────

    final username = data['username'];

    final googleLinked =
        data['googleLinked'] == true;

    // Si un ancien compte n'a pas encore
    // de username, on lui en attribue un.
    //
    // Si Google est déjà lié, on ne touche
    // surtout pas au username existant.

    if ((username == null ||
            username is! String ||
            username.trim().isEmpty) &&
        !googleLinked) {
      await playerRef.update({
        'username': _generatePlayerUsername(),
      });
    }

    // ─────────────────────────────────────
    // COSMETICS MIGRATION
    // ─────────────────────────────────────

    const defaultCosmetics = [
      'button_classic',
      'effect_default',
      'sound_classic',
      'counter_classic',
    ];

    // ─────────────────────────────────────
    // OWNED COSMETICS
    // ─────────────────────────────────────

    final rawOwned =
        data['ownedCosmetics'];

    final ownedCosmetics =
        rawOwned is List
            ? rawOwned
                .whereType<String>()
                .toList()
            : <String>[];

    bool cosmeticsChanged = false;

    // Les quatre cosmétiques gratuits
    // doivent toujours être possédés.

    for (final cosmetic
        in defaultCosmetics) {
      if (!ownedCosmetics.contains(
        cosmetic,
      )) {
        ownedCosmetics.add(cosmetic);
        cosmeticsChanged = true;
      }
    }

    // ─────────────────────────────────────
    // EQUIPPED COSMETICS
    // ─────────────────────────────────────

    final rawEquipped =
        data['equippedCosmetics'];

    final equippedCosmetics =
        rawEquipped is Map
            ? Map<String, dynamic>.from(
                rawEquipped,
              )
            : <String, dynamic>{};

    // BUTTON

    if (equippedCosmetics['button']
                is! String ||
        !ownedCosmetics.contains(
          equippedCosmetics['button'],
        )) {
      equippedCosmetics['button'] =
          'button_classic';

      cosmeticsChanged = true;
    }

    // EFFECT

    if (equippedCosmetics['effect']
                is! String ||
        !ownedCosmetics.contains(
          equippedCosmetics['effect'],
        )) {
      equippedCosmetics['effect'] =
          'effect_default';

      cosmeticsChanged = true;
    }

    // SOUND

    if (equippedCosmetics['sound']
                is! String ||
        !ownedCosmetics.contains(
          equippedCosmetics['sound'],
        )) {
      equippedCosmetics['sound'] =
          'sound_classic';

      cosmeticsChanged = true;
    }

    // COUNTER

    if (equippedCosmetics['counter']
                is! String ||
        !ownedCosmetics.contains(
          equippedCosmetics['counter'],
        )) {
      equippedCosmetics['counter'] =
          'counter_classic';

      cosmeticsChanged = true;
    }

    // ─────────────────────────────────────
    // SAVE MIGRATION
    // ─────────────────────────────────────

    if (cosmeticsChanged) {
      await playerRef.update({
        'ownedCosmetics': ownedCosmetics,
        'equippedCosmetics':
            equippedCosmetics,
      });
    }
  }

  // ─────────────────────────────────────
  // GET PLAYER
  // ─────────────────────────────────────

  static Future<Player> getPlayer() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user.');
    }

    final snapshot =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

    if (!snapshot.exists) {
      throw Exception('Player does not exist.');
    }

    return Player.fromFirestore(
      user.uid,
      snapshot.data()!,
    );
  }

  // ─────────────────────────────────────
  // PRESSES
  // ─────────────────────────────────────

  static Future<int> getFirebasePresses() async {
    final player = await getPlayer();

    return player.presses;
  }

  // ─────────────────────────────────────
  // WORLD RANK
  // ─────────────────────────────────────

  static Future<int> getWorldRank() async {
    final player = await getPlayer();

    final snapshot = await _firestore
        .collection('users')
        .where(
          'presses',
          isGreaterThan: player.presses,
        )
        .count()
        .get();

    return (snapshot.count ?? 0) + 1;
  }

  // ─────────────────────────────────────
  // USERNAME MANUEL
  // ─────────────────────────────────────

  static Future<void> updateUsername(
    String username,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user.');
    }

    final playerRef =
        _firestore.collection('users').doc(user.uid);

    final snapshot =
        await playerRef.get();

    if (!snapshot.exists) {
      throw Exception('Player does not exist.');
    }

    final data = snapshot.data();

    // Une fois Google lié, le username
    // devient définitif.

    if (data?['googleLinked'] == true) {
      return;
    }

    final cleanUsername =
        username.trim();

    if (cleanUsername.isEmpty) {
      return;
    }

    await playerRef.update({
      'username': cleanUsername,
    });
  }

  // ─────────────────────────────────────
  // GOOGLE USERNAME
  // ─────────────────────────────────────

  static Future<void> setGoogleUsername(
    String googleName,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user.');
    }

    final playerRef =
        _firestore.collection('users').doc(user.uid);

    final snapshot =
        await playerRef.get();

    if (!snapshot.exists) {
      throw Exception('Player does not exist.');
    }

    final data = snapshot.data();

    // Google est déjà lié :
    // on ne change plus jamais le username.

    if (data?['googleLinked'] == true) {
      return;
    }

    final cleanName =
        googleName.trim();

    if (cleanName.isEmpty) {
      return;
    }

    final random = Random.secure();

    final number =
        100000000 + random.nextInt(900000000);

    final username =
        '$cleanName#$number';

    await playerRef.update({
      'username': username,
      'googleLinked': true,
    });
  }

  // ─────────────────────────────────────
  // BEST TAP STREAK
  // ─────────────────────────────────────

  static Future<void> updateBestTapStreak(
    int streak,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .update({
      'bestTapStreak': streak,
    });
  }

  // ─────────────────────────────────────
  // BUTTON SKIN
  // ─────────────────────────────────────

  static Future<void> updateButtonSkin(
    String skin,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .update({
      'buttonSkin': skin,
    });
  }

  // ─────────────────────────────────────
  // PRESS SYNC
  // ─────────────────────────────────────

  static void schedulePressSync({
    required int presses,
    required int bestTapStreak,
  }) {
    _syncTimer?.cancel();

    _syncTimer = Timer(
      const Duration(seconds: 2),
      () async {
        await syncProgress(
          presses: presses,
          bestTapStreak: bestTapStreak,
        );
      },
    );
  }

  static Future<void> syncProgress({
    required int presses,
    required int bestTapStreak,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .update({
      'presses': presses,
      'bestTapStreak': bestTapStreak,
    });
  }

  // ─────────────────────────────────────
  // DISPOSE
  // ─────────────────────────────────────

  static void dispose() {
    _syncTimer?.cancel();
  }

  // ─────────────────────────────────────
  // COUNTRY
  // ─────────────────────────────────────

  static Future<void> updateCountry(
    String country,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user.');
    }

    final playerRef =
        _firestore
            .collection('users')
            .doc(user.uid);

    await playerRef.update({
      'country': country,
    });
  }
}