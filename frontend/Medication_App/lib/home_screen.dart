import 'package:flutter/material.dart';
import 'med_scanner.dart';
import 'med_schedule.dart';
import 'package:file_picker/file_picker.dart';
import 'new_medication.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Icon(Icons.person, size: 18, color: Colors.black),
            ),
            const SizedBox(width: 10),
            const Text(
              'Hello, User',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatusCard(
                    context,
                    '4',
                    'Upcoming Medication',
                    const Color(0xFFEAEAEA),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatusCard(
                    context,
                    '4',
                    'Skipped Medication',
                    const Color(0xFFEAEAEA),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Add Medication Button
            _buildAddMedicationButton(context),

            const SizedBox(height: 24),

            // My Medication Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Medication',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles();

                    if (result != null && result.files.single.path != null) {
                      debugPrint('File selected: ${result.files.single.path}');
                    } else {
                      debugPrint('File selection canceled.');
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.upload_file, size: 18),
                      const SizedBox(width: 4),
                      const Text(
                        'Upload Prescription',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Medication List
            Expanded(
              child: ListView(
                children: [
                  _buildMedicationItem(
                    context,
                    'Amoxicillin - 65 mg Tablet',
                    'After Meal',
                    '1 tablet at 12:00 pm',
                  ),
                  const SizedBox(height: 14),
                  _buildMedicationItem(
                    context,
                    'Amoxicillin - 65 mg Tablet',
                    'After Meal',
                    '1 tablet at 4:00 pm',
                  ),
                  const SizedBox(height: 14),
                  _buildMedicationItem(
                    context,
                    'Amoxicillin - 65 mg Tablet',
                    'After Meal',
                    '1 tablet at 8:00 pm',
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MedicationScheduleScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Expand',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context), // ✅ Corrected placement
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    String number,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAddMedicationButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewMedicationScreen(),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            const Text(
              'Add Medication',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationItem(
    BuildContext context,
    String name,
    String timing,
    String dose,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            timing,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          Text(
            dose,
            style: const TextStyle(fontSize: 12, color: Colors.red),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black87,
                    elevation: 0,
                  ),
                  child: const Text('Skipped'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black87,
                    elevation: 0,
                  ),
                  child: const Text('Taken'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.qr_code_scanner,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MedicationScannerScreen(),
                  ),
                );
              },
            ),
            const SizedBox(width: 5),
            const Text(
              'Scan Medication',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
