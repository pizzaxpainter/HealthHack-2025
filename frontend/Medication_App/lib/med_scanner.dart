import 'package:flutter/material.dart';
import 'new_medication.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MedicationScannerScreen extends StatefulWidget {
  const MedicationScannerScreen({Key? key}) : super(key: key);

  @override
  _MedicationScannerScreenState createState() => _MedicationScannerScreenState();
}

class _MedicationScannerScreenState extends State<MedicationScannerScreen> {
  File? _capturedImage; // Holds the image file

  Future<void> _captureImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      setState(() {
        _capturedImage = File(image.path); // Update state with new image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Scanner'),
      ),
      body: Column(
        children: [
          // Camera Preview / Captured Image
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[400]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _capturedImage == null
                  ? const Center(
                      child: Text(
                        'Camera Preview',
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _capturedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
            ),
          ),

          // Medication Info Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Column(
              children: [
                const Row(
                  children: [
                    SizedBox(width: 100, child: Text('Name')),
                    Text('Amoxicillin'),
                    Spacer(),
                    Text('90%'),
                  ],
                ),
                const Divider(),
                const Row(
                  children: [
                    SizedBox(width: 100, child: Text('Shape')),
                    Text('Round'),
                  ],
                ),
                const Divider(),
                const Row(
                  children: [
                    SizedBox(width: 100, child: Text('Weight')),
                    Text('65 mg'),
                  ],
                ),
              ],
            ),
          ),

          // Add Medication Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewMedicationScreen(),
                          ),
                        );
                      },
                icon: const Icon(Icons.add, color: Colors.white,),
                label: const Text('Add Medication', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          // Camera Capture Button
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: IconButton(
              icon: const Icon(
                Icons.camera_alt,
                size: 32,
                color: Color(0xFF344955),
              ),
              onPressed: _captureImage,
            ),
          ),
        ],
      ),
    );
  }
}
