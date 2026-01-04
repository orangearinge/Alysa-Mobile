class PracticeQuestion {
  final int id;
  final String questionId;
  final String section; // 'Speaking' or 'Writing'
  final String prompt;
  final String taskType;
  
  String? userAnswer; // To store user answer locally
  
  PracticeQuestion({
    required this.id,
    required this.questionId,
    required this.section,
    required this.prompt,
    required this.taskType,
  });

  factory PracticeQuestion.fromJson(Map<String, dynamic> json) {
    return PracticeQuestion(
      id: json['id'],
      questionId: json['question_id'].toString(), // Ensure string if ID is mixed
      section: json['section'],
      prompt: json['prompt'],
      taskType: json['task_type'],
    );
  }
}

class PracticeResultDetail {
  final String questionId;
  final String userAnswer;
  final double score;
  final List<String> feedback;
  final String? overallComment;

  PracticeResultDetail({
    required this.questionId,
    required this.userAnswer,
    required this.score,
    required this.feedback,
    this.overallComment,
  });

  factory PracticeResultDetail.fromJson(Map<String, dynamic> json) {
    return PracticeResultDetail(
      questionId: json['question_id'].toString(),
      userAnswer: json['user_answer'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      feedback: List<String>.from(json['feedback'] ?? []),
    );
  }
}

class PracticeTestResult {
  final double overallScore;
  final List<PracticeResultDetail> results;

  PracticeTestResult({
    required this.overallScore,
    required this.results,
  });

  factory PracticeTestResult.fromJson(Map<String, dynamic> json) {
    var rawResults = json['results'] as List;
    List<PracticeResultDetail> details = rawResults
        .map((e) => PracticeResultDetail.fromJson(e))
        .toList();

    return PracticeTestResult(
      overallScore: (json['overall_score'] ?? 0).toDouble(),
      results: details,
    );
  }
}
