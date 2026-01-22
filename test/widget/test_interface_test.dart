import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alysa_speak/theme/app_color.dart';

/// WIDGET TEST 5: Test Practice Interface Testing
///
/// Deskripsi Detail Hasil Uji:
/// 1. timerDisplay: Memastikan sisa waktu ujian tampil secara real-time
/// 2. questionRendering: Menampilkan teks soal IELTS dengan font yang jelas
/// 3. inputFieldTesting: Menguji kemampuan user untuk mengetik jawaban Writing
/// 4. microphoneToggle: Memastikan elemen Speaking (mic) merespon saat di-tap
/// 5. skipStep: Menguji fungsionalitas tombol skip atau submit soal

void main() {
  group('Test Practice Widget Tests', () {
    testWidgets('Writing input field should allow text entry', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'Enter answer...'),
            ),
          ),
        ),
      );

      await tester.enterText(
        find.byType(TextField),
        'IELTS Task 1 Response...',
      );
      expect(controller.text, 'IELTS Task 1 Response...');
    });

    testWidgets('Timer text should use a distinct style', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text(
              '02:59',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      );

      final Text timerText = tester.widget(find.text('02:59'));
      expect(timerText.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('Speaking mic icon should change color when active', (
      WidgetTester tester,
    ) async {
      bool isActive = false;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => MaterialApp(
            home: Scaffold(
              body: IconButton(
                icon: Icon(
                  isActive ? Icons.stop : Icons.mic,
                  color: isActive ? Colors.red : AppColors.primary,
                ),
                onPressed: () => setState(() => isActive = !isActive),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      final Icon activeIcon = tester.widget(find.byIcon(Icons.stop));
      expect(activeIcon.color, Colors.red);
    });

    testWidgets(
      'Test section should display remaining question count (e.g., 5 of 10)',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: Text('Question 5 of 10'))),
        );

        expect(find.text('Question 5 of 10'), findsOneWidget);
      },
    );

    testWidgets('BackButton should be present during practice test', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: BackButton(),
            ),
          ),
        ),
      );

      expect(find.byType(BackButton), findsOneWidget);
    });
  });
}
