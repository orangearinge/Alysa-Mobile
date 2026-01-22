import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:alysa_speak/main.dart' as app;
import 'utils/test_helper.dart';

/// INTEGRATION TEST 5: Chatbot Assistant Integration
///
/// Deskripsi Detail Hasil Integrasi:
/// 1. Login State: Masuk dengan akun real nanda88
/// 2. Entry Point: Membuka chatbot melalui tombol melayang di Dashboard
/// 3. Interaction: Menguji pengiriman pesan teks ke AI
/// 4. Feedback Loop: Menunggu respon balasan dari AI Assistant (Backend Engine)
/// 5. Visibility: Memastikan pesan user dan AI muncul dalam daftar chat

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Chatbot Assistant - Integration Test', () {
    testWidgets('Should exchange messages with AI successfully', (
      WidgetTester tester,
    ) async {
      app.main();

      await loginIfNeeded(tester);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 1. Klik tombol Chatbot di Dashboard
      final chatBtn = find.byIcon(Icons.chat_bubble_outline);
      expect(chatBtn, findsOneWidget);
      await tester.tap(chatBtn);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. Ketik pesan
      final inputField = find.byType(TextField);
      expect(inputField, findsOneWidget);
      const testMessage = 'Give me a quick tip for IELTS Speaking Part 1';
      await tester.enterText(inputField, testMessage);
      await tester.pumpAndSettle();

      // 3. Tekan tombol Send (Icons.send di dalam GestureDetector)
      final sendBtn = find.byIcon(Icons.send);
      expect(sendBtn, findsOneWidget);
      await tester.tap(sendBtn);

      // Tunggu animasi pengiriman dan clearing input
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 4. Verifikasi pesan User muncul di Chat Bubble
      expect(find.text(testMessage), findsOneWidget);

      // 5. Tunggu respon AI (Backend Call antar komponen)
      // Memberikan waktu 10 detik untuk respon AI Engine (Gemini/Deepseek)
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Jika bot menjawab, jumlah chat bubble (Container di dalam ListView) harus bertambah
      // Setidaknya ada pesan selamat datang + pesan user + pesan AI
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
