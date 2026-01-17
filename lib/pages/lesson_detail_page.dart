import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alysa_speak/models/learning_model.dart';
import 'package:alysa_speak/theme/app_color.dart';
import 'package:alysa_speak/pages/quiz_page.dart';
import 'package:alysa_speak/services/learning_service.dart';

class LessonDetailPage extends StatefulWidget {
  final String lessonId;
  final String title;
  final int initialSectionIndex;

  const LessonDetailPage({
    super.key,
    required this.lessonId,
    required this.title,
    this.initialSectionIndex = 0,
  });

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  int _currentSectionIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LearningService _learningService = LearningService();
  late Future<Lesson?> _lessonFuture;

  @override
  void initState() {
    super.initState();
    _currentSectionIndex = widget.initialSectionIndex;
    _lessonFuture = _learningService.getLessonDetail(widget.lessonId);
  }

  void _navigateToSection(int index) {
    setState(() {
      _currentSectionIndex = index;
    });
    Navigator.pop(context); // Close drawer
  }

  void _nextSection(int totalSections) {
    if (_currentSectionIndex < totalSections - 1) {
      setState(() {
        _currentSectionIndex++;
      });
    }
  }

  void _previousSection() {
    if (_currentSectionIndex > 0) {
      setState(() {
        _currentSectionIndex--;
      });
    }
  }

  void _showTableOfContents(Lesson lesson) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Table of Contents",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: lesson.sections.length,
                itemBuilder: (context, index) {
                  final section = lesson.sections[index];
                  final isCurrentSection = index == _currentSectionIndex;
                  final isSectionQuiz = section.quizId != null;

                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSectionQuiz
                            ? Colors.orange.shade50
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isSectionQuiz ? Icons.quiz : Icons.article,
                        color: isSectionQuiz ? Colors.orange : Colors.blue,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      section.title,
                      style: GoogleFonts.poppins(
                        fontWeight: isCurrentSection
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isCurrentSection
                            ? AppColors.primary
                            : Colors.black87,
                      ),
                    ),
                    selected: isCurrentSection,
                    selectedTileColor: AppColors.primary.withOpacity(0.1),
                    onTap: () {
                      setState(() {
                        _currentSectionIndex = index;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Lesson?>(
      future: _lessonFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.title,
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: const BackButton(color: Colors.black),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.title,
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: const BackButton(color: Colors.black),
            ),
            body: Center(
              child: Text(
                "Error loading lesson: ${snapshot.error ?? 'Not found'}",
              ),
            ),
          );
        }

        final lesson = snapshot.data!;

        if (lesson.sections.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                lesson.title,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                "No content available for this lesson.",
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
          );
        }

        // Ensure index index is valid
        if (_currentSectionIndex >= lesson.sections.length) {
          _currentSectionIndex = 0;
        }

        final currentSection = lesson.sections[_currentSectionIndex];
        final isQuiz = currentSection.quizId != null;
        final isLastSection =
            _currentSectionIndex == lesson.sections.length - 1;

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              lesson.title,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (_currentSectionIndex + 1) / lesson.sections.length,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section title
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isQuiz
                                  ? Colors.orange.shade50
                                  : Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              isQuiz ? Icons.quiz : Icons.article,
                              color: isQuiz ? Colors.orange : Colors.blue,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              currentSection.title,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Content
                      if (isQuiz) ...[
                        Text(
                          "Ready to test your knowledge?",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      QuizPage(quizId: currentSection.quizId!),
                                ),
                              );
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: Text(
                              "Start Quiz",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        Text(
                          currentSection.content,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[800],
                            height: 1.8,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Navigation buttons at the bottom
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Previous button
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _currentSectionIndex > 0
                              ? _previousSection
                              : null,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: _currentSectionIndex > 0
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: _currentSectionIndex > 0
                                    ? AppColors.primary
                                    : Colors.grey.shade400,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Previous",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: _currentSectionIndex > 0
                                      ? AppColors.primary
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Drawer button
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: OutlinedButton(
                        onPressed: () => _showTableOfContents(lesson),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Icon(Icons.list, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Next button
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!isLastSection) {
                              _nextSection(lesson.sections.length);
                            } else {
                              // Mark as completed on last section
                              final success = await _learningService
                                  .completeLesson(lesson.id);
                              if (mounted) {
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Lesson completed! 🎉"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pop(context, true);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Failed to update progress.",
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isLastSection ? "Finish" : "Next",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                isLastSection
                                    ? Icons.check
                                    : Icons.arrow_forward,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
