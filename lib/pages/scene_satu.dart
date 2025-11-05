import 'package:flutter/material.dart';

class SceneSatu extends StatelessWidget {
  const SceneSatu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 🖼️ Ilustrasi di bagian atas
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/job_illustration.png', // Ganti sesuai nama file kamu
                    fit: BoxFit.contain,
                    height: 250,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 📝 Teks Judul
              Text(
                'Discover Your\nDream Job here',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF944E63), // warna maroon dari theme
                ),
              ),

              const SizedBox(height: 16),

              // 📄 Deskripsi kecil
              const Text(
                'Explore all the existing job roles based on your\ninterest and study major',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 30),

              // 🔴 Indikator halaman (seperti titik di bawah)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF944E63),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
