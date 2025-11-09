import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LevelCompletePage extends StatelessWidget {
  const LevelCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🎉 Gambar ilustrasi
              Image.asset(
                'assets/images/celebration.png', // pastikan ada di folder assets
                height: 120,
              ),

              const SizedBox(height: 24),

              // Judul
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Level 1 ',
                      style: TextStyle(
                        color: Color(0xFF1565D8),
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    TextSpan(
                      text: 'Completed!',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Deskripsi
              const Text(
                "Gear up for a quick quiz! You've got just and 30 seconds per question. "
                "Tap the info icon at the top right to check out the module each question comes from. "
                "Let's see what you've got! – ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 4),

              // Teks “Goodluck!”
              const Text(
                "Goodluck!",
                style: TextStyle(
                  color: Color(0xFF1565D8),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 32),

              // Tombol "Level 1 Done"
              SizedBox(
                width: 120,
                height: 45,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.circleCheck,
                    color: Color(0xFF1565D8),
                    size: 16,
                  ),
                  label: const Text(
                    "Level 1",
                    style: TextStyle(
                      color: Color(0xFF1565D8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1565D8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Tombol HOME
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/home");
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1565D8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "HOME",
                    style: TextStyle(
                      color: Color(0xFF1565D8),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Tombol NEXT LEVEL
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565D8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "NEXT LEVEL",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
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
