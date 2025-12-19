class LessonSection {
  final String title;
  final String content;
  final String? quizId;

  LessonSection({required this.title, this.content = '', this.quizId});

  factory LessonSection.fromJson(Map<String, dynamic> json) {
    return LessonSection(
      title: json['title'],
      content: json['content'] ?? '',
      quizId: json['quizId'],
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final String description;
  final String category;
  final int durationMinutes;
  final bool isCompleted;
  final List<LessonSection> sections;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.durationMinutes,
    this.isCompleted = false,
    this.sections = const [],
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
      durationMinutes: json['durationMinutes'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      sections: json['sections'] != null
          ? (json['sections'] as List)
                .map((s) => LessonSection.fromJson(s))
                .toList()
          : [],
    );
  }
}

class QuizQuestion {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;

  QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      questionText: json['questionText'],
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correctOptionIndex'],
    );
  }
}

class Quiz {
  final String id;
  final String title;
  final List<QuizQuestion> questions;

  Quiz({required this.id, required this.title, required this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      questions: json['questions'] != null
          ? (json['questions'] as List)
                .map((q) => QuizQuestion.fromJson(q))
                .toList()
          : [],
    );
  }
}
