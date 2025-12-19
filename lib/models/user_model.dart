class UserProfile {
  final String? username;
  final String? email;
  final double targetScore;
  final int dailyStudyTimeMinutes;
  final DateTime? testDate;

  UserProfile({
    this.username,
    this.email,
    required this.targetScore,
    required this.dailyStudyTimeMinutes,
    this.testDate,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'],
      email: json['email'],
      targetScore: (json['target_score'] ?? 6.5).toDouble(),
      dailyStudyTimeMinutes: json['daily_study_time_minutes'] ?? 30,
      testDate: json['test_date'] != null
          ? DateTime.parse(json['test_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'target_score': targetScore,
      'daily_study_time_minutes': dailyStudyTimeMinutes,
      'test_date': testDate?.toIso8601String(),
    };
  }
}
