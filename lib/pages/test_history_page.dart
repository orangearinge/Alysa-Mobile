import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alysa_speak/models/test_history_model.dart';
import 'package:alysa_speak/services/user_service.dart';
import 'package:alysa_speak/pages/test_review_page.dart';
import 'package:intl/intl.dart';

class TestHistoryPage extends StatefulWidget {
  const TestHistoryPage({super.key});

  @override
  State<TestHistoryPage> createState() => _TestHistoryPageState();
}

class _TestHistoryPageState extends State<TestHistoryPage> {
  final UserService _userService = UserService();
  Future<List<TestSessionModel>>? _testHistoryFuture;

  @override
  void initState() {
    super.initState();
    _loadTestHistory();
  }

  void _loadTestHistory() {
    setState(() {
      _testHistoryFuture = _userService.getTestHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Simulation Test History",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<TestSessionModel>>(
        future: _testHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading history",
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            );
          }

          final sessions = snapshot.data ?? [];
          if (sessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "No test history found",
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              return _buildTestHistoryItem(context, sessions[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildTestHistoryItem(BuildContext context, TestSessionModel session) {
    // Ensure we use the latest source of truth for time if needed,
    // but toLocal() is generally the standard for displaying UTC as Local.
    final dateStr = DateFormat(
      'MMM dd, yyyy • HH:mm',
    ).format(session.startedAt.toLocal());
    final score = session.totalScore;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TestReviewPage(result: session.toPracticeTestResult()),
            ),
          );
        },
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getScoreColorHistory(score).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.history_edu,
            color: _getScoreColorHistory(score),
            size: 28,
          ),
        ),
        title: Text(
          "Practice Test",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            dateStr,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _getScoreColorHistory(score).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "${score.toStringAsFixed(1)}/10.0",
            style: GoogleFonts.poppins(
              color: _getScoreColorHistory(score),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Color _getScoreColorHistory(double score) {
    if (score >= 7.5) return Colors.green;
    if (score >= 6.0) return Colors.orange;
    return Colors.red;
  }
}
