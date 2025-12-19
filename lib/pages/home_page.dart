import 'package:alysa_speak/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alysa_speak/pages/profile_page.dart';
import 'package:alysa_speak/pages/scan_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alysa_speak/pages/quiz_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onFabTapped() {
    _onItemTapped(1);
    print("Scan Tapped!");
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [_HomeContent(), ScanPage(), ProfilePage()];

    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
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
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNavItem(
                icon: FontAwesomeIcons.house,
                text: "Home",
                index: 0,
              ),
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

  Widget _buildNavItem({
    IconData? icon,
    required String text,
    required int index,
  }) {
    bool isSelected = (_selectedIndex == index);
    Color color = isSelected ? AppColors.primary : Colors.grey.shade600;

    return Flexible(
      fit: FlexFit.tight,
      child: InkWell(
        onTap: () => _onItemTapped(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 3,
              width: 25,
              decoration: BoxDecoration(
                color: isSelected && index != 1
                    ? AppColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 6),
            if (icon != null)
              Icon(icon, color: color, size: 22)
            else
              SizedBox(height: 22),
            SizedBox(height: 4),
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

// Home Content Widget
class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, User!", // Could be dynamic
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "Let's crack IELTS!",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                   CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Today's Plan Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Today's Plan", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/planning'),
                    child: Text("View All", style: GoogleFonts.poppins(color: AppColors.primary)),
                  )
                ],
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/planning'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      CircularProgressIndicator(
                        value: 0.4,
                        backgroundColor: Colors.white,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Daily Goal: 30 mins",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            Text(
                              "12 mins completed",
                              style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Lessons Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Lessons", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/learning'),
                    child: Text("See All", style: GoogleFonts.poppins(color: AppColors.primary)),
                  )
                ],
              ),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildLessonCard(context, "Speaking", Icons.mic, Colors.orange),
                    _buildLessonCard(context, "Writing", Icons.edit, Colors.blue),
                    _buildLessonCard(context, "Reading", Icons.book, Colors.green),
                    _buildLessonCard(context, "Listening", Icons.headphones, Colors.purple),
                  ],
                ),
              ),
              const SizedBox(height: 32),


             
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonCard(BuildContext context, String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/learning'),
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 8,
                  )
                ]
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
