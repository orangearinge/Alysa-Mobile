import 'package:alysa_speak/models/test_model.dart';

class TestSessionModel {
  final int id;
  final double totalScore;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final List<TestAnswerModel> testAnswers;
  final List<PracticeResultDetail>? _detailsBackup;

  TestSessionModel({
    required this.id,
    required this.totalScore,
    required this.startedAt,
    this.finishedAt,
    required this.testAnswers,
    List<PracticeResultDetail>? detailsBackup,
  }) : _detailsBackup = detailsBackup;

  factory TestSessionModel.fromJson(Map<String, dynamic> json) {
    var rawFeedback = json['feedback'];
    List<PracticeResultDetail> detailsFromFeedback = [];

    // Check if feedback is a Map and has 'detailed_feedback'
    if (rawFeedback is Map && rawFeedback['detailed_feedback'] is List) {
      var detailed = rawFeedback['detailed_feedback'] as List;
      detailsFromFeedback = detailed.map((e) {
        return PracticeResultDetail(
          questionId: e['question_id']?.toString() ?? '',
          questionPrompt: e['question_text'] ?? '',
          userAnswer: e['user_answer'] ?? '',
          score: (e['score'] ?? 0).toDouble(),
          feedback: List<String>.from(e['feedback'] ?? []),
          suggestedCorrection: e['suggested_correction'] ?? '',
          evaluation: (e['evaluation'] is Map)
              ? (e['evaluation'] as Map).map(
                  (k, v) => MapEntry(k.toString(), v.toString()),
                )
              : {},
          proTips: List<String>.from(e['pro_tips'] ?? []),
          referenceAnswer: e['reference_answer'] ?? '',
        );
      }).toList();
    }

    return TestSessionModel(
      id: json['id'],
      totalScore: (json['total_score'] ?? 0).toDouble(),
      startedAt: DateTime.parse(json['started_at']),
      finishedAt: json['finished_at'] != null
          ? DateTime.parse(json['finished_at'])
          : null,
      testAnswers: (json['test_answers'] as List)
          .map((e) => TestAnswerModel.fromJson(e))
          .toList(),
      detailsBackup: detailsFromFeedback,
    );
  }

  // Convert to PracticeTestResult for reuse of TestReviewPage
  PracticeTestResult toPracticeTestResult() {
    // If we have detailed feedback from the session level, use it (handles all 10 questions)
    if (_detailsBackup != null && _detailsBackup.isNotEmpty) {
      return PracticeTestResult(
        overallScore: totalScore,
        results: _detailsBackup,
      );
    }

    // Fallback to individual test answers
    return PracticeTestResult(
      overallScore: totalScore,
      results: testAnswers.map((e) => e.toPracticeResultDetail()).toList(),
    );
  }
}

class TestAnswerModel {
  final int id;
  final String section;
  final String taskType;
  final double score;
  final List<String> feedback;
  final dynamic userInputs; // Can be list of objects or other structure

  TestAnswerModel({
    required this.id,
    required this.section,
    required this.taskType,
    required this.score,
    required this.feedback,
    required this.userInputs,
  });

  factory TestAnswerModel.fromJson(Map<String, dynamic> json) {
    // Extract feedback list usually in 'feedback' key inside the 'feedback' object or directly
    List<String> feedbackList = [];
    if (json['feedback'] != null && json['feedback']['feedback'] is List) {
      feedbackList = List<String>.from(json['feedback']['feedback']);
    } else if (json['feedback'] is List) {
      // Fallback if direct list
      feedbackList = List<String>.from(json['feedback']);
    }

    return TestAnswerModel(
      id: json['id'],
      section: json['section'],
      taskType: json['task_type'],
      score: (json['score'] ?? 0).toDouble(),
      feedback: feedbackList,
      userInputs: json['user_inputs'],
    );
  }

  PracticeResultDetail toPracticeResultDetail() {
    String answerText = "";
    String qId = "";

    // Parse userInputs to get a displayable answer string
    // Structure: List of {q_id: ..., answer: ...}
    if (userInputs is List && userInputs.isNotEmpty) {
      var firstInput = userInputs[0];
      if (firstInput is Map) {
        answerText = firstInput['answer'] ?? "";
        qId = firstInput['q_id']?.toString() ?? "";
      }
    }

    return PracticeResultDetail(
      questionId: qId,
      questionPrompt:
          "", // History might not have prompt stored in legacy records
      userAnswer: answerText,
      score: score,
      feedback: feedback,
      suggestedCorrection: "", // Placeholder for history
      evaluation: {}, // Placeholder for history
      proTips: [], // Placeholder for history
      referenceAnswer: "", // Placeholder for history
    );
  }
}
