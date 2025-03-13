import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'med_scanner.dart';
import 'med_schedule.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medication Reminder',
      theme: ThemeData(
        primaryColor: const Color(0xFF4A6572),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A6572),
          primary: const Color(0xFF4A6572),
          secondary: const Color(0xFF344955),
          tertiary: const Color(0xFFF9AA33),
          background: Colors.grey[100]!,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF344955),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/scanner': (context) => const MedicationScannerScreen(),
        '/schedule': (context) => const MedicationScheduleScreen(),
      },
    );
  }
}
