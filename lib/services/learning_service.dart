import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alysa_speak/models/learning_model.dart';
import 'package:alysa_speak/config/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LearningService {
  final String baseUrl = ApiConstants.baseUrl;
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<List<Lesson>> getLessons({String? category}) async {
    try {
      final token = await _getToken();
      String url = '$baseUrl/lessons';
      if (category != null) {
        url += '?category=$category';
      }

      print('DEBUG: Fetching lessons from $url');
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> lessonsJson = data['lessons'];

        return lessonsJson.map((json) => Lesson.fromJson(json)).toList();
      } else {
        print(
          'DEBUG: Failed to load lessons: ${response.statusCode} - ${response.body}',
        );
        throw Exception('Failed to load lessons');
      }
    } catch (e) {
      print('Error fetching lessons: $e');
      return []; // Return empty list on error
    }
  }

  Future<Lesson?> getLessonDetail(String lessonId) async {
    final url = '$baseUrl/lessons/$lessonId';
    try {
      print('DEBUG: Fetching lesson detail from $url');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Lesson.fromJson(json);
      } else {
        print(
          'DEBUG: Failed to load lesson detail: ${response.statusCode} - ${response.body}',
        );
        throw Exception('Failed to load lesson detail');
      }
    } catch (e) {
      print('Error fetching lesson detail: $e');
      return null;
    }
  }

  Future<Quiz?> getQuiz(String quizId) async {
    final urlStr = '$baseUrl/quizzes/$quizId';
    try {
      print('DEBUG: Fetching quiz from $urlStr');
      final response = await http.get(Uri.parse(urlStr));

      print('DEBUG: Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Quiz.fromJson(json);
      } else {
        print('DEBUG: Response body: ${response.body}');
        throw Exception('Failed to load quiz: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching quiz ($urlStr): $e');
      return null;
    }
  }

  Future<bool> completeLesson(String lessonId) async {
    final url = '$baseUrl/learning/progress';
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'lesson_id': lessonId, 'is_completed': true}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error completing lesson: $e');
      return false;
    }
  }
}
