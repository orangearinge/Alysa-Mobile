import 'package:alysa_speak/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alysa_speak/services/auth_service.dart';
import 'package:alysa_speak/services/user_service.dart';
import 'package:alysa_speak/models/user_model.dart';
import 'package:alysa_speak/pages/edit_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alysa_speak/pages/test_history_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
  Future<UserProfile?>? _userProfileFuture;
  UserProfile? _currentUserProfile;
  String _selectedModel = 'gemini'; // Default

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadModelPreference();
  }

  Future<void> _loadModelPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String? savedModel = prefs.getString('selected_ai_model');
      _selectedModel = savedModel ?? 'gemini';
    });
  }

  Future<void> _saveModelPreference(String model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_ai_model', model);
    setState(() {
      _selectedModel = model;
    });
  }

  void _loadUserProfile() {
    setState(() {
      _userProfileFuture = _userService.getUserProfile().then((profile) {
        _currentUserProfile = profile;
        return profile;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final User? user = authService.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with gradient background
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Avatar
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : null,
                        child: user?.photoURL == null
                            ? Icon(
                                Icons.person,
                                color: AppColors.primary,
                                size: 60,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Name
                    Text(
                      user?.displayName ?? "User",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Email
                    Text(
                      user?.email ?? "No Email",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),

              // Stats Cards
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Row
                    FutureBuilder<UserProfile?>(
                      future: _userProfileFuture,
                      builder: (context, snapshot) {
                        final userProfile = snapshot.data;
                        final targetScore =
                            userProfile?.targetScore ?? 6.5; // Default if nil
                        final dailyTime =
                            userProfile?.dailyStudyTimeMinutes ?? 30; // Default

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.emoji_events,
                                title: "Target Score",
                                value: "$targetScore",
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.timer,
                                title: "Daily Goal",
                                value: "${dailyTime}m",
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Account Section
                    Text(
                      "Account",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // AI Model Selection
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "AI Scoring Model",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          _selectedModel == 'alysa'
                              ? "Alysa (Offline / Custom Model)"
                              : "Gemini (Online / Standard)",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.psychology,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _selectedModel.toUpperCase(),
                            style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        onTap: () {
                          _showModelSelectionDialog(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildMenuItem(
                      context: context,
                      icon: Icons.person_outline,
                      title: "Edit Profile",
                      subtitle: "Update your target score and study plan",
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              userProfile: _currentUserProfile,
                            ),
                          ),
                        );

                        if (result == true) {
                          _loadUserProfile();
                        }
                      },
                    ),

                    _buildMenuItem(
                      context: context,
                      icon: Icons.history,
                      title: "History Simulation Test",
                      subtitle: "View your past results and feedback",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TestHistoryPage(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Text(
                                "Logout",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                "Are you sure you want to logout?",
                                style: GoogleFonts.poppins(),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await authService.signOut();
                                    if (context.mounted) {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/',
                                        (route) => false,
                                      );
                                    }
                                  },
                                  child: Text(
                                    "Logout",
                                    style: GoogleFonts.poppins(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: Text(
                          "Logout",
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // App Version
                    Center(
                      child: Text(
                        "Version 1.0.0",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showModelSelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select AI Model",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _buildModelOption(
                title: "Gemini AI",
                subtitle: "Online model by Google. High accuracy.",
                value: "gemini",
                isSelected: _selectedModel == 'gemini',
                onTap: () {
                  _saveModelPreference('gemini');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),

              _buildModelOption(
                title: "Alysa Model",
                subtitle: "Custom model. Works with specific datasets.",
                value: "alysa",
                isSelected: _selectedModel == 'alysa',
                onTap: () {
                  _saveModelPreference('alysa');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModelOption({
    required String title,
    required String subtitle,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.psychology,
                color: isSelected ? Colors.white : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
