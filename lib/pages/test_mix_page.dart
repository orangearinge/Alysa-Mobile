import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alysa_speak/models/test_model.dart';
import 'package:alysa_speak/services/test_service.dart';
import 'package:alysa_speak/theme/app_color.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:alysa_speak/widgets/error_dialog.dart';
import 'hasil_test_page.dart';
import 'test_review_page.dart';

class TestMixedPage extends StatefulWidget {
  const TestMixedPage({super.key});

  @override
  State<TestMixedPage> createState() => _TestMixedPageState();
}

class _TestMixedPageState extends State<TestMixedPage> {
  final TestService _testService = TestService();
  final stt.SpeechToText _speech = stt.SpeechToText();

  final TextEditingController _answerController = TextEditingController();

  List<PracticeQuestion> questions = [];
  int currentQuestionIndex = 0;
  int sessionId = 0;

  bool isLoading = true;
  bool isSubmitting = false;

  // Timer related
  Timer? _timer;
  int timeRemaining = 180; // 3 minutes per question

  // Recording related
  bool isRecording = false;
  bool isSpeechAvailable = false;
  String spokenText = "";

  PracticeQuestion get currentQuestion => questions[currentQuestionIndex];
  bool get isLastQuestion => currentQuestionIndex >= questions.length - 1;

  @override
  void initState() {
    super.initState();
    _startTest();
    _initSpeech();
  }

  void _initSpeech() async {
    isSpeechAvailable = await _speech.initialize(
      onError: (e) => print('Speech error: $e'),
      onStatus: (s) => print('Speech status: $s'),
    );
    if (mounted) setState(() {});
  }

  Future<void> _startTest() async {
    try {
      final result = await _testService.startPracticeTest();
      setState(() {
        sessionId = result['session_id'];
        questions = result['questions'];
        isLoading = false;
      });
      _startTimer();
    } catch (e) {
      debugPrint("Start test error: $e");
      if (mounted) {
        setState(() => isLoading = false);
        ErrorDialog.show(
          context,
          message: 'Gagal memuat tes. Silakan coba lagi nanti.',
        );
        Navigator.pop(context);
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => timeRemaining = 180);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining > 0) {
        setState(() => timeRemaining--);
      } else {
        // Time's up for this question, auto-submit/next
        _submitCurrentAnswer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _answerController.dispose();
    _speech.stop();
    super.dispose();
  }

  void _submitCurrentAnswer() {
    _stopTimer();

    // Save current answer
    if (currentQuestion.section.toLowerCase() == 'writing') {
      currentQuestion.userAnswer = _answerController.text.trim();
      _answerController.clear();
    } else {
      // For speaking, spokenText is populated by speech listener
      currentQuestion.userAnswer = spokenText.trim();
      // Reset spoken text for next q
      spokenText = "";
      if (isRecording) {
        _speech.stop();
        setState(() => isRecording = false);
      }
    }

    if (isLastQuestion) {
      _finishTest();
    } else {
      setState(() {
        currentQuestionIndex++;
      });
      _startTimer();
    }
  }

  Future<void> _finishTest() async {
    setState(() => isSubmitting = true);
    try {
      // Get selected model
      final prefs = await SharedPreferences.getInstance();
      String modelType = prefs.getString('selected_ai_model') ?? 'gemini';

      final result = await _testService.submitPracticeTest(
        sessionId,
        questions,
        modelType: modelType,
      );

      if (mounted) {
        // Calculate simple stats for the summary screen
        int correctCount = result.results.where((r) => r.score >= 3.0).length;
        int wrongCount = result.results.length - correctCount;
        int totalPoints = (result.overallScore * 10).round();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HasilTestPage(
              result: result,
              correctAnswers: correctCount,
              wrongAnswers: wrongCount,
              totalPoints: totalPoints,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Finish test error: $e");
      if (mounted) {
        ErrorDialog.show(
          context,
          message: 'Gagal mengirim jawaban. Silakan coba lagi.',
        );
      }
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  void _toggleRecording() async {
    if (!isSpeechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition not available')),
      );
      return;
    }

    if (isRecording) {
      _speech.stop();
      setState(() => isRecording = false);
    } else {
      setState(() {
        isRecording = true;
        spokenText = ""; // clear previous
      });
      _speech.listen(
        onResult: (result) {
          setState(() {
            spokenText = result.recognizedWords;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isSubmitting) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Evaluating answers with AI..."),
            ],
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: Text("No questions loaded.")));
    }

    bool isWriting = currentQuestion.section.toLowerCase() == 'writing';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              "PRACTICE TEST",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: timeRemaining < 10 ? Colors.red : AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "$timeRemaining Seconds",
                style: const TextStyle(
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
                    isWriting ? "Writing" : "Speaking",
                    style: const TextStyle(
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
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
                minHeight: 6,
              ),
              const SizedBox(height: 24),

              // Question Text
              Text(
                currentQuestion.prompt,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              // Dynamic Input based on question type
              if (isWriting) ...[
                // Writing Input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _answerController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Type your Answer ...",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Speaking Input (Microphone Button and Live Text)
                SizedBox(
                  width: double
                      .infinity, // Memastikan area mengambil lebar penuh layar
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (spokenText.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 20,
                          ), // Tambah margin agar tidak nempel ke mic
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            spokenText,
                            textAlign:
                                TextAlign.center, // Text juga dibuat tengah
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),

                      GestureDetector(
                        onTap: _toggleRecording,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isRecording ? Colors.red : AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (isRecording
                                            ? Colors.red
                                            : AppColors.primary)
                                        .withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            isRecording ? Icons.stop : Icons.mic,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isRecording ? "Listening..." : "Tap to Speak",
                        style: TextStyle(
                          color: isRecording
                              ? Colors.red
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Next Button (Always visible to force stop/submit)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitCurrentAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isLastQuestion ? "FINISH TEST" : "NEXT QUESTION",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
