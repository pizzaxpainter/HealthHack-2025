import 'package:flutter/material.dart';
import 'new_medication.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class MedicationScannerScreen extends StatefulWidget {
  const MedicationScannerScreen({super.key});

  @override
  _MedicationScannerScreenState createState() =>
      _MedicationScannerScreenState();
}

class _MedicationScannerScreenState extends State<MedicationScannerScreen> {
  File? _capturedImage;
  bool _isProcessing = false;
  Map<String, dynamic>? _medicationInfo;
  String? _ocrText;

  Future<void> _captureImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _capturedImage = File(image.path);
        _isProcessing = true;
      });

      try {
        await Future.wait([_classifyPill(image.path)]);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing image: $e')),
        );
      } finally {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

//TODO: Make the responses work!
  Future<void> _classifyPill(String imagePath) async {
    try {
      final bytes = File(imagePath).readAsBytesSync();
      final base64Image = base64Encode(bytes);

      // Upload image to a temporary online location
      final uploadResponse = await http.post(
        Uri.parse(
            'https://api.imgbb.com/1/upload?key=9f770b3a812c399f611a4466af6fe70f'),
        body: {
          'image': base64Image,
        },
      );

      if (uploadResponse.statusCode == 200) {
        final imageUrl = jsonDecode(uploadResponse.body)['data']['url'];
        print('Uploaded image URL: $imageUrl');

        // Step 1: Request event_id
        print('Starting 2-step classification request...');
        final response1 = await http.post(
          Uri.parse(
              'https://atulisoffline-healthhack-2025.hf.space/gradio_api/call/classify_image'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'data': [
              {'path': imageUrl}
            ]
          }),
        );

        if (response1.statusCode == 200) {
          final responseBody = jsonDecode(response1.body);
          final eventId =
              responseBody['event_id']; // Handle both possible response formats
          print('Received event_id: $eventId');

          if (eventId == null) {
            throw Exception('Failed to extract event_id from response');
          }

          // Step 2: Poll using event_id
          final response2 = await http.get(
            Uri.parse(
                'https://atulisoffline-healthhack-2025.hf.space/call/classify_image/$eventId'),
          );

          print(
              'Polling classification response code: ${response2.statusCode}');
          if (response2.statusCode == 200) {
            final resultData = jsonDecode(response2.body)['data'];
            print('Classification result data: ${response2.body.toString()}');

            if (mounted) {
              setState(() {
                _medicationInfo = {
                  'name': resultData?.toString() ?? 'Unknown',
                  'confidence': 'N/A',
                  'shape': 'Unknown',
                  'weight': 'Unknown',
                };
              });
            }
          } else {
            throw Exception(
                'Failed to poll classification result: ${response2.statusCode}');
          }
        } else {
          throw Exception('Failed to classify pill: ${response1.statusCode}');
        }
      } else {
        throw Exception('Failed to upload image: ${uploadResponse.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _medicationInfo = {
            'name': 'Error',
            'confidence': 'N/A',
            'shape': 'Unknown',
            'weight': 'Unknown',
          };
        });
      }
      throw Exception('Pill classification failed: $e');
    }
  }

  Future<void> _performOcr(String imagePath) async {
    try {
      print('Starting 2-step OCR request...');
      final response1 = await http.post(
        Uri.parse(
            'https://atulisoffline-healthhack-2025.hf.space/gradio_api/call/ocr_image'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'data': [
            {'path': imagePath}
          ]
        }),
      );

      if (response1.statusCode == 200) {
        final eventId = jsonDecode(response1.body)['hash'];
        print('Received OCR event_id: $eventId');

        final response2 = await http.get(
          Uri.parse(
              'https://atulisoffline-healthhack-2025.hf.space/gradio_api/call/ocr_image/$eventId'),
        );

        print('Polling OCR response code: ${response2.statusCode}');
        if (response2.statusCode == 200) {
          final resultData = jsonDecode(response2.body)['data'];
          print('OCR result data: $resultData');
          if (mounted) {
            setState(() {
              _ocrText =
                  resultData.isNotEmpty ? resultData[0] : 'No text found';
            });
          }
        } else {
          throw Exception('Failed to poll OCR result: ${response2.statusCode}');
        }
      } else {
        throw Exception('Failed to request OCR: ${response1.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _ocrText = 'Error processing text: $e';
        });
      }
      throw Exception('OCR processing failed: $e');
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
                  ? const Center(child: Text('Camera Preview'))
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _capturedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        if (_isProcessing)
                          const Center(child: CircularProgressIndicator()),
                      ],
                    ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('Name')),
                    Text(_medicationInfo?['name'] ?? 'Unknown'),
                    const Spacer(),
                    Text(_medicationInfo?['confidence'] ?? 'N/A'),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('Shape')),
                    Text(_medicationInfo?['shape'] ?? 'Unknown'),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('Weight')),
                    Text(_medicationInfo?['weight'] ?? 'Unknown'),
                  ],
                ),
                if (_ocrText != null) ...[
                  const Divider(),
                  const Text('OCR Result:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_ocrText!),
                ],
              ],
            ),
          ),
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
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add Medication',
                    style: TextStyle(color: Colors.white)),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: IconButton(
              icon: const Icon(Icons.camera_alt,
                  size: 32, color: Color(0xFF344955)),
              onPressed: _captureImage,
            ),
          ),
        ],
      ),
    );
  }
}
