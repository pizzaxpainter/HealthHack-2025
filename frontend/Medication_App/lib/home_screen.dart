import 'package:flutter/material.dart';
import 'med_schedule.dart';
import 'package:file_picker/file_picker.dart';

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Main App'),
        ),
        body: const Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Hello, User'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // User Greeting Section
            
            const SizedBox(height: 24),

            // Medication Stats Cards
            Row(
              children: [
              Expanded(
                child: _buildStatCard(
                '4',
                'Upcoming Medication',
                const Color(0xFF4A6572),
                context,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                '4',
                'Skipped Medication',
                const Color(0xFFF9AA33),
                context,
                ),
              ),
              ],
            ),
            const SizedBox(height: 24),

            // My Medication Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const Text(
                'My Prescription',
                style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx'],
              );

              if (result != null) {
                String? filePath = result.files.single.path;
                print('Selected file: $filePath');
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('File Selected: ${result.files.single.name}')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No file selected')),
                );
              }
              },
                child: const Text('Add Prescription'),
              )
              ],
            ),
            const SizedBox(height: 8),

            // Medication List
            Expanded(
              child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return _buildMedicationCard(context);
              },
              ),
            ),
            TextButton(
              onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MedicationScheduleScreen()),
              );
              },
              child: const Text('Expand'),
            ),
            ],
          //],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () {
                  Navigator.pushNamed(context, '/scanner');
                },
                iconSize: 32,
                color: const Color(0xFF344955),
              ),
              const SizedBox(width: 8),
              const Text(
                'Medication Scanner',
                style: TextStyle(
                  color: Color(0xFF344955),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMedicationScheduleScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MedicationScheduleScreen()),
    );
  }

  Widget _buildStatCard(String count, String label, Color color, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 20,
                  child: const Text('A'),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amoxicilline - 65 mg Tablet',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'After Meal',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '1 tablet at 12:00 pm',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                    ),
                    child: const Text('Skipped'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                    ),
                    child: const Text('Taken'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}