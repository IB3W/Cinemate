import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  String? get userEmail => _user?.email;
  String? get userName => _user?.displayName;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> _handleAuthAction(Future<void> Function() action) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      await action();
    } on FirebaseAuthException catch (e) {
      _errorMessage = _cleanError(e.code);
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future <bool> loginWithEmail(String email, String password) async {
    await _handleAuthAction(() async {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    });
    return _errorMessage == null;
  }

  Future <bool> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    await _handleAuthAction(() async {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await credential.user?.updateDisplayName(name.trim());
      _user = _auth.currentUser;
    });
    return _errorMessage == null;
  }

  Future<bool> loginWithGoogle() async {
    await _handleAuthAction(() async {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    });
    return _errorMessage == null;
  }

  Future<bool> resetPassword(String email) async {
    await _handleAuthAction(() async {
      await _auth.sendPasswordResetEmail(email: email.trim());
    });
    return _errorMessage == null;
  }

  Future<void> reloadUser() async {
    await _user?.reload();
    _user = _auth.currentUser;
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _cleanError(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'email-already-in-use':
        return 'Email already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
