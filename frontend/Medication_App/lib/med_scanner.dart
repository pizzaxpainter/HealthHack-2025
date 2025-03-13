import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class MedicationScannerScreen extends StatefulWidget {
  const MedicationScannerScreen({Key? key}) : super(key: key);

  @override
  State<MedicationScannerScreen> createState() => _MedicationScannerScreenState();
}

class _MedicationScannerScreenState extends State<MedicationScannerScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Get available cameras
    final cameras = await availableCameras();
    
    // Use the first camera from the list (usually the back camera)
    final firstCamera = cameras.first;
    
    // Initialize controller
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    
    // Initialize the controller future
    _initializeControllerFuture = _controller!.initialize();
    
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller?.dispose();
    super.dispose();
  }

  // Function to handle taking a picture
  Future<void> _takePicture() async {
    if (_isDetecting) return;
    
    try {
      setState(() {
        _isDetecting = true;
      });
      
      // Wait for camera initialization
      await _initializeControllerFuture;
      
      // Take picture
      final image = await _controller!.takePicture();
      
      // Here you would implement medication detection
      // For now we'll simulate detection with a delay
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() {
          _isDetecting = false;
        });
        
        // Show a snackbar to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Medication detected!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // If an error occurs, log the error to the console
      print(e);
      setState(() {
        _isDetecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Hold Still',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If camera initialization is complete, show camera preview
                      return CameraPreview(_controller!);
                    } else {
                      // Otherwise, show a loading indicator
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Column(
              children: [
                const Row(
                  children: [
                    SizedBox(width: 100, child: Text('Shape')),
                    Text('Round'),
                    Spacer(),
                    Text('95%'),
                  ],
                ),
                const Divider(),
                const Row(
                  children: [
                    SizedBox(width: 100, child: Text('Weight')),
                    Text('65 mg'),
                    Spacer(),
                    Text('85%'),
                  ],
                ),
                const Divider(),
                const Row(
                  children: [
                    SizedBox(width: 100, child: Text('Name')),
                    Text('Amoxicilline'),
                    Spacer(),
                    Text('90%'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Medication'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: const Color(0xFF4A6572),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: _isDetecting
              ? const CircularProgressIndicator()
              : GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF344955),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}