import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper untuk melakukan login otomatis dalam Integration Test
/// menggunakan akun real yang sudah ada di database Firebase.
Future<void> loginIfNeeded(WidgetTester tester) async {
  await tester.pumpAndSettle(const Duration(seconds: 3));

  // 1. Cek apakah kita di Welcome Page (AuthGate mendarat di sini jika belum login)
  final loginLink = find.text('Log in');
  if (loginLink.evaluate().isNotEmpty) {
    // Navigasi ke Halaman Login
    await tester.tap(loginLink);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 2. Isi form login dengan Kredensial Real User (Backend Asli)
    final emailField = find.byType(TextField).first;
    final passField = find.byType(TextField).last;

    await tester.enterText(emailField, 'nanda88@gmail.com');
    await tester.enterText(passField, 'nanda88');
    await tester.pumpAndSettle();

    // 3. Tekan tombol Sign in
    final signInBtn = find.text('Sign in');
    await tester.tap(signInBtn);

    // Tunggu proses autentikasi Firebase & navigasi ke HomePage (Backend Asli)
    // Gunakan durasi yang cukup lama untuk memastikan respon server diterima
    await tester.pumpAndSettle(const Duration(seconds: 8));
  }
}
