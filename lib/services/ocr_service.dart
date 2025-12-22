import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../config/api_constants.dart';

class OcrService {
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  /// Upload dan proses gambar untuk OCR translation
  ///
  /// [imageFile] - File gambar untuk mobile/desktop
  /// [webImage] - XFile untuk web platform
  ///
  /// Returns Map dengan struktur:
  /// {
  ///   'message': String,
  ///   'result': Map (hasil OCR dari backend),
  ///   'record_id': int
  /// }
  Future<Map<String, dynamic>> translateImage({
    File? imageFile,
    XFile? webImage,
  }) async {
    try {
      // Validasi input
      if (imageFile == null && webImage == null) {
        throw Exception('No image provided');
      }

      // Ambil token dari Secure Storage
      final token = await _getToken();

      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated. Please log in again.');
      }

      // Buat multipart request
      final uri = Uri.parse('${ApiConstants.baseUrl}/ocr/translate');
      final request = http.MultipartRequest('POST', uri);

      // Set headers
      request.headers['Authorization'] = 'Bearer $token';

      // Tambahkan file ke request
      if (kIsWeb && webImage != null) {
        // Untuk web platform
        final bytes = await webImage.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes('image', bytes, filename: webImage.name),
        );
      } else if (imageFile != null) {
        // Untuk mobile/desktop platform
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
      }

      // Kirim request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Parse response
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'OCR translation completed',
          'result': responseData['result'] ?? {},
          'record_id': responseData['record_id'],
        };
      } else {
        // Handle error response
        throw Exception(
          responseData['error'] ??
              'Failed to process image: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on FormatException {
      throw Exception('Invalid response format from server.');
    } catch (e) {
      throw Exception('OCR Error: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getOcrHistory() async {
    try {
      final token = await _getToken();

      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated');
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/user/ocr-history'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['history'] ?? []);
      } else {
        throw Exception('Failed to fetch OCR history');
      }
    } catch (e) {
      throw Exception('Error fetching history: ${e.toString()}');
    }
  }
}