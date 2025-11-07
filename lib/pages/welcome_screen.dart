import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alysa_speak/theme/app_color.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Background bulatan
            Positioned(
              top: 100,
              left: -30,
              child: CircleAvatar(
                radius: 70,
                backgroundColor: AppColors.secondary,
              ),
            ),
            Positioned(
              top: 200,
              right: 20,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.secondary,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 450,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100),
                  ),
                ),
              ),
            ),

            // Konten utama
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 60),

                  // Nama Aplikasi
                  Text(
                    'Alysa',
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 35),

                  // Deskripsi
                  const Text(
                    'Explore all the existing job roles based on your\ninterest and study major',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Tombol Create an Account
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/create");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textLight,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Create an account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Teks Log in
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(color: AppColors.textDark),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 70),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
