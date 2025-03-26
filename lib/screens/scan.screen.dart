import 'package:flutter/material.dart';
import '../services/camera_service.dart';

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
            _isInitialized 
              ? _cameraService.buildCameraPreview()
              : const CircularProgressIndicator(),
            const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isInitialized 
              ? () async {
                  final imagePath = await _cameraService.captureAndSaveImage();
                  if (imagePath != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Image saved at: $imagePath')),
                    );
                    print('Captured image path: $imagePath');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to capture image')),
                    );
                  }
                }
              : null,
            child: const Text('Capture Image'),
          ),
          ],
        ),
      ),
    );
  }
}
