import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alysa_speak/theme/app_color.dart';
import 'package:alysa_speak/data/mock_data.dart';
import 'package:alysa_speak/pages/quiz_page.dart';
import 'package:alysa_speak/pages/lesson_detail_page.dart';

class LearningPage extends StatelessWidget {
  final String? selectedCategory;

  const LearningPage({super.key, this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    final allLessons = MockData().lessons;
    final lessons = selectedCategory != null
        ? allLessons
              .where(
                (lesson) =>
                    lesson.category.toLowerCase() ==
                    selectedCategory!.toLowerCase(),
              )
              .toList()
        : allLessons;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedCategory != null
              ? "$selectedCategory Materials"
              : "All Learning Materials",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[50],
      body: lessons.isEmpty
          ? Center(
              child: Text(
                "No materials found for this category",
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            )
          : ListView.builder(
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
                          builder: (_) => LessonDetailPage(lesson: lesson),
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
                                lesson.category[0],
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
            ),
    );
  }
}
