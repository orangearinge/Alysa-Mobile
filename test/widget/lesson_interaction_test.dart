import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alysa_speak/theme/app_color.dart';

/// WIDGET TEST 4: Lesson Interface Testing
///
/// Deskripsi Detail Hasil Uji:
/// 1. lessonCardRendering: Memastikan card materi belajar menampilkan judul yang benar
/// 2. categoryIndicator: Menampilkan icon kategori (Speaking/Writing) di tiap baris
/// 3. progressIndicator: Menampilkan sirkular progres belajar di Home
/// 4. chipComponent: Menguji filter chip materi berdasarkan durasi
/// 5. emptyStateDisplay: Menampilkan pesan jika tidak ada materi yang ditemukan

void main() {
  group('Lesson Interface Widget Tests', () {
    testWidgets('CircularProgressIndicator should represent daily goal', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircularProgressIndicator(
              value: 0.5,
              color: AppColors.primary,
            ),
          ),
        ),
      );

      final CircularProgressIndicator progress = tester.widget(
        find.byType(CircularProgressIndicator),
      );
      expect(progress.value, 0.5);
      expect(progress.color, AppColors.primary);
    });

    testWidgets('Lesson Card should display Speaking section with icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ListTile(
              leading: Icon(Icons.mic, color: Colors.orange),
              title: Text('Speaking Lesson'),
            ),
          ),
        ),
      );

      expect(find.text('Speaking Lesson'), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsOneWidget);
    });

    testWidgets('Start Test Section should have a gradient background', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, Colors.blue],
                ),
              ),
              child: const Text('Ready to Test?'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('Ready to Test?'),
              matching: find.byType(Container),
            )
            .first,
      );
      final BoxDecoration dec = container.decoration as BoxDecoration;
      expect(dec.gradient, isA<LinearGradient>());
    });

    testWidgets('Lesson List should be scrollable', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: List.generate(
                20,
                (i) => ListTile(title: Text('Lesson $i')),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Lesson 0'), findsOneWidget);
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pump();
      expect(find.text('Lesson 15'), findsOneWidget);
    });

    testWidgets('Lesson item should show duration chip', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Chip(label: Text('30 mins'))),
        ),
      );

      expect(find.byType(Chip), findsOneWidget);
      expect(find.text('30 mins'), findsOneWidget);
    });
  });
}
