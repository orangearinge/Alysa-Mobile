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
      questionId: json['question_id']
          .toString(), // Ensure string if ID is mixed
      section: json['section'],
      prompt: json['prompt'],
      taskType: json['task_type'],
    );
  }
}

class PracticeResultDetail {
  final String questionId;
  final String questionPrompt;
  final String userAnswer;
  final double score;
  final List<String> feedback; // Legacy field for compatibility
  final String suggestedCorrection;
  final Map<String, String> evaluation;
  final List<String> proTips;
  final String referenceAnswer;
  final String? overallComment;

  PracticeResultDetail({
    required this.questionId,
    required this.questionPrompt,
    required this.userAnswer,
    required this.score,
    required this.feedback,
    required this.suggestedCorrection,
    required this.evaluation,
    required this.proTips,
    required this.referenceAnswer,
    this.overallComment,
  });

  factory PracticeResultDetail.fromJson(Map<String, dynamic> json) {
    // Extract evaluation map
    Map<String, String> eval = {};
    if (json['evaluation'] is Map) {
      (json['evaluation'] as Map).forEach((key, value) {
        eval[key.toString()] = value.toString();
      });
    }

    return PracticeResultDetail(
      questionId: json['question_id'].toString(),
      questionPrompt: json['question_text'] ?? '',
      userAnswer: json['user_answer'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      feedback: List<String>.from(json['feedback'] ?? []),
      suggestedCorrection: json['suggested_correction'] ?? '',
      evaluation: eval,
      proTips: List<String>.from(json['pro_tips'] ?? []),
      referenceAnswer: json['reference_answer'] ?? '',
    );
  }
}

class PracticeTestResult {
  final double overallScore;
  final List<PracticeResultDetail> results;

  PracticeTestResult({required this.overallScore, required this.results});

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
