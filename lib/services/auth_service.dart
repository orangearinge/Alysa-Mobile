import 'package:alysa_speak/config/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  final _storage = const FlutterSecureStorage();

  String? _jwtToken;
  String? get jwtToken => _jwtToken;

  // Sync with Backend
  Future<void> _syncWithBackend(User user) async {
    try {
      final idToken = await user.getIdToken();
      if (idToken == null) throw "Failed to get ID Token";

      if (kDebugMode) {
        print("FIREBASE ID TOKEN:\n$idToken\n");
      }

      final url = ApiConstants.authUrl;

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _jwtToken = data['access_token'];
        if (_jwtToken != null) {
          await _storage.write(key: 'jwt_token', value: _jwtToken);
        }

        if (kDebugMode) {
          print("BACKEND JWT TOKEN:\n$_jwtToken\n");
        }
      } else {
        if (kDebugMode) {
          print("Backend sync error: ${response.statusCode} ${response.body}");
        }
        // Throw exception to propagate error to UI so user knows login failed
        throw "Backend verification failed: ${response.statusCode}. Please try again.";
      }
    } catch (e) {
      if (kDebugMode) {
        print("Backend connection failed: $e");
      }
      throw "Failed to connect to server: $e";
    }
  }

  Future<UserCredential?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await _syncWithBackend(credential.user!);
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An unknown error occurred';
    }
  }

  // Sign In with Email and Password
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await _syncWithBackend(credential.user!);
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An unknown error occurred';
    }
  }

  // GOOGLE LOGIN (Web + Mobile)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // WEB: gunakan popup dari Firebase saja
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');

        final userCredential = await _auth.signInWithPopup(googleProvider);
        if (userCredential.user != null) {
          await _syncWithBackend(userCredential.user!);
        }
        return userCredential;
      } else {
        // MOBILE (Android/iOS)
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken, // mobile only
        );

        final userCredential = await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          await _syncWithBackend(userCredential.user!);
        }
        return userCredential;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
    _jwtToken = null; // Clear JWT token on sign out
    await _storage.delete(key: 'jwt_token');
  }
}
