import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static Future<User> ensureSignedIn() async {
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      return currentUser;
    }

    final credential = await _auth.signInAnonymously();

    return credential.user!;
  }
}