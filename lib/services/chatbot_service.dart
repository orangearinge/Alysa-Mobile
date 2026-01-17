import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:alysa_speak/config/api_constants.dart';

class ChatbotService {
  final String baseUrl = ApiConstants.baseUrl;
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<String> sendMessage(String message) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Authentication token not found');

      final response = await http.post(
        Uri.parse('$baseUrl/chatbot/chat'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['response'] ?? "I'm sorry, I couldn't understand that.";
      } else {
        throw Exception('Failed to get response from chatbot');
      }
    } catch (e) {
      print('Error sending message to chatbot: $e');
      throw Exception('Failed to communicate with the chatbot');
    }
  }
}
