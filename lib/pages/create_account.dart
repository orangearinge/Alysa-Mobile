import 'package:flutter/material.dart';
import 'package:alysa_speak/theme/app_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alysa_speak/services/auth_service.dart';
import 'package:alysa_speak/services/user_service.dart';
import 'package:alysa_speak/widgets/error_dialog.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  bool _isLoading = false;
  String? errorMessage;

  void validateAndSubmit() async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    setState(() => errorMessage = null);

    if (email.isEmpty || pass.isEmpty || confirmPass.isEmpty) {
      if (mounted) {
        ErrorDialog.show(context, message: "Please fill in all fields");
      }
      return;
    }

    if (pass != confirmPass) {
      if (mounted) {
        ErrorDialog.show(
          context,
          message: "Password and confirm password do not match",
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signUpWithEmailAndPassword(email, pass);
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/onboarding',
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint("Sign up error: $e");
      if (mounted) {
        ErrorDialog.show(
          context,
          message: "Gagal membuat akun. Silakan coba lagi nanti.",
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleGoogleSignUp() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithGoogle();

      // Check if user profile is complete
      final userProfile = await _userService.getUserProfile();

      if (mounted) {
        // If profile doesn't have target_score, test_date, or daily time, go to onboarding
        if (userProfile == null || userProfile.testDate == null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/onboarding',
            (route) => false,
          );
        } else {
          // Profile complete, go to home
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      }
    } catch (e) {
      debugPrint("Google Sign Up error: $e");
      if (mounted) {
        ErrorDialog.show(
          context,
          message: "Gagal mendaftar dengan Google. Silakan coba lagi nanti.",
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Judul
                Text(
                  "Create Account",
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),

                // Deskripsi
                Text(
                  'Create an account so you can explore all the\nexisting jobs',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),

                // Input Email
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: GoogleFonts.poppins(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Input Password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: GoogleFonts.poppins(color: Colors.black54),
                    hintStyle: const TextStyle(color: Colors.black45),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Input Confirm Password
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: GoogleFonts.poppins(color: Colors.black45),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                const SizedBox(height: 40),

                // Tombol Sign Up
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Sign Up",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // Teks bawah
                const Text(
                  'Already have an account',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),

                const SizedBox(height: 20),

                // OR divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey[300], thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "or",
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey[300], thickness: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Google sign-up button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _handleGoogleSignUp,
                    icon: Image.asset(
                      'assets/images/Google.png',
                      width: 40,
                      height: 40,
                    ),
                    label: Text(
                      "Continue with Google",
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
