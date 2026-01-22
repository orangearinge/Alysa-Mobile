import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:alysa_speak/main.dart' as app;
import 'utils/test_helper.dart';

/// INTEGRATION TEST 3: Simulation Test Flow Integration
///
/// Deskripsi Detail Hasil Integrasi:
/// 1. Auth Bridge: Masuk ke aplikasi menggunakan session nanda88
/// 2. Dashboard Landing: Menekan tombol 'Start Test' di dashboard
/// 3. Test Setup: Menekan 'START TEST' di halaman persiapan pengerjaan
/// 4. Question Loop: Menjawab setiap pertanyaan (Writing/Speaking) hingga selesai
/// 5. AI Grading: Menekan 'FINISH TEST' dan menunggu AI memberikan skor di HasilTestPage

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Simulation Test Flow - Integration Test', () {
    testWidgets('Should complete a full practice test and view AI results', (
      WidgetTester tester,
    ) async {
      app.main();

      await loginIfNeeded(tester);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 1. Masuk ke StartTest Page dari Dashboard
      final dashboardStartBtn = find.text('Start Test');
      expect(dashboardStartBtn, findsOneWidget);
      await tester.tap(dashboardStartBtn);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. Klik START TEST untuk mulai quiz
      await tester.tap(find.text('START TEST'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 3. Loop menjawab semua pertanyaan
      bool testFinished = false;
      int securityCounter = 0;

      while (!testFinished && securityCounter < 15) {
        // Cek jika ada input field (Writing), isi dengan teks
        final inputField = find.byType(TextField);
        if (inputField.evaluate().isNotEmpty) {
          await tester.enterText(
            inputField,
            'This is an automated test answer for IELTS simulation.',
          );
          await tester.pump();
        }

        // Cari tombol Next atau Finish
        final nextQuestionBtn = find.text('NEXT QUESTION');
        final finishTestBtn = find.text('FINISH TEST');

        if (finishTestBtn.evaluate().isNotEmpty) {
          await tester.tap(finishTestBtn);
          testFinished = true;
        } else if (nextQuestionBtn.evaluate().isNotEmpty) {
          await tester.tap(nextQuestionBtn);
          await tester.pumpAndSettle(const Duration(seconds: 2));
        } else {
          break;
        }
        securityCounter++;
      }

      // 4. Tahap Akhir: Menunggu Evaluasi AI (Layar Loading)
      // AI Grading mungkin memakan waktu 30-60 detik.
      // Kita gunakan loop manual karena pumpAndSettle bisa stuck di CircularProgressIndicator.
      int waitCounter = 0;
      bool foundResult = false;
      while (waitCounter < 60 && !foundResult) {
        await tester.pump(const Duration(seconds: 1));
        if (find.text('TEST RESULT').evaluate().isNotEmpty) {
          foundResult = true;
        }
        waitCounter++;
      }

      // 5. Verifikasi mendarat di HasilTestPage
      expect(find.text('TEST RESULT'), findsWidgets);
      expect(find.textContaining('Overall Band'), findsWidgets);
    });
  });
}
