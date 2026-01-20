import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alysa_speak/theme/app_color.dart';
import 'package:alysa_speak/models/test_model.dart';

class TestReviewPage extends StatefulWidget {
  final PracticeTestResult result;

  const TestReviewPage({super.key, required this.result});

  @override
  State<TestReviewPage> createState() => _TestReviewPageState();
}

class _TestReviewPageState extends State<TestReviewPage> {
  int currentQuestionIndex = 0;

  PracticeResultDetail get currentResult =>
      widget.result.results[currentQuestionIndex];
  bool get isLastQuestion =>
      currentQuestionIndex >= widget.result.results.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.black),
          onPressed: () {
            // Navigator.pop(context); // Do not use pop to prevent going back to test
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
          },
        ),
        title: const Text(
          "Review Results",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Score Summary (Circular Gauge) - Now always visible
              Center(
                child: Column(
                  children: [
                    Text(
                      "Overall Score",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildScoreGauge(
                      widget.result.overallScore,
                      100.0, // Overall score is now out of 100
                      size: 100,
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${currentQuestionIndex + 1}/${widget.result.results.length}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  _buildScoreGauge(
                    currentResult.score,
                    9.0, // Per question is band 0-9
                    size: 45,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Progress bar
              LinearProgressIndicator(
                value:
                    (currentQuestionIndex + 1) / widget.result.results.length,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
                minHeight: 6,
              ),
              const SizedBox(height: 24),

              // Question Prompt
              if (currentResult.questionPrompt.isNotEmpty) ...[
                _buildSectionTitle("Question:", null),
                const SizedBox(height: 8),
                _buildTextContainer(
                  currentResult.questionPrompt,
                  Colors.blue.shade50,
                  Colors.blue.shade100,
                  Colors.blue.shade900,
                  isBold: true,
                ),
                const SizedBox(height: 24),
              ],

              // Your Answer
              _buildSectionTitle("Your Answer:", null),
              const SizedBox(height: 8),
              _buildTextContainer(
                currentResult.userAnswer.isEmpty
                    ? "(No answer provided)"
                    : currentResult.userAnswer,
                Colors.grey.shade50,
                Colors.grey.shade300,
                Colors.black87,
              ),

              const SizedBox(height: 24),

              // Suggested Correction
              if (currentResult.suggestedCorrection.isNotEmpty) ...[
                _buildSectionTitle("Suggested Correction: ✨", null),
                const SizedBox(height: 8),
                _buildTextContainer(
                  currentResult.suggestedCorrection,
                  Colors.amber.shade50,
                  Colors.amber.shade200,
                  Colors.brown.shade900,
                  isItalic: true,
                ),
                const SizedBox(height: 24),
              ],

              // Detailed Evaluation
              _buildSectionTitle("Detailed Evaluation:", null),
              const SizedBox(height: 12),
              _buildEvaluationGrid(currentResult.evaluation),

              const SizedBox(height: 24),

              // Pro Tips
              if (currentResult.proTips.isNotEmpty) ...[
                _buildSectionTitle("Pro Tips to Level Up: 💡", null),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: currentResult.proTips
                        .map(
                          (tip) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "• ",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    tip,
                                    style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Band 8+ Reference
              if (currentResult.referenceAnswer.isNotEmpty) ...[
                _buildSectionTitle("Band 8+ Reference: 🏆", null),
                const SizedBox(height: 8),
                _buildTextContainer(
                  currentResult.referenceAnswer,
                  Colors.green.shade50,
                  Colors.green.shade200,
                  Colors.green.shade900,
                ),
                const SizedBox(height: 24),
              ],

              const SizedBox(height: 32),
              // Tombol manual untuk next/finish
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (isLastQuestion) {
                      // Kembali ke home
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    } else {
                      // Lanjut ke soal berikutnya
                      setState(() {
                        currentQuestionIndex++;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isLastQuestion ? 'FINISH & HOME' : 'NEXT RESULT',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreGauge(double score, double maxScore, {double size = 60}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: score / maxScore,
            strokeWidth: size * 0.1,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getScoreColor(score, maxScore),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              score.toStringAsFixed(1),
              style: TextStyle(
                fontSize: size * 0.25,
                fontWeight: FontWeight.bold,
                color: _getScoreColor(score, maxScore),
              ),
            ),
            Text(
              "/${maxScore.toInt()}",
              style: TextStyle(
                fontSize: size * 0.15,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
                height: 0.8,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData? icon) {
    return Row(
      children: [
        if (icon != null) ...[
          FaIcon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTextContainer(
    String text,
    Color bgColor,
    Color borderColor,
    Color textColor, {
    bool isItalic = false,
    bool isBold = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: textColor,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildEvaluationGrid(Map<String, String> evaluation) {
    final items = [
      {'title': '🎯 Relevance', 'key': 'relevance'},
      {'title': '🔗 Coherence', 'key': 'coherence'},
      {'title': '📚 Vocab', 'key': 'vocabulary'},
      {'title': '✍️ Grammar', 'key': 'grammar'},
    ];

    return Column(
      children: items.map((item) {
        final content = evaluation[item['key']];
        if (content == null || content.isEmpty || content == 'N/A') {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title']!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                content,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade800,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getScoreColor(double score, double maxScore) {
    double percentage = score / maxScore;
    if (percentage >= 0.7) return Colors.green;
    if (percentage >= 0.5) return Colors.orange;
    return Colors.red;
  }
}
