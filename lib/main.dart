import 'package:alysa_speak/pages/create_account.dart';
import 'package:alysa_speak/pages/hasil_learning_writing.dart';
import 'package:alysa_speak/pages/home_page.dart';
import 'package:alysa_speak/pages/learning_page.dart';
import 'package:alysa_speak/pages/learning_writing.dart';
import 'package:alysa_speak/pages/level1.dart';
import 'package:alysa_speak/pages/login_page.dart';
import 'package:alysa_speak/pages/start_test.dart';
import 'package:alysa_speak/pages/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:alysa_speak/theme/app_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alysa_speak/pages/test_writing.dart';
import 'package:alysa_speak/pages/test_speaking.dart';
import 'package:alysa_speak/pages/hasil_test_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alysa App',
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/create': (context) => const CreateAccountPage(),
        '/home': (context) => const HomePage(),
        '/learning': (context) => const LearningPage(),
        '/writing': (context) => const LearningWriting(),
        '/level1_writing': (context) => const Level1(),
        '/start_test' : (context) => const StartTest(),
        '/test_writing' : (context) => const TestWritingPage(),
        '/test_speaking' : (context) => const TestSpeakingPage(),
        '/hasil_test' : (context) => HasilTestPage(correctAnswers: 0),
        '/level_completed' : (context) => LevelCompletePage(),
      },
    );
  }
}
