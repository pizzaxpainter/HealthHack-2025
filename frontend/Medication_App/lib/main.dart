// lib/main.dart (simplified)
import 'package:flutter/material.dart';
import 'med_scanner.dart';

void main() {
  runApp(const MedicationApp());
}

class MedicationApp extends StatelessWidget {
  const MedicationApp({Key? key}) : super(key: key);

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
      home: const MedicationScannerScreen(), // Just go directly to scanner for now
    );
  }
}