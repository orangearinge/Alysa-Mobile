import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:alysa_speak/main.dart' as app;
import 'utils/test_helper.dart';

/// INTEGRATION TEST 4: Profile Management Integration
///
/// Deskripsi Detail Hasil Integrasi:
/// 1. Auth Sync: Masuk ke HomePage dengan backend asli
/// 2. Tab Navigation: Berpindah dari tab Home ke tab Profile menggunakan Navbar
/// 3. Profile Rendering: Memastikan data user nanda88 ditarik dari Firestore asli
/// 4. Profile Interaction: Verifikasi keberadaan elemen profil (Username/Email)
/// 5. Logout Feature: Menguji navigasi kembali ke Welcome Page (Opsional)

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profile Management - Integration Test', () {
    testWidgets('Should navigate to profile tab and verify user info', (
      WidgetTester tester,
    ) async {
      app.main();

      // 1. Auto Login
      await loginIfNeeded(tester);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 2. Berpindah ke tab Profile (UI Asli Navbar)
      // Gunakan locator teks 'Profile' sesuai BottomNavigationBar
      final profileTab = find.text('Profile');
      expect(profileTab, findsWidgets);
      await tester.tap(profileTab.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 3. Verifikasi info user muncul (Data dari backend Firestore)
      // Mencari username 'nanda88' atau email
      expect(find.textContaining('nanda88'), findsWidgets);

      // 4. Verifikasi elemen UI Profile
      expect(find.byType(CircleAvatar), findsWidgets);
    });
  });
}
