// lib/main.dart (simplified)
import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MedicationApp());
}

class MedicationApp extends StatelessWidget {
  const MedicationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medication Reminder',
      theme: ThemeData(
        primaryColor: const Color(0xFF4A6572),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A6572),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
