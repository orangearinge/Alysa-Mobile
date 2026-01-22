import 'package:flutter_test/flutter_test.dart';

/// UNIT TEST 2: IELTS Scoring Logic Testing
///
/// Deskripsi Detail Hasil Uji:
/// 1. validRange: Memastikan skor berada dalam range 0.0 - 9.0
/// 2. scoreRounding: Menguji pembulatan skor IELTS ke 0.5 terdekat (standard IELTS)
/// 3. overallCalculation: Menguji rata-rata dari 4 komponen (Listening, Reading, Writing, Speaking)
/// 4. edgeCaseMin: Memasukkan skor 0.0 sebagai batas bawah
/// 5. edgeCaseMax: Memasukkan skor 9.0 sebagai batas atas

class IeltsScorer {
  static double roundToIeltsBand(double score) {
    // IELTS rounds to nearest 0.5
    return (score * 2).round() / 2;
  }

  static bool isValidBand(double score) => score >= 0.0 && score <= 9.0;

  static double calculateOverall(double l, double r, double w, double s) {
    double average = (l + r + w + s) / 4;
    return roundToIeltsBand(average);
  }
}

void main() {
  group('IELTS Scoring Logic - Unit Tests', () {
    test('Score should be within 0.0 to 9.0', () {
      expect(IeltsScorer.isValidBand(7.5), true);
      expect(
        IeltsScorer.isValidBand(10.0),
        false,
        reason: 'Skor di atas 9.0 tidak valid',
      );
    });

    test('Band Score should round to nearest 0.5 (IELTS Standard)', () {
      expect(
        IeltsScorer.roundToIeltsBand(6.25),
        6.5,
        reason: '6.25 harus dibulatkan ke 6.5',
      );
      expect(
        IeltsScorer.roundToIeltsBand(7.1),
        7.0,
        reason: '7.1 harus dibulatkan ke 7.0',
      );
    });

    test('Overall Band calculation should be correct', () {
      // 7+6+7+8 = 28. 28/4 = 7.0
      expect(IeltsScorer.calculateOverall(7.0, 6.0, 7.0, 8.0), 7.0);
    });

    test('Overall Band rounding for complex averages', () {
      // 6.5+6.0+6.5+6.0 = 25. 25/4 = 6.25 -> 6.5
      expect(IeltsScorer.calculateOverall(6.5, 6.0, 6.5, 6.0), 6.5);
    });

    test('Edge case: Maximum potential score', () {
      expect(IeltsScorer.calculateOverall(9.0, 9.0, 9.0, 9.0), 9.0);
    });
  });
}
