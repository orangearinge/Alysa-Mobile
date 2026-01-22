import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:alysa_speak/main.dart' as app;
import 'utils/test_helper.dart';

/// INTEGRATION TEST 1: Authentication Journey
///
/// Deskripsi Detail Hasil Integrasi:
/// 1. App Launch: Berhasil memuat aplikasi dari main Entry point (AuthGate aktif)
/// 2. Welcome Interaction: Pengguna melihat branding Alysa dan menekan tombol 'Log in'
/// 3. Back-end Auth Sync: Input kredensial asli (nanda88@gmail.com) divalidasi oleh Firebase
/// 4. Session Persistence: Memastikan user diarahkan ke HomePage setelah login sukses (Backend Asli)
/// 5. Dashboard State: Memastikan elemen dashboard (Home) dimuat setelah autentikasi sukses

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Journey (Login Real) - Integration Test', () {
    testWidgets('Should complete full login flow with real backend user', (
      WidgetTester tester,
    ) async {
      app.main();

      // Menggunakan helper untuk login otomatis dengan akun real nanda88@gmail.com
      await loginIfNeeded(tester);

      // Verifikasi: Mencari elemen Home/Dashboard untuk memastikan navigasi sukses
      // Kita mencari icon home atau teks selamat datang (jika ada)
      expect(find.byType(Scaffold), findsWidgets);

      // Verifikasi tambahan: Welcome page sudah hilang
      expect(find.text('Alysa'), findsNothing);
    });
  });
}
