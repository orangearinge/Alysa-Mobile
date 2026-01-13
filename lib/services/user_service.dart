import 'dart:convert';
import 'package:alysa_speak/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:alysa_speak/config/api_constants.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UserService {
  final String baseUrl = ApiConstants.baseUrl;
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<UserProfile?> getUserProfile() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserProfile.fromJson(data);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  Future<void> updateUserProfile({
    String? username,
    String? email,
    required double targetScore,
    required int dailyStudyTimeMinutes,
    required DateTime testDate,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Authentication token not found');

    final currentUser = firebase.FirebaseAuth.instance.currentUser;

    // Update Firebase Profile
    if (username != null) {
      await currentUser?.updateDisplayName(username);
    }
    if (email != null && email != currentUser?.email) {
      await currentUser?.verifyBeforeUpdateEmail(email);
    }

    final Map<String, dynamic> body = {
      'target_score': targetScore,
      'daily_study_time_minutes': dailyStudyTimeMinutes,
      'test_date': testDate.toIso8601String(),
    };

    if (username != null) body['username'] = username;
    if (email != null) body['email'] = email;

    final response = await http.put(
      Uri.parse('$baseUrl/user/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to update profile');
    }
  }
}
