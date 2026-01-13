import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alysa_speak/config/api_constants.dart';
import 'package:alysa_speak/services/auth_service.dart';
import 'package:alysa_speak/models/test_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TestService {
  final _storage = const FlutterSecureStorage();

  // Custom API endpoint getter for practice
  String get _practiceStartUrl {
    // Assuming ApiConstants has baseUrl. We append our path.
    // This is a quick workaround if ApiConstants doesn't have practice url yet.
    // Ideally we add it to ApiConstants but constructing it safely works too.
    String base = ApiConstants.baseUrl;
    return '$base/test/practice/start';
  }

  String get _practiceSubmitUrl {
    String base = ApiConstants.baseUrl;
    return '$base/test/practice/submit';
  }

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Start Practice Test
  Future<Map<String, dynamic>> startPracticeTest() async {
    final token = await _getToken();
    if (token == null) throw "Authentication required";

    try {
      final response = await http.post(
        Uri.parse(_practiceStartUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> rawQuestions = data['questions'];
        List<PracticeQuestion> questions = rawQuestions
            .map((q) => PracticeQuestion.fromJson(q))
            .toList();

        return {'session_id': data['session_id'], 'questions': questions};
      } else {
        throw "Failed to start test: ${response.body}";
      }
    } catch (e) {
      throw "Connection error: $e";
    }
  }

  // Submit Practice Test
  Future<PracticeTestResult> submitPracticeTest(
    int sessionId,
    List<PracticeQuestion> questions, {
    String modelType = 'gemini',
  }) async {
    final token = await _getToken();
    if (token == null) throw "Authentication required";

    try {
      // Prepare payload
      List<Map<String, dynamic>> answersPayload = questions
          .map(
            (q) => {
              'question_id': q.questionId,
              'answer': q.userAnswer ?? '',
              'section': q.section,
            },
          )
          .toList();

      final response = await http.post(
        Uri.parse(_practiceSubmitUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'session_id': sessionId,
          'answers': answersPayload,
          'model': modelType,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PracticeTestResult.fromJson(data);
      } else {
        throw "Failed to submit test: ${response.body}";
      }
    } catch (e) {
      throw "Connection error: $e";
    }
  }
}
