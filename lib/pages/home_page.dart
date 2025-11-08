import 'package:alysa_speak/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Posisi default tetap di 0 (Home)
  int _selectedIndex = 0;

  // Fungsi untuk mengubah halaman saat item di-tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fungsi khusus saat FAB (tombol tengah) di-tap
  void _onFabTapped() {
    // 1. Arahkan ke index "Scan" (tengah)
    // Sekarang index-nya adalah 1
    _onItemTapped(1);
    print("Scan Tapped!");
  }

  // --- KONTEN HALAMAN ANDA (TETAP SAMA) ---
  Widget get _homePageBody => SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Profile row
          Row(
            children: [
              // Avatar
              const CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  'https://cdn-icons-png.flaticon.com/512/4140/4140037.png',
                ),
              ),
              const SizedBox(width: 12),
              // Username
              Text(
                "Dede Fernanda",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Illustration (pakai assets lokal)
          Center(
            child: Image.asset(
            
              'assets/images/homepage.jpg',
              height: 180,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: Center(child: Text("Image not found")),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          // Description text
          Text(
            "Explore all the existing job roles based on your\ninterest and study major",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 32),
          // Button: LEARNING
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/learning');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE3EEFF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "LEARNING",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Button: TEST
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/test');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE3EEFF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "TEST",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  // --- AKHIR KONTEN HALAMAN ANDA ---

  @override
  Widget build(BuildContext context) {
    // 2. Susun ulang daftar halaman (hanya 3 item)
    final List<Widget> _pages = [
      // 0: Home (Konten Anda)
      _homePageBody,
      // 1: Scan/Lens (Halaman placeholder untuk FAB)
      const Center(
        child: Text(
          "Halaman Scan",
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
      // 2: Profile
      const Center(
        child: Text(
          "Halaman Profile",
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      // ISI HALAMAN (Body)
      body: _pages[_selectedIndex],

      // TOMBOL TENGAH (FLOATING ACTION BUTTON)
      floatingActionButton: SizedBox(
        height: 75,
        width: 75,
        child: FloatingActionButton(
          onPressed: _onFabTapped,
          child: Icon(FontAwesomeIcons.camera, color: Colors.white),
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 10.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // BOTTOM NAVIGATION BAR (Dengan perbaikan error)
      bottomNavigationBar: BottomAppBar(
        shape: AutomaticNotchedShape(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          const CircleBorder(),
        ),
        color: AppColors.secondary,
        notchMargin: 8.0,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: 70, // Tinggi bar
          child: Row(
            // 3. MainAxisAlignment diubah ke spaceAround
            // Ini akan memberi jarak yang seimbang untuk 3 item
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // 4. Item navigasi sekarang hanya 3

              // Item Kiri: Home
              _buildNavItem(
                icon: FontAwesomeIcons.house, // Ikon Home
                text: "Home",
                index: 0,
              ),

              // Item Kanan: Profile
              _buildNavItem(
                icon: FontAwesomeIcons.user,
                text: "Profile",
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET BANTUAN
  Widget _buildNavItem({
    IconData? icon, // Icon opsional
    required String text,
    required int index,
  }) {
    bool isSelected = (_selectedIndex == index);
    Color color = isSelected ? AppColors.primary : Colors.grey.shade600;

    // 5. Mengubah Expanded menjadi Flexible
    // Ini membuat item placeholder di tengah tidak memakan ruang
    // secara paksa, tapi item lain bisa membesar
    return Flexible(
      // Diubah dari Expanded
      fit: FlexFit.tight, // Memastikan item tetap rapi
      child: InkWell(
        onTap: () => _onItemTapped(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // INDIKATOR GARIS
            Container(
              height: 3,
              width: 25,
              decoration: BoxDecoration(
                // 6. Indikator di item tengah (FAB) dihilangkan
                color: isSelected && index != 1
                    ? AppColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 6),

            // IKON
            if (icon != null)
              Icon(icon, color: color, size: 22)
            else
              SizedBox(height: 22), // Placeholder seukuran ikon

            SizedBox(height: 4),

            // TEKS
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
