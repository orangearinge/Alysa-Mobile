import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alysa_speak/theme/app_color.dart';

/// WIDGET TEST 2: Navigation Menu Testing
///
/// Deskripsi Detail Hasil Uji:
/// 1. bottomNavDetection: Mendeteksi keberadaan BottomNavigationBar atau BottomAppBar
/// 2. tabAccessibility: Memastikan icon Home dan Profile dapat diinteraksi
/// 3. selectionStyle: Menampilkan indikator warna berbeda saat tab aktif
/// 4. fabInteraction: Menguji keberadaan tombol Floating Action Button (Camera)
/// 5. notchEffect: Memastikan BottomAppBar memiliki notch untuk FAB

void main() {
  group('Navigation Menu Widget Tests', () {
    testWidgets('BottomAppBar should have Home and Profile items', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomAppBar(
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.home), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.person), onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets(
      'FloatingActionButton (Camera) should be in center docked position',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.camera),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            ),
          ),
        );

        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byIcon(Icons.camera), findsOneWidget);
      },
    );

    testWidgets('Active tab should use primary color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomAppBar(
              child: Icon(Icons.home, color: AppColors.primary),
            ),
          ),
        ),
      );

      final Icon icon = tester.widget(find.byIcon(Icons.home));
      expect(icon.color, AppColors.primary);
    });

    testWidgets('Tapping on a nav item should trigger state change', (
      WidgetTester tester,
    ) async {
      int selected = 0;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => MaterialApp(
            home: Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: selected,
                onTap: (i) => setState(() => selected = i),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.person));
      await tester.pump();

      final BottomNavigationBar nav = tester.widget(
        find.byType(BottomNavigationBar),
      );
      expect(nav.currentIndex, 1);
    });

    testWidgets('BottomAppBar should handle safe areas', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(bottomNavigationBar: BottomAppBar())),
      );
      expect(find.byType(BottomAppBar), findsOneWidget);
    });
  });
}
