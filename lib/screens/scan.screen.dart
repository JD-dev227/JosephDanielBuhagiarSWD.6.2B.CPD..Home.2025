import 'package:flutter/material.dart';
import 'package:ichiraku/services/camera_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final CameraService _cameraService = CameraService();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initializeCamera();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize camera: $e')),
      );
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Scan')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Show loading or error state if not initialized
            _isInitialized 
              ? _cameraService.buildCameraPreview()
              : const CircularProgressIndicator(),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _isInitialized 
                ? () async {
                    final image = await _cameraService.captureImage();
                    if (image != null) {
                      // Handle the captured image
                      print('Captured image path: ${image.path}');
                      // You might want to navigate to a preview screen or process the image
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to capture image')),
                      );
                    }
                  }
                : null, // Disable button if camera not initialized
              child: const Text('Capture Image'),
            ),
          ],
        ),
      ),
    );
  }
}