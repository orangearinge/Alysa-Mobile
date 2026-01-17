import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alysa_speak/theme/app_color.dart';
import 'package:alysa_speak/models/learning_model.dart';
import 'package:alysa_speak/pages/lesson_detail_page.dart';
import 'package:alysa_speak/services/learning_service.dart';

class LearningPage extends StatefulWidget {
  final String? selectedCategory;

  const LearningPage({super.key, this.selectedCategory});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  late Future<List<Lesson>> _lessonsFuture;
  final LearningService _learningService = LearningService();

  @override
  void initState() {
    super.initState();
    _refreshLessons();
  }

  void _refreshLessons() {
    _lessonsFuture = _learningService.getLessons(
      category: widget.selectedCategory,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectedCategory != null
              ? "${widget.selectedCategory} Materials"
              : "All Learning Materials",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _refreshLessons();
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: FutureBuilder<List<Lesson>>(
        future: _lessonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Builder(
                    builder: (context) {
                      debugPrint("Lessons loading error: ${snapshot.error}");
                      return const Text(
                        "Gagal memuat materi pembelajaran. Silakan coba lagi nanti.",
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => setState(_refreshLessons),
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          }

          final lessons = snapshot.data ?? [];

          if (lessons.isEmpty) {
            return Center(
              child: Text(
                "No materials found for this category",
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LessonDetailPage(
                          lessonId: lesson.id,
                          title: lesson.title,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              lesson.category.isNotEmpty
                                  ? lesson.category[0]
                                  : '?',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lesson.category.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lesson.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${lesson.durationMinutes} mins • ${lesson.description}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
