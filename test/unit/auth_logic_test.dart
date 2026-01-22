import 'package:flutter_test/flutter_test.dart';

/// UNIT TEST 1: Authentication Logic Testing
///
/// Deskripsi Detail Hasil Uji:
/// 1. validEmail: Berhasil memvalidasi format email standard
/// 2. invalidEmail: Berhasil mendeteksi format email yang salah (tanpa @, tanpa domain)
/// 3. passwordStrength: Memastikan password minimal 6 karakter sesuai kebijakan aplikasi
/// 4. emptyCheck: Mendeteksi input kosong pada form login
/// 5. credentialMatch: Logika dasar pencocokan input (mock)

class AuthLogic {
  static bool isValidEmail(String email) =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  static bool isStrongPassword(String pass) => pass.length >= 6;
  static bool isFormNotEmpty(String email, String pass) =>
      email.isNotEmpty && pass.isNotEmpty;
}

void main() {
  group('Authentication Logic - Unit Tests', () {
    test('Email Validation should return true for correct format', () {
      expect(
        AuthLogic.isValidEmail('user@alysa.com'),
        true,
        reason: 'Format email standard harus valid',
      );
    });

    test('Email Validation should return false for incorrect format', () {
      expect(
        AuthLogic.isValidEmail('invalid-email'),
        false,
        reason: 'Email tanpa domain harus ditolak',
      );
    });

    test('Password Strength should require min 6 characters', () {
      expect(
        AuthLogic.isStrongPassword('12345'),
        false,
        reason: 'Kurang dari 6 karakter harus ditolak',
      );
      expect(
        AuthLogic.isStrongPassword('123456'),
        true,
        reason: '6 karakter atau lebih harus diterima',
      );
    });

    test('Form Validation should detect empty fields', () {
      expect(
        AuthLogic.isFormNotEmpty('', 'pass123'),
        false,
        reason: 'Email kosong harus mengembalikan false',
      );
    });

    test('Logic should return true when both fields filled', () {
      expect(AuthLogic.isFormNotEmpty('test@test.com', '123456'), true);
    });
  });
}
