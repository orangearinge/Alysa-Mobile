import 'package:flutter/material.dart';
import 'package:alysa_speak/theme/app_color.dart';
import 'hasil_test_page.dart';

enum QuestionType { writing, speaking }

class TestQuestion {
  final String text;
  String userAnswer;
  final String correctAnswer;
  final String feedback;
  final QuestionType type;

  TestQuestion({
    required this.text,
    this.userAnswer = '',
    required this.correctAnswer,
    required this.feedback,
    required this.type,
  });

  bool get isCorrect => userAnswer.toLowerCase().trim() == correctAnswer.toLowerCase().trim();
}

class TestMixedPage extends StatefulWidget {
  const TestMixedPage({super.key});

  @override
  State<TestMixedPage> createState() => _TestMixedPageState();
}

class _TestMixedPageState extends State<TestMixedPage> {
  final TextEditingController _answerController = TextEditingController();
  int currentQuestionIndex = 0;
  int timeRemaining = 30;
  bool isRecording = false;

  // Daftar soal test (campuran writing dan speaking)
  final List<TestQuestion> questions = [
    TestQuestion(
      text: "I have an apple",
      correctAnswer: "I have an apple",
      feedback: "Good! Simple present tense is correct.",
      type: QuestionType.writing,
    ),
    TestQuestion(
      text: "She is reading a book",
      correctAnswer: "She is reading a book",
      feedback: "Perfect! Present continuous tense.",
      type: QuestionType.speaking,
    ),
    TestQuestion(
      text: "They go to school",
      correctAnswer: "They go to school",
      feedback: "Excellent! Simple present for habits.",
      type: QuestionType.writing,
    ),
    TestQuestion(
      text: "We are playing football",
      correctAnswer: "We are playing football",
      feedback: "Great! Present continuous for ongoing actions.",
      type: QuestionType.speaking,
    ),
    TestQuestion(
      text: "He likes ice cream",
      correctAnswer: "He likes ice cream",
      feedback: "Correct! Third person singular verb.",
      type: QuestionType.writing,
    ),
    TestQuestion(
      text: "The cat is sleeping",
      correctAnswer: "The cat is sleeping",
      feedback: "Perfect! Present continuous tense.",
      type: QuestionType.speaking,
    ),
    TestQuestion(
      text: "I eat breakfast every day",
      correctAnswer: "I eat breakfast every day",
      feedback: "Good! Simple present for daily routines.",
      type: QuestionType.writing,
    ),
    TestQuestion(
      text: "She has a beautiful dress",
      correctAnswer: "She has a beautiful dress",
      feedback: "Excellent! Simple present with 'have'.",
      type: QuestionType.speaking,
    ),
    TestQuestion(
      text: "We are studying English",
      correctAnswer: "We are studying English",
      feedback: "Great! Present continuous tense.",
      type: QuestionType.writing,
    ),
    TestQuestion(
      text: "The birds fly in the sky",
      correctAnswer: "The birds fly in the sky",
      feedback: "Perfect! Simple present tense.",
      type: QuestionType.speaking,
    ),
  ];

  TestQuestion get currentQuestion => questions[currentQuestionIndex];
  bool get isLastQuestion => currentQuestionIndex >= questions.length - 1;

  void _submitAnswer() {
    // Simpan jawaban user
    setState(() {
      if (currentQuestion.type == QuestionType.writing) {
        currentQuestion.userAnswer = _answerController.text;
        _answerController.clear();
      } else {
        // Untuk speaking, simpan jawaban dummy atau dari speech recognition
        currentQuestion.userAnswer = "Spoken answer"; // TODO: Ganti dengan hasil speech recognition
      }
    });

    if (isLastQuestion) {
      // Jika soal terakhir, hitung hasil dan navigasi ke hasil test
      int correctCount = questions.where((q) => q.isCorrect).length;
      int wrongCount = questions.length - correctCount;
      int points = correctCount;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HasilTestPage(
            correctAnswers: correctCount,
            wrongAnswers: wrongCount,
            totalPoints: points,
            questions: questions,
          ),
        ),
      );
    } else {
      // Lanjut ke soal berikutnya
      setState(() {
        currentQuestionIndex++;
        timeRemaining = 30;
        isRecording = false;
      });
    }
  }

  void _toggleRecording() {
    setState(() {
      isRecording = !isRecording;
    });
    
    // TODO: Implement speech recognition logic here
    if (isRecording) {
      print("Started recording...");
      // Start recording
    } else {
      print("Stopped recording...");
      // Stop recording and submit
      Future.delayed(Duration(milliseconds: 500), () {
        _submitAnswer();
      });
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "TEST",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "$timeRemaining Seconds",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentQuestion.type == QuestionType.writing
                        ? "Writing"
                        : "Speaking",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${currentQuestionIndex + 1}/${questions.length}",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress Bar
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / questions.length,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 6,
              ),
              const SizedBox(height: 24),

              // Question Text
              Text(
                currentQuestion.text,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              // Dynamic Input based on question type
              if (currentQuestion.type == QuestionType.writing) ...[
                // Writing Input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _answerController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "Type your Answer ...",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Submit Button for Writing
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submitAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "NEXT",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Speaking Input (Microphone Button)
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _toggleRecording,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: isRecording
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    )
                                  ]
                                : [],
                          ),
                          child: Icon(
                            Icons.mic,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isRecording ? "Recording..." : "Tap to Speak",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}