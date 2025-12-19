import 'package:flutter/material.dart';

class UserProfileMock {
  String? uid;
  double? targetScore;
  int? dailyStudyTimeMinutes;
  DateTime? testDate;

  UserProfileMock({
    this.uid,
    this.targetScore,
    this.dailyStudyTimeMinutes,
    this.testDate,
  });
}

class LessonSection {
  final String title;
  final String content;
  final String? quizId; // If not null, this section is a quiz entry

  LessonSection({
    required this.title,
    this.content = '',
    this.quizId,
  });
}

class LessonMock {
  final String id;
  final String title;
  final String description;
  final String category; // Speaking, Writing, Reading, Listening
  final int durationMinutes;
  final bool isCompleted;
  final List<LessonSection> sections;

  LessonMock({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.durationMinutes,
    this.isCompleted = false,
    this.sections = const [],
  });
}

class QuizQuestionMock {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;

  QuizQuestionMock({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });
}

class QuizMock {
  final String id;
  final String title;
  final List<QuizQuestionMock> questions;

  QuizMock({
    required this.id,
    required this.title,
    required this.questions,
  });
}

class MockData {
  static final MockData _instance = MockData._internal();
  factory MockData() => _instance;
  MockData._internal();

  UserProfileMock currentUser = UserProfileMock(
      uid: 'dummy_uid',
      targetScore: 6.5,
      dailyStudyTimeMinutes: 30,
      testDate: DateTime.now().add(const Duration(days: 30))
  );

  void setUserProfile({
    double? targetScore,
    int? dailyStudyTimeMinutes,
    DateTime? testDate,
  }) {
    currentUser.targetScore = targetScore ?? currentUser.targetScore;
    currentUser.dailyStudyTimeMinutes = dailyStudyTimeMinutes ?? currentUser.dailyStudyTimeMinutes;
    currentUser.testDate = testDate ?? currentUser.testDate;
  }

  final List<LessonMock> lessons = [
    LessonMock(
      id: '1',
      title: 'Introduction to IELTS Speaking',
      description: 'Learn the basics of the Speaking test format.',
      category: 'Speaking',
      durationMinutes: 15,
      isCompleted: true,
      sections: [
        LessonSection(
          title: 'Overview',
          content: 'The IELTS Speaking test consists of 3 parts and lasts 11-14 minutes. It is a face-to-face interview with an examiner.',
        ),
        LessonSection(
          title: 'Part 1: Introduction and Interview',
          content: 'In this part, the examiner asks you general questions about yourself and a range of familiar topics, such as home, family, work, studies and interests. This part lasts between 4 and 5 minutes.',
        ),
        LessonSection(
          title: 'Part 2: Long Turn',
          content: 'You will be given a card which asks you to talk about a particular topic. You will have 1 minute to prepare before speaking for up to 2 minutes. The examiner will then ask one or two questions on the same topic.',
        ),
        LessonSection(
          title: 'Quiz: Speaking Basics',
          quizId: 'q1',
        ),
      ],
    ),
    LessonMock(
      id: '2',
      title: 'Writing Task 1: Charts',
      description: 'How to describe bar charts effectively.',
      category: 'Writing',
      durationMinutes: 25,
      sections: [
         LessonSection(
          title: 'Understanding Bar Charts',
          content: 'Bar charts show comparison between categories. Look for the highest and lowest values first.',
        ),
        LessonSection(
          title: 'Key Vocabulary',
          content: 'Use words like "increase", "decrease", "fluctuate", "remain steady".',
        ),
         LessonSection(
          title: 'Quiz: Bar Charts',
          quizId: 'q1', // Reusing q1 for demo
        ),
      ]
    ),
    LessonMock(
      id: '3',
      title: 'Listening for Details',
      description: 'Techniques to catch specific information.',
      category: 'Listening',
      durationMinutes: 20,
    ),
     LessonMock(
      id: '4',
      title: 'Reading Skimming Techniques',
      description: 'Read faster and find answers quicker.',
      category: 'Reading',
      durationMinutes: 30,
    ),
  ];

  final List<QuizMock> quizzes = [
    QuizMock(
      id: 'q1',
      title: 'Speaking Basics Quiz',
      questions: [
        QuizQuestionMock(
          questionText: 'How many parts are there in the Speaking test?',
          options: ['1', '2', '3', '4'],
          correctOptionIndex: 2,
        ),
        QuizQuestionMock(
          questionText: 'How long does the Speaking test last?',
          options: ['4-5 minutes', '11-14 minutes', '30 minutes', '1 hour'],
          correctOptionIndex: 1,
        ),
      ],
    ),
  ];
}
