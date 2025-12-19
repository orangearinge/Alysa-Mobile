import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:alysa_speak/theme/app_color.dart';
import 'package:alysa_speak/data/mock_data.dart';
import 'package:alysa_speak/pages/lesson_detail_page.dart';

class PlanningPage extends StatelessWidget {
  const PlanningPage({super.key});

  List<Map<String, dynamic>> _generateRoadmap() {
    final user = MockData().currentUser;
    final lessons = MockData().lessons;
    final testDate = user.testDate ?? DateTime.now().add(const Duration(days: 30));
    final daysLeft = testDate.difference(DateTime.now()).inDays;
    
    // Calculate lessons per week
    final weeksLeft = (daysLeft / 7).ceil();
    final lessonsPerWeek = (lessons.length / weeksLeft).ceil();
    
    List<Map<String, dynamic>> roadmap = [];
    DateTime currentDate = DateTime.now();
    
    for (int week = 0; week < weeksLeft; week++) {
      final weekStart = currentDate.add(Duration(days: week * 7));
      final weekEnd = weekStart.add(const Duration(days: 6));
      
      // Get lessons for this week
      final startIndex = week * lessonsPerWeek;
      final endIndex = (startIndex + lessonsPerWeek).clamp(0, lessons.length);
      
      if (startIndex < lessons.length) {
        final weekLessons = lessons.sublist(startIndex, endIndex);
        
        roadmap.add({
          'week': week + 1,
          'startDate': weekStart,
          'endDate': weekEnd,
          'lessons': weekLessons,
          'isCurrentWeek': week == 0,
        });
      }
    }
    
    return roadmap;
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData().currentUser;
    final testDate = user.testDate ?? DateTime.now().add(const Duration(days: 30));
    final daysLeft = testDate.difference(DateTime.now()).inDays;
    final roadmap = _generateRoadmap();

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Study Plan", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                   BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                   )
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Target Score",
                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        "${user.targetScore}",
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Text(
                          "$daysLeft Days left",
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Exam Date",
                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                         DateFormat('MMM dd').format(testDate),
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                       Text(
                         DateFormat('yyyy').format(testDate),
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Learning Roadmap Section
            Text(
              "Learning Roadmap",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Roadmap Timeline
            ...roadmap.asMap().entries.map((entry) {
              final index = entry.key;
              final weekData = entry.value;
              final isLast = index == roadmap.length - 1;

              return _buildWeekCard(
                context,
                weekData,
                isLast,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekCard(
    BuildContext context,
    Map<String, dynamic> weekData,
    bool isLast,
  ) {
    final week = weekData['week'] as int;
    final startDate = weekData['startDate'] as DateTime;
    final endDate = weekData['endDate'] as DateTime;
    final lessons = weekData['lessons'] as List<LessonMock>;
    final isCurrentWeek = weekData['isCurrentWeek'] as bool;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCurrentWeek ? AppColors.primary : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "$week",
                      style: GoogleFonts.poppins(
                        color: isCurrentWeek ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 60,
                    color: Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Week content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCurrentWeek 
                          ? AppColors.primary 
                          : Colors.grey.shade200,
                        width: isCurrentWeek ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Week $week",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrentWeek 
                                    ? AppColors.primary 
                                    : Colors.black87,
                                ),
                              ),
                            ),
                            if (isCurrentWeek)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Current",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${DateFormat('MMM dd').format(startDate)} - ${DateFormat('MMM dd').format(endDate)}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Lessons for this week
                        ...lessons.map((lesson) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LessonDetailPage(lesson: lesson),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(lesson.category).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _getCategoryIcon(lesson.category),
                                      color: _getCategoryColor(lesson.category),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lesson.title,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "${lesson.durationMinutes} mins • ${lesson.category}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.grey[400],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'speaking':
        return Colors.orange;
      case 'writing':
        return Colors.blue;
      case 'reading':
        return Colors.green;
      case 'listening':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'speaking':
        return Icons.mic;
      case 'writing':
        return Icons.edit;
      case 'reading':
        return Icons.book;
      case 'listening':
        return Icons.headphones;
      default:
        return Icons.school;
    }
  }
}
