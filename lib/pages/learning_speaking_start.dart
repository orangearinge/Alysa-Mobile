import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alysa_speak/theme/app_color.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'learning_completion_page.dart';

class Question {
  final String text;
  final String feedback;
  final bool isCorrect;

  Question({
    required this.text,
    required this.feedback,
    required this.isCorrect,
  });
}

class LearningSpeakingStart extends StatefulWidget {
  final int level;

  const LearningSpeakingStart({super.key, required this.level});

  @override
  State<LearningSpeakingStart> createState() => _LearningSpeakingStart();
}

class _LearningSpeakingStart extends State<LearningSpeakingStart> {
  int currentQuestionIndex = 0;

  // Speech to Text
  late stt.SpeechToText _speech;
  bool _isRecording = false;
  String spokenText = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  // START & STOP RECORDING
  void _toggleRecording() async {
    if (!_isRecording) {
      bool available = await _speech.initialize();

      if (available) {
        setState(() {
          _isRecording = true;
        });

        _speech.listen(
          localeId: "en_US",
          onResult: (result) {
            setState(() {
              spokenText = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() {
        _isRecording = false;
      });

      _speech.stop();

      print("HASIL SUARA: $spokenText");

      Future.delayed(Duration(milliseconds: 400), () {
        _showResultPopup(context);
      });
    }
  }

  // Dummy questions data for all levels
  final Map<int, List<Question>> questionsData = {
    1: [
      Question(
        text: "I have an apple",
        feedback: "Good! Simple present tense is correct.",
        isCorrect: true,
      ),
      Question(
        text: "She is reading a book",
        feedback: "Perfect! Present continuous tense.",
        isCorrect: true,
      ),
      Question(
        text: "They go to school",
        feedback: "Excellent! Simple present for habits.",
        isCorrect: true,
      ),
      Question(
        text: "We are playing football",
        feedback: "Great! Present continuous for ongoing actions.",
        isCorrect: true,
      ),
      Question(
        text: "He likes ice cream",
        feedback: "Correct! Third person singular verb.",
        isCorrect: true,
      ),
      Question(
        text: "The cat is sleeping",
        feedback: "Perfect! Present continuous tense.",
        isCorrect: true,
      ),
      Question(
        text: "I eat breakfast every day",
        feedback: "Good! Simple present for daily routines.",
        isCorrect: true,
      ),
      Question(
        text: "She has a beautiful dress",
        feedback: "Excellent! Simple present with 'have'.",
        isCorrect: true,
      ),
      Question(
        text: "We are studying English",
        feedback: "Great! Present continuous tense.",
        isCorrect: true,
      ),
      Question(
        text: "The birds fly in the sky",
        feedback: "Perfect! Simple present tense.",
        isCorrect: true,
      ),
    ],
    2: [
      Question(
        text: "I went to the market yesterday",
        feedback: "Good! Past tense is correct.",
        isCorrect: true,
      ),
      Question(
        text: "She was cooking dinner",
        feedback: "Perfect! Past continuous tense.",
        isCorrect: true,
      ),
      Question(
        text: "They played soccer last week",
        feedback: "Excellent! Simple past tense.",
        isCorrect: true,
      ),
      Question(
        text: "We were watching TV",
        feedback: "Great! Past continuous for ongoing past actions.",
        isCorrect: true,
      ),
      Question(
        text: "He finished his homework",
        feedback: "Correct! Simple past tense.",
        isCorrect: true,
      ),
      Question(
        text: "The dog was barking loudly",
        feedback: "Perfect! Past continuous tense.",
        isCorrect: true,
      ),
      Question(
        text: "I visited my grandmother",
        feedback: "Good! Simple past for completed actions.",
        isCorrect: true,
      ),
      Question(
        text: "She had a wonderful time",
        feedback: "Excellent! Past tense with 'had'.",
        isCorrect: true,
      ),
      Question(
        text: "We were learning new words",
        feedback: "Great! Past continuous tense.",
        isCorrect: true,
      ),
      Question(
        text: "The sun was shining brightly",
        feedback: "Perfect! Past continuous tense.",
        isCorrect: true,
      ),
    ],
    3: [
      Question(
        text: "I will go to Paris next year",
        feedback: "Good! Future tense with 'will'.",
        isCorrect: true,
      ),
      Question(
        text: "She is going to study medicine",
        feedback: "Perfect! Future with 'going to'.",
        isCorrect: true,
      ),
      Question(
        text: "They will have finished by tomorrow",
        feedback: "Excellent! Future perfect tense.",
        isCorrect: true,
      ),
      Question(
        text: "We are going to travel abroad",
        feedback: "Great! Future plans with 'going to'.",
        isCorrect: true,
      ),
      Question(
        text: "He will be working late tonight",
        feedback: "Correct! Future continuous tense.",
        isCorrect: true,
      ),
      Question(
        text: "The train will arrive at 3 PM",
        feedback: "Perfect! Simple future tense.",
        isCorrect: true,
      ),
      Question(
        text: "I am going to learn Spanish",
        feedback: "Good! Future intentions with 'going to'.",
        isCorrect: true,
      ),
      Question(
        text: "She will have been studying for 5 hours",
        feedback: "Excellent! Future perfect continuous.",
        isCorrect: true,
      ),
      Question(
        text: "We will meet at the cafe",
        feedback: "Great! Simple future tense.",
        isCorrect: true,
      ),
      Question(
        text: "The weather will be sunny tomorrow",
        feedback: "Perfect! Future prediction.",
        isCorrect: true,
      ),
    ],
  };

  List<Question> get currentLevelQuestions => questionsData[widget.level] ?? [];
  Question get currentQuestion => currentLevelQuestions[currentQuestionIndex];
  bool get isLastQuestion =>
      currentQuestionIndex >= currentLevelQuestions.length - 1;

  // BOTTOM SHEET RESULT
  void _showResultPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FaIcon(
                          currentQuestion.isCorrect
                              ? FontAwesomeIcons.circleCheck
                              : FontAwesomeIcons.circleXmark,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currentQuestion.isCorrect ? 'Benar! 🎉' : 'Kurang Tepat 🥺',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      currentQuestion.feedback,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textDark,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),

                // NEXT or FINISH
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (isLastQuestion) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LearningCompletionPage(
                                completedLevel: widget.level,
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            currentQuestionIndex++;
                            spokenText = "";
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isLastQuestion ? 'FINISH' : 'NEXT',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Text(
                    'LEARNING SPEAKING',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Level ${widget.level}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Question ${currentQuestionIndex + 1}/10',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),

            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / 10,
              backgroundColor: Colors.grey[300],
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),

            const SizedBox(height: 24),

            Text(
              currentQuestion.text,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),

            const Spacer(),

            // TAMPILKAN HASIL SUARA USER
            if (spokenText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Center(
                  child: Text(
                    "You said: $spokenText",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

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
                        boxShadow: _isRecording
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
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
                    _isRecording ? "Recording..." : "Tap to Speak",
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
        ),
      ),
    );
  }
}
