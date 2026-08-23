import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  const AuthResult({
    required this.success,
    this.errorMessage,
    this.userId,
    this.token,
  });

  final bool success;
  final String? errorMessage;
  final String? userId;
  final String? token;
}

abstract class AuthService {
  User? get currentUser;
  Stream<User?> get authStateChanges;

  Future<AuthResult> login({
    required String email,
    required String password,
  });

  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> signOut();
}

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(
        success: true,
        userId: credential.user?.uid,
        token: await credential.user?.getIdToken(),
      );
    } on FirebaseAuthException catch (error) {
      return AuthResult(success: false, errorMessage: _messageFor(error));
    }
  }

  @override
  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(fullName);
      await credential.user?.reload();
      return AuthResult(
        success: true,
        userId: credential.user?.uid,
        token: await credential.user?.getIdToken(),
      );
    } on FirebaseAuthException catch (error) {
      return AuthResult(success: false, errorMessage: _messageFor(error));
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  String _messageFor(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Choose a stronger password.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }
}
