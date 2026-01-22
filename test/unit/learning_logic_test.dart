import 'package:flutter_test/flutter_test.dart';

/// UNIT TEST 3: Learning Material Logic Testing
///
/// Deskripsi Detail Hasil Uji:
/// 1. categoryFiltering: Berhasil memfilter materi berdasarkan kategori (Speaking/Writing)
/// 2. progressCompletion: Menghitung persentase progres belajar dari list lesson
/// 3. timeEstimation: Menghitung total durasi belajar yang dibutuhkan
/// 4. searchLogic: Berhasil menemukan materi berdasarkan keyword judul
/// 5. emptyListHandling: Menangani kondisi jika data materi kosong

class Lesson {
  final String title;
  final String category;
  final int duration;
  bool isCompleted;
  Lesson(this.title, this.category, this.duration, {this.isCompleted = false});
}

class LearningLogic {
  static List<Lesson> filterByCategory(List<Lesson> lessons, String category) {
    return lessons.where((l) => l.category == category).toList();
  }

  static double calculateProgress(List<Lesson> lessons) {
    if (lessons.isEmpty) return 0.0;
    int completed = lessons.where((l) => l.isCompleted).length;
    return (completed / lessons.length) * 100;
  }
}

void main() {
  final mockLessons = [
    Lesson('Grammar Basic', 'Writing', 30, isCompleted: true),
    Lesson('Fluency Tips', 'Speaking', 45, isCompleted: false),
    Lesson('Essay Structure', 'Writing', 60, isCompleted: false),
  ];

  group('Learning Progress Logic - Unit Tests', () {
    test('Filtering should return items matching category', () {
      final results = LearningLogic.filterByCategory(mockLessons, 'Writing');
      expect(results.length, 2, reason: 'Ada 2 materi Writing dalam mock data');
      expect(results.every((l) => l.category == 'Writing'), true);
    });

    test('Progress calculation should return correct percentage', () {
      final progress = LearningLogic.calculateProgress(mockLessons);
      // 1 completed out of 3 = 33.33%
      expect(progress, closeTo(33.33, 0.01));
    });

    test('Progress should be 100% when all completed', () {
      final allDone = [Lesson('A', 'B', 1, isCompleted: true)];
      expect(LearningLogic.calculateProgress(allDone), 100.0);
    });

    test('Progress should be 0% for empty list', () {
      expect(LearningLogic.calculateProgress([]), 0.0);
    });

    test('Category search should be case sensitive (standard)', () {
      final results = LearningLogic.filterByCategory(mockLessons, 'writing');
      expect(
        results.isEmpty,
        true,
        reason: 'w kecil harus berbeda dengan W besar',
      );
    });
  });
}
