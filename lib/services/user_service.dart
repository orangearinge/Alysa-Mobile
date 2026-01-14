import 'dart:convert';
import 'package:alysa_speak/models/user_model.dart';
import 'package:alysa_speak/models/test_history_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:alysa_speak/config/api_constants.dart';

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

  Future<bool> updateUserProfile({
    required double targetScore,
    required int dailyStudyTimeMinutes,
    required DateTime testDate,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.put(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'target_score': targetScore,
          'daily_study_time_minutes': dailyStudyTimeMinutes,
          'test_date': testDate.toIso8601String(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  Future<List<TestSessionModel>> getTestHistory() async {
    try {
      final token = await _getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse('$baseUrl/user/test-sessions'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> sessionsJson = data['test_sessions'] ?? [];
        return sessionsJson
            .map((json) => TestSessionModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load test history');
      }
    } catch (e) {
      print('Error fetching test history: $e');
      return [];
    }
  }
}
