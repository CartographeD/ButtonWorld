import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/player.dart';

class PlayerService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static Timer? _syncTimer;

  static Future<void> ensurePlayerExists() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user.');

    final playerRef = _firestore.collection('users').doc(user.uid);
    final snapshot = await playerRef.get();

    if (!snapshot.exists) {
      await playerRef.set({
        'presses': 0,
        'coins': 0,
        'country': null,
        'username': null,
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
    }
  }

  static Future<Player> getPlayer() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user.');

    final snapshot = await _firestore.collection('users').doc(user.uid).get();
    if (!snapshot.exists) throw Exception('Player does not exist.');

    return Player.fromFirestore(user.uid, snapshot.data()!);
  }

  static Future<int> getFirebasePresses() async {
    final player = await getPlayer();
    return player.presses;
  }

  static Future<void> updateUsername(String username) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user.');

    await _firestore.collection('users').doc(user.uid).update({
      'username': username.trim(),
    });
  }

  static Future<void> updateBestTapStreak(int streak) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'bestTapStreak': streak,
    });
  }

  static Future<void> updateButtonSkin(String skin) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'buttonSkin': skin,
    });
  }

  static void schedulePressSync({
    required int presses,
    required int bestTapStreak,
  }) {
    _syncTimer?.cancel();
    _syncTimer = Timer(const Duration(seconds: 2), () async {
      await syncProgress(
        presses: presses,
        bestTapStreak: bestTapStreak,
      );
    });
  }

  static Future<void> syncProgress({
    required int presses,
    required int bestTapStreak,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'presses': presses,
      'bestTapStreak': bestTapStreak,
    });
  }

  static void dispose() {
    _syncTimer?.cancel();
  }

  static Future<void> updateCountry(String country) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user.');
    }

    final playerRef = _firestore
        .collection('users')
        .doc(user.uid);

    await playerRef.update({
      'country': country,
    });
  }
}
