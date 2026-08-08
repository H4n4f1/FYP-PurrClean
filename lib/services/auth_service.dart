// ─────────────────────────────────────────────────────────────────────────
// AUTH SERVICE TEMPLATE
//
// This file defines a backend-agnostic contract (`AuthService`) plus a
// `MockAuthService` you can use right now while your real backend isn't
// ready. When you're ready to connect a real database/API, create a new
// class that implements `AuthService` (see the commented `ApiAuthService`
// example at the bottom) and swap it in inside `auth_screen.dart`:
//
//   final AuthService _authService = MockAuthService();   // <- change this
//
// That's the ONLY line you need to change in the UI code.
// ─────────────────────────────────────────────────────────────────────────

class AuthResult {
  final bool success;
  final String? errorMessage;
  final String? userId;
  final String? token;

  AuthResult({
    required this.success,
    this.errorMessage,
    this.userId,
    this.token,
  });
}

abstract class AuthService {
  Future<AuthResult> login({
    required String email,
    required String password,
  });

  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String password,
  });
}

/// Temporary in-memory mock so the UI is fully testable before a real
/// backend exists. Accepts the demo credentials shown on the login screen,
/// and "succeeds" for any registration attempt.
class MockAuthService implements AuthService {
  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (email == 'demo@purrclean.com' && password == 'demo1234') {
      return AuthResult(success: true, userId: 'demo-user-id', token: 'mock-token');
    }
    return AuthResult(success: false, errorMessage: 'Invalid email or password');
  }

  @override
  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (email.isEmpty || password.length < 6) {
      return AuthResult(success: false, errorMessage: 'Invalid registration details');
    }
    return AuthResult(success: true, userId: 'new-user-id', token: 'mock-token');
  }
}

// ─────────────────────────────────────────────────────────────────────────
// EXAMPLE: REST API IMPLEMENTATION (uncomment + add `http` to pubspec.yaml)
// ─────────────────────────────────────────────────────────────────────────
//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class ApiAuthService implements AuthService {
//   final String baseUrl = 'https://your-api.com/api';
//
//   @override
//   Future<AuthResult> login({required String email, required String password}) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/auth/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email, 'password': password}),
//       );
//       final data = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         return AuthResult(success: true, userId: data['userId'], token: data['token']);
//       }
//       return AuthResult(success: false, errorMessage: data['message'] ?? 'Login failed');
//     } catch (e) {
//       return AuthResult(success: false, errorMessage: 'Network error: $e');
//     }
//   }
//
//   @override
//   Future<AuthResult> register({required String fullName, required String email, required String password}) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/auth/register'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'fullName': fullName, 'email': email, 'password': password}),
//       );
//       final data = jsonDecode(response.body);
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return AuthResult(success: true, userId: data['userId'], token: data['token']);
//       }
//       return AuthResult(success: false, errorMessage: data['message'] ?? 'Registration failed');
//     } catch (e) {
//       return AuthResult(success: false, errorMessage: 'Network error: $e');
//     }
//   }
// }
//
// ─────────────────────────────────────────────────────────────────────────
// EXAMPLE: FIREBASE AUTH IMPLEMENTATION
// (uncomment + add firebase_core & firebase_auth to pubspec.yaml)
// ─────────────────────────────────────────────────────────────────────────
//
// import 'package:firebase_auth/firebase_auth.dart';
//
// class FirebaseAuthService implements AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   Future<AuthResult> login({required String email, required String password}) async {
//     try {
//       final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
//       return AuthResult(success: true, userId: cred.user?.uid);
//     } on FirebaseAuthException catch (e) {
//       return AuthResult(success: false, errorMessage: e.message);
//     }
//   }
//
//   @override
//   Future<AuthResult> register({required String fullName, required String email, required String password}) async {
//     try {
//       final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//       await cred.user?.updateDisplayName(fullName);
//       return AuthResult(success: true, userId: cred.user?.uid);
//     } on FirebaseAuthException catch (e) {
//       return AuthResult(success: false, errorMessage: e.message);
//     }
//   }
// }