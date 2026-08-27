import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  bool get isEmailVerified;
  bool get isGoogleLinked;

  Future<AuthResult> login({
    required String email,
    required String password,
  });

  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String password,
  });

  Future<AuthResult> signInWithGoogle();
  Future<AuthResult> sendEmailVerification();
  Future<AuthResult> linkWithGoogle();
  Future<AuthResult> unlinkGoogle();
  Future<void> reloadUser();
  Future<void> signOut();
}

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({FirebaseAuth? auth})
      : _auth = auth ?? (Firebase.apps.isNotEmpty ? FirebaseAuth.instance : null);

  final FirebaseAuth? _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _googleSignInInitialized = false;

  @override
  User? get currentUser => _auth?.currentUser;

  @override
  Stream<User?> get authStateChanges => _auth?.authStateChanges() ?? const Stream.empty();

  @override
  bool get isEmailVerified => _auth?.currentUser?.emailVerified ?? false;

  @override
  bool get isGoogleLinked =>
      _auth?.currentUser?.providerData.any((p) => p.providerId == 'google.com') ?? false;

  @override
  Future<void> reloadUser() async {
    await _auth?.currentUser?.reload();
  }

//email login
  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    if (_auth == null) {
      return const AuthResult(
        success: false,
        errorMessage: 'Firebase is not initialized yet.',
      );
    }

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

//email register
  @override
  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    if (_auth == null) {
      return const AuthResult(
        success: false,
        errorMessage: 'Firebase is not initialized yet.',
      );
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(fullName);
      // Immediately send verification email
      await credential.user?.sendEmailVerification();
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
  Future<AuthResult> sendEmailVerification() async {
    final user = _auth?.currentUser;
    if (user == null) {
      return const AuthResult(
        success: false,
        errorMessage: 'No signed in user.',
      );
    }
    try {
      await user.sendEmailVerification();
      return const AuthResult(success: true);
    } on FirebaseAuthException catch (error) {
      return AuthResult(success: false, errorMessage: _messageFor(error));
    } catch (_) {
      return const AuthResult(
        success: false,
        errorMessage: 'Failed to send verification email. Please try again.',
      );
    }
  }

// sign out
  @override
  Future<void> signOut() async {
    if (_auth == null) return;
    await _auth.signOut();
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    if (_auth == null) {
      return const AuthResult(
        success: false,
        errorMessage: 'Firebase is not initialized yet.',
      );
    }

    try {
      if (!_googleSignInInitialized) {
        await _googleSignIn.initialize();
        _googleSignInInitialized = true;
      }

      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      return AuthResult(
        success: true,
        userId: userCredential.user?.uid,
        token: await userCredential.user?.getIdToken(),
      );
    } on FirebaseAuthException catch (error) {
      return AuthResult(success: false, errorMessage: _messageFor(error));
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return const AuthResult(
          success: false,
          errorMessage: 'Google sign-in was canceled.',
        );
      }
      return AuthResult(
        success: false,
        errorMessage: error.description ?? 'Google sign-in failed. Please try again.',
      );
    } on Exception catch (_) {
      return const AuthResult(
        success: false,
        errorMessage: 'Google sign-in failed. Please try again.',
      );
    }
  }

  @override
  Future<AuthResult> linkWithGoogle() async {
    final user = _auth?.currentUser;
    if (user == null) {
      return const AuthResult(
        success: false,
        errorMessage: 'You must be logged in to link your Google account.',
      );
    }

    try {
      if (!_googleSignInInitialized) {
        await _googleSignIn.initialize();
        _googleSignInInitialized = true;
      }

      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await user.linkWithCredential(credential);
      await user.reload();

      return AuthResult(
        success: true,
        userId: userCredential.user?.uid,
        token: await userCredential.user?.getIdToken(),
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'credential-already-in-use') {
        return const AuthResult(
          success: false,
          errorMessage: 'This Google account is already linked to another user account.',
        );
      } else if (error.code == 'provider-already-linked') {
        return const AuthResult(
          success: false,
          errorMessage: 'Your account is already linked with Google.',
        );
      }
      return AuthResult(success: false, errorMessage: _messageFor(error));
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return const AuthResult(
          success: false,
          errorMessage: 'Google sign-in was canceled.',
        );
      }
      return AuthResult(
        success: false,
        errorMessage: error.description ?? 'Google linking failed. Please try again.',
      );
    } catch (_) {
      return const AuthResult(
        success: false,
        errorMessage: 'Failed to link Google account. Please try again.',
      );
    }
  }

  @override
  Future<AuthResult> unlinkGoogle() async {
    final user = _auth?.currentUser;
    if (user == null) {
      return const AuthResult(
        success: false,
        errorMessage: 'No signed in user.',
      );
    }
    try {
      final updatedUser = await user.unlink('google.com');
      await updatedUser.reload();
      return AuthResult(
        success: true,
        userId: updatedUser.uid,
      );
    } on FirebaseAuthException catch (error) {
      return AuthResult(success: false, errorMessage: _messageFor(error));
    } catch (_) {
      return const AuthResult(
        success: false,
        errorMessage: 'Failed to unlink Google account. Please try again.',
      );
    }
  }

// possible error messages
  String _messageFor(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with this email address. Please sign in with email and password first, then link your Google account in Profile.';
      case 'credential-already-in-use':
        return 'This Google account is already linked with another user.';
      case 'provider-already-linked':
        return 'This provider is already linked to your account.';
      case 'weak-password':
        return 'Choose a stronger password.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'requires-recent-login':
        return 'This operation is sensitive and requires recent authentication. Please log in again.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }
}
