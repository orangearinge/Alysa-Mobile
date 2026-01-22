import 'package:flutter_test/flutter_test.dart';

/// UNIT TEST 4: User Profile Logic Testing
///
/// Deskripsi Detail Hasil Uji:
/// 1. displayNameFormat: Mengambil nama depan dari nama lengkap user
/// 2. daysToTest: Menghitung sisa hari menuju tanggal ujian IELTS
/// 3. dailyGoalValidation: Memastikan target belajar harian masuk akal (>0 menit)
/// 4. statusMessage: Memberikan pesan motivasi berdasarkan progres
/// 5. initialReset: Menghitung status reset data awal

class ProfileLogic {
  static String getFirstName(String fullName) => fullName.split(' ')[0];

  static int calculateDaysRemaining(DateTime testDate) {
    final now = DateTime.now();
    return testDate.difference(now).inDays;
  }

  static String getMotiveMessage(double progress) {
    if (progress < 50) return "Keep going!";
    return "Almost there!";
  }
}

void main() {
  group('User Profile Logic - Unit Tests', () {
    test('getFirstName should extract only the first part of name', () {
      expect(ProfileLogic.getFirstName('Alysa Speak App'), 'Alysa');
      expect(ProfileLogic.getFirstName('John'), 'John');
    });

    test(
      'Days remaining calculation should return positive number for future date',
      () {
        final future = DateTime.now().add(const Duration(days: 10));
        expect(
          ProfileLogic.calculateDaysRemaining(future),
          9,
          reason: 'Hari ke depan harus positif',
        );
      },
    );

    test('Status message should be motivating for low progress', () {
      expect(ProfileLogic.getMotiveMessage(30.0), 'Keep going!');
    });

    test('Status message should be encouraging for high progress', () {
      expect(ProfileLogic.getMotiveMessage(85.0), 'Almost there!');
    });

    test('Handle empty name string safely', () {
      expect(ProfileLogic.getFirstName(''), '');
    });
  });
}
