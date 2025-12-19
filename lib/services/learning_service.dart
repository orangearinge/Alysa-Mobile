import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alysa_speak/models/learning_model.dart';
import 'package:alysa_speak/config/api_constants.dart';

class LearningService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<List<Lesson>> getLessons({String? category}) async {
    try {
      String url = '$baseUrl/lessons';
      if (category != null) {
        url += '?category=$category';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> lessonsJson = data['lessons'];

        return lessonsJson.map((json) => Lesson.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load lessons');
      }
    } catch (e) {
      print('Error fetching lessons: $e');
      return []; // Return empty list on error
    }
  }

  Future<Lesson?> getLessonDetail(String lessonId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/lessons/$lessonId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Lesson.fromJson(json);
      } else {
        throw Exception('Failed to load lesson detail');
      }
    } catch (e) {
      print('Error fetching lesson detail: $e');
      return null;
    }
  }

  Future<Quiz?> getQuiz(String quizId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/quizzes/$quizId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Quiz.fromJson(json);
      } else {
        throw Exception('Failed to load quiz');
      }
    } catch (e) {
      print('Error fetching quiz: $e');
      return null;
    }
  }
}
