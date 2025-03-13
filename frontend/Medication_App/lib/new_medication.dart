import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class NewMedicationScreen extends StatefulWidget {
  const NewMedicationScreen({super.key});

  @override
  State<NewMedicationScreen> createState() => _NewMedicationScreenState();
}

class _NewMedicationScreenState extends State<NewMedicationScreen> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Medication',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload Photo
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.photo_camera, size: 32),
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();

                          if (result != null &&
                              result.files.single.path != null) {
                            debugPrint(
                                'File selected: ${result.files.single.path}');
                          } else {
                            debugPrint('File selection canceled.');
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Upload Photo',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form Fields
              const Text('Name'),
              const SizedBox(height: 8),
              _buildTextField(),
              const SizedBox(height: 16),

              const Text('Dosage'),
              const SizedBox(height: 8),
              _buildTextField(),
              const SizedBox(height: 16),

              const Text('Shape'),
              const SizedBox(height: 8),
              _buildTextField(),
              const SizedBox(height: 16),

              const Text('Colour'),
              const SizedBox(height: 8),
              _buildTextField(),
              const SizedBox(height: 16),

              // Start Date
              const Text('Start Date'),
              const SizedBox(height: 8),
              _buildDatePicker(
                value: startDate,
                hint: 'Select start date',
                onTap: () => _selectDate(context, true),
              ),
              const SizedBox(height: 16),

              // End Date
              const Text('End Date'),
              const SizedBox(height: 8),
              _buildDatePicker(
                value: endDate,
                hint: 'Select end date',
                onTap: () => _selectDate(context, false),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    DateTime? value,
    required String hint,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value != null ? DateFormat('MMM dd, yyyy').format(value) : hint,
              style: TextStyle(
                color: value != null ? Colors.black : Colors.grey,
              ),
            ),
            const Icon(Icons.calendar_today, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: isStartDate ? DateTime.now() : (startDate ?? DateTime.now()),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          // Reset end date if it's now before start date
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = null;
          }
        } else {
          endDate = picked;
        }
      });
    }
  }
}
