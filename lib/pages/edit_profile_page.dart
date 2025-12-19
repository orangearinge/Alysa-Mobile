import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:alysa_speak/theme/app_color.dart';
import 'package:alysa_speak/services/user_service.dart';
import 'package:alysa_speak/models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile? userProfile;
  const EditProfilePage({super.key, this.userProfile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UserService _userService = UserService();

  late double _targetScore;
  late int _dailyStudyTime;
  DateTime? _testDate;
  bool _isLoading = false;

  final List<double> _scoreOptions = [
    5.0,
    5.5,
    6.0,
    6.5,
    7.0,
    7.5,
    8.0,
    8.5,
    9.0,
  ];
  final List<int> _timeOptions = [15, 30, 45, 60, 90, 120];

  @override
  void initState() {
    super.initState();
    _targetScore = widget.userProfile?.targetScore ?? 6.5;
    _dailyStudyTime = widget.userProfile?.dailyStudyTimeMinutes ?? 30;
    _testDate = widget.userProfile?.testDate;
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    final success = await _userService.updateUserProfile(
      targetScore: _targetScore,
      dailyStudyTimeMinutes: _dailyStudyTime,
      testDate: _testDate ?? DateTime.now().add(const Duration(days: 30)),
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile. Please try again.'),
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _testDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null && picked != _testDate) {
      setState(() {
        _testDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Update your learning goals",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Target Score
                    Text(
                      "Target IELTS Score",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<double>(
                      value: _targetScore,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      items: _scoreOptions.map((score) {
                        return DropdownMenuItem(
                          value: score,
                          child: Text(score.toString()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _targetScore = val);
                      },
                    ),
                    const SizedBox(height: 24),

                    // Daily Study Time
                    Text(
                      "Daily Study Time (minutes)",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      value: _dailyStudyTime,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      items: _timeOptions.map((time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text("$time minutes"),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _dailyStudyTime = val);
                      },
                    ),
                    const SizedBox(height: 24),

                    // Test Date
                    Text(
                      "IELTS Test Date",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _testDate == null
                                  ? "Select Date"
                                  : DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(_testDate!),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: _testDate == null
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Save Changes",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
