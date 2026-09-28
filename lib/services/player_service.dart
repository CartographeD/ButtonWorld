import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/player.dart';

class PlayerService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Timer? _syncTimer;

  static Future<void> ensurePlayerExists() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user.');
    }

    final playerRef = _firestore
        .collection('users')
        .doc(user.uid);

    final snapshot = await playerRef.get();

    if (!snapshot.exists) {
      await playerRef.set({
        'presses': 0,
        'coins': 0,
        'country': null,
        'username': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<Player> getPlayer() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user.');
    }

    final playerRef = _firestore
        .collection('users')
        .doc(user.uid);

    final snapshot = await playerRef.get();

    if (!snapshot.exists) {
      throw Exception('Player does not exist.');
    }

    return Player.fromFirestore(
      user.uid,
      snapshot.data()!,
    );
  }

  static Future<int> getFirebasePresses() async {
    final player = await getPlayer();

    return player.presses;
  }

  static Future<void> updateUsername(String username) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user.');
    }

    final playerRef = _firestore
        .collection('users')
        .doc(user.uid);

    await playerRef.update({
      'username': username.trim(),
    });
  }

  static void schedulePressSync(int presses) {
    _syncTimer?.cancel();

    _syncTimer = Timer(
      const Duration(seconds: 2),
      () async {
        await syncPresses(presses);
      },
    );
  }

  static Future<void> syncPresses(int presses) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final playerRef = _firestore
        .collection('users')
        .doc(user.uid);

    await playerRef.update({
      'presses': presses,
    });
  }

  static void dispose() {
    _syncTimer?.cancel();
  }
}