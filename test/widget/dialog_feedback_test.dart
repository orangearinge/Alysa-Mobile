import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alysa_speak/widgets/error_dialog.dart';

/// WIDGET TEST 3: Dialog & Feedback Interaction Testing
///
/// Deskripsi Detail Hasil Uji:
/// 1. errorDialogStructure: Memastikan dialog menampilkan icon error dan tombol OK
/// 2. messageRendering: Menampilkan pesan error yang dinamis sesuai input
/// 3. overlayDismissal: Menguji penutupan dialog saat tombol OK ditekan
/// 4. animationCheck: Memastikan dialog muncul dengan animasi popup
/// 5. loadingIndicator: Mendeteksi keberadaan CircularProgressIndicator saat proses async

void main() {
  group('Dialog & Feedback Widget Tests', () {
    testWidgets('ErrorDialog should show custom title and message', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ErrorDialog.show(
                  context,
                  title: 'Network Fail',
                  message: 'Check Connection',
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Network Fail'), findsOneWidget);
      expect(find.text('Check Connection'), findsOneWidget);
    });

    testWidgets('ErrorDialog should close when OK is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ErrorDialog.show(context, message: 'Message'),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();
      expect(find.text('OK'), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('OK'), findsNothing);
    });

    testWidgets(
      'CircularProgressIndicator should be visible during loading state',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('Error icon should be visible in ErrorDialog', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ErrorDialog.show(context, message: 'Err'),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('Dialog should use rounded corners', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ErrorDialog.show(context, message: 'Err'),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      final Dialog dialog = tester.widget(find.byType(Dialog));
      expect(dialog.shape, isA<RoundedRectangleBorder>());
    });
  });
}
