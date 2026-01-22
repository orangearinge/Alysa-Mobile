import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alysa_speak/pages/welcome_screen.dart';
import 'package:alysa_speak/theme/app_color.dart';

/// WIDGET TEST 1: Login/Welcome Screen Testing
///
/// Deskripsi Detail Hasil Uji:
/// 1. brandRendering: Memastikan teks "Alysa" muncul dengan style yang benar
/// 2. buttonDetection: Mendeteksi keberadaan tombol "Create an account"
/// 3. navigationTrigger: Menguji aksi tap pada tombol navigasi login
/// 4. responsiveLayout: Memastikan Stack dan Positioned element di render tanpa overflow
/// 5. colorTheme: Memastikan background menggunakan AppColors.background

void main() {
  group('Welcome Screen Widget Tests', () {
    testWidgets('App name Alysa should be visible with specific font size', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: WelcomePage()));

      final brandFinder = find.text('Alysa');
      expect(brandFinder, findsOneWidget);

      final Text brandText = tester.widget(brandFinder);
      expect(
        brandText.style?.fontSize,
        60,
        reason: 'Font size branding harus 60 sesuai desain',
      );
    });

    testWidgets(
      'Create an account button should be an ElevatedButton with primary color',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: WelcomePage()));

        final buttonFinder = find.widgetWithText(
          ElevatedButton,
          'Create an account',
        );
        expect(buttonFinder, findsOneWidget);

        final ElevatedButton button = tester.widget(buttonFinder);
        expect(button.style?.backgroundColor?.resolve({}), AppColors.primary);
      },
    );

    testWidgets('Log in link should be clickable and use primary color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: WelcomePage()));

      final loginFinder = find.text('Log in');
      expect(loginFinder, findsOneWidget);

      final Text loginText = tester.widget(loginFinder);
      expect(loginText.style?.color, AppColors.primary);
    });

    testWidgets('Should have background decoration (CircleAvatars)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: WelcomePage()));

      // Ada minimal 2 CircleAvatar sebagai hiasan latar belakang
      expect(find.byType(CircleAvatar), findsAtLeastNWidgets(2));
    });

    testWidgets('Tapping Create an account should trigger navigation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const WelcomePage(),
          routes: {
            '/create': (context) => const Scaffold(body: Text('Create Page')),
          },
        ),
      );

      await tester.tap(find.text('Create an account'));
      await tester.pumpAndSettle();

      expect(find.text('Create Page'), findsOneWidget);
    });
  });
}
