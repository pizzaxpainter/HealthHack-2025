import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


class NewMedicationScreen extends StatelessWidget {
  const NewMedicationScreen({Key? key}) : super(key: key);

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
                    child: 
                    IconButton(
                      icon: Icon(Icons.photo_camera, size: 32),
                      onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles();

                    if (result != null && result.files.single.path != null) {
                      debugPrint('File selected: ${result.files.single.path}');
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
            const SizedBox(height: 32),
            
            // Submit Button
            Container(
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
}