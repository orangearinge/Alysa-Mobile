import 'package:alysa_speak/pages/create_account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alysa_speak/firebase_options.dart';
import 'package:alysa_speak/pages/home_page.dart';
import 'package:alysa_speak/pages/learning_page.dart';
import 'package:alysa_speak/pages/onboarding_page.dart';
import 'package:alysa_speak/pages/planning_page.dart';
import 'package:alysa_speak/pages/login_page.dart';
import 'package:alysa_speak/pages/start_test.dart';
import 'package:alysa_speak/pages/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:alysa_speak/theme/app_color.dart';
import 'package:alysa_speak/pages/test_mix_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alysa_speak/pages/hasil_test_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      // Remove initialRoute and use home for AuthGate
      home: const AuthGate(),
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/create': (context) => const CreateAccountPage(),
        '/onboarding': (context) => const OnboardingPage(),
        '/home': (context) => const HomePage(),
        '/planning': (context) => const PlanningPage(),
        '/learning': (context) => const LearningPage(),
        '/start_test': (context) => const StartTest(),
        '/soal_test': (context) => const TestMixedPage(),
        '/hasil_test': (context) => HasilTestPage(correctAnswers: 0),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const HomePage();
        }
        return const WelcomePage();
      },
    );
  }
}
