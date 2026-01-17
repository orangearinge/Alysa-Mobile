import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alysa_speak/theme/app_color.dart';
import 'package:alysa_speak/models/learning_model.dart';
import 'package:alysa_speak/services/learning_service.dart';

class QuizPage extends StatefulWidget {
  final String quizId;
  const QuizPage({super.key, required this.quizId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<Quiz?> _quizFuture;
  final LearningService _learningService = LearningService();

  Quiz? _quiz;
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _quizFuture = _learningService.getQuiz(widget.quizId);
  }

  void _checkAnswer(int index) {
    if (_isAnswered || _quiz == null) return;
    setState(() {
      _selectedOptionIndex = index;
      _isAnswered = true;
    });
  }

  void _nextQuestion() {
    if (_quiz == null) return;

    if (_currentQuestionIndex < _quiz!.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
        _isAnswered = false;
      });
    } else {
      // Quiz Finished
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Quiz Completed!"),
          content: const Text("Great job keeping up with your study plan."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context); // Go back to learning page
              },
              child: const Text("Finish"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quiz?>(
      future: _quizFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: const BackButton(color: Colors.black),
            ),
            body: Center(
              child: Builder(
                builder: (context) {
                  debugPrint("Quiz loading error: ${snapshot.error}");
                  return const Text(
                    "Gagal memuat kuis. Silakan coba lagi nanti.",
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          );
        }

        _quiz = snapshot.data!;
        final question = _quiz!.questions[_currentQuestionIndex];

        return Scaffold(
          appBar: AppBar(
            title: Text(
              _quiz!.title,
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const BackButton(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Question ${_currentQuestionIndex + 1}/${_quiz!.questions.length}",
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  question.questionText,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                ...List.generate(question.options.length, (index) {
                  final isSelected = _selectedOptionIndex == index;
                  final isCorrect = question.correctOptionIndex == index;

                  Color borderColor = Colors.grey.shade300;
                  Color bgColor = Colors.white;

                  if (_isAnswered) {
                    if (isSelected && isCorrect) {
                      borderColor = Colors.green;
                      bgColor = Colors.green.shade50;
                    } else if (isSelected && !isCorrect) {
                      borderColor = Colors.red;
                      bgColor = Colors.red.shade50;
                    } else if (isCorrect) {
                      borderColor = Colors.green;
                      bgColor = Colors.green.shade50;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => _checkAnswer(index),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgColor,
                          border: Border.all(color: borderColor, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                question.options[index],
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            if (_isAnswered && isCorrect)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            if (_isAnswered && isSelected && !isCorrect)
                              const Icon(Icons.cancel, color: Colors.red),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const Spacer(),

                if (_isAnswered)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentQuestionIndex < _quiz!.questions.length - 1
                            ? "Next Question"
                            : "Finish Quiz",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
