import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:alysa_speak/main.dart' as app;
import 'utils/test_helper.dart';

/// INTEGRATION TEST 2: Learning Workflow Integration
///
/// Deskripsi Detail Hasil Integrasi:
/// 1. Auto-Login: Sistem otomatis masuk menggunakan akun real nanda88@gmail.com
/// 2. Category Selection: Memilih kategori 'Speaking' dari Dashboard
/// 3. Lesson Entry: Memilih salah satu materi pembelajaran yang tersedia
/// 4. Section Navigation: Menelusuri seluruh bagian materi menggunakan tombol 'Next'
/// 5. Completion Logic: Menekan tombol 'Finish' di bagian akhir untuk mengupdate progres di Firestore

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Learning Workflow - Integration Test', () {
    testWidgets('Should complete a full lesson from start to finish', (
      WidgetTester tester,
    ) async {
      app.main();

      await loginIfNeeded(tester);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 1. Pilih kategori 'Speaking'
      final speakingCategory = find.text('Speaking');
      expect(speakingCategory, findsWidgets);
      await tester.tap(speakingCategory.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. Pilih materi pertama (Card/ListTile)
      expect(find.byType(Card), findsAtLeastNWidgets(1));
      await tester.tap(find.byType(Card).first);

      // Tunggu detail materi muncul (handle loading indicator)
      int detailWait = 0;
      while (detailWait < 10 &&
          find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
        await tester.pump(const Duration(seconds: 1));
        detailWait++;
      }
      await tester.pumpAndSettle();

      // 3. Navigasi melalui section Materi
      // Loop untuk menekan 'Next' sampai tombol berubah jadi 'Finish'
      bool reachedEnd = false;
      int securityCounter = 0; // Mencegah infinite loop jika ada error

      while (!reachedEnd && securityCounter < 15) {
        final nextBtn = find.text('Next');
        final finishBtn = find.text('Finish');

        if (finishBtn.evaluate().isNotEmpty) {
          await tester.tap(finishBtn);
          reachedEnd = true;
        } else if (nextBtn.evaluate().isNotEmpty) {
          await tester.tap(nextBtn);
          await tester.pumpAndSettle(const Duration(seconds: 1));
        } else {
          break;
        }
        securityCounter++;
      }

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 4. Verifikasi muncul Snackbar sukses dan kembali ke list
      expect(find.textContaining('completed'), findsWidgets);
      expect(find.textContaining('Materials'), findsWidgets);
    });
  });
}
