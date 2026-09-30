import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'player_service.dart';

enum GoogleAccountResult {
  linked,
  recovered,
}

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static bool _googleInitialized = false;

  static User? get currentUser => _auth.currentUser;

  static bool get isGoogleLinked {
    final user = _auth.currentUser;

    if (user == null) {
      return false;
    }

    return user.providerData.any(
      (provider) => provider.providerId == 'google.com',
    );
  }

  // ─────────────────────────────────────
  // GOOGLE INITIALIZATION
  // ─────────────────────────────────────

  static Future<void> _initializeGoogle() async {
    if (_googleInitialized) {
      return;
    }

    await GoogleSignIn.instance.initialize();

    _googleInitialized = true;
  }

  // ─────────────────────────────────────
  // ANONYMOUS LOGIN
  // ─────────────────────────────────────

  static Future<User> ensureSignedIn() async {
    await _initializeGoogle();

    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      return currentUser;
    }

    final credential = await _auth.signInAnonymously();

    return credential.user!;
  }

  // ─────────────────────────────────────
  // LINK / RECOVER GOOGLE
  // ─────────────────────────────────────

  static Future<GoogleAccountResult> linkGoogleAccount() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user.');
    }

    if (isGoogleLinked) {
      throw Exception('Google account already linked.');
    }

    await _initializeGoogle();

    // Ouvre la fenêtre de sélection Google.
    final googleUser =
        await GoogleSignIn.instance.authenticate();

    final googleAuth = googleUser.authentication;

    if (googleAuth.idToken == null) {
      throw Exception('Unable to retrieve Google ID token.');
    }

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    try {
      // ─────────────────────────────────────
      // CAS NORMAL
      // ─────────────────────────────────────
      //
      // Google n'est lié à aucun autre compte.
      //
      // On lie Google au compte Firebase actuel.
      // Le UID reste donc exactement le même.

      await user.linkWithCredential(credential);

      // Le username devient :
      // GoogleName#123456789
      //
      // PlayerService s'occupe également de
      // googleLinked et empêche une modification
      // ultérieure du username.

      final googleName =
          googleUser.displayName?.trim();

      if (googleName != null &&
          googleName.isNotEmpty) {
        await PlayerService.setGoogleUsername(
          googleName,
        );
      } else {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update({
          'googleLinked': true,
        });
      }

      return GoogleAccountResult.linked;
    } on FirebaseAuthException catch (e) {
      // ─────────────────────────────────────
      // GOOGLE DÉJÀ LIÉ À UN AUTRE COMPTE
      // ─────────────────────────────────────
      //
      // Exemple :
      //
      // Téléphone 1 :
      // Anonymous → Google
      //
      // Téléphone 2 :
      // Anonymous → Google
      //
      // Firebase refuse le link car Google
      // appartient déjà au compte du téléphone 1.
      //
      // Dans ce cas, on récupère directement
      // le compte Google existant.

      if (e.code != 'credential-already-in-use' &&
          e.code != 'account-exists-with-different-credential') {
        rethrow;
      }

      // Connexion au compte Firebase qui possède
      // déjà ce compte Google.
      final result =
          await _auth.signInWithCredential(
        credential,
      );

      final recoveredUser = result.user;

      if (recoveredUser == null) {
        throw Exception(
          'Unable to recover ButtonWorld account.',
        );
      }

      // Vérifie que le profil existe bien.
      await PlayerService.ensurePlayerExists();

      return GoogleAccountResult.recovered;
    }
  }
}