import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];

  // Add initializeCamera method to set up the camera.
  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) {
      throw Exception('No cameras found on the device');
    }
    _controller = CameraController(
      _cameras[0],
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    await _controller!.initialize();
  }

  Future<String?> captureAndSaveImage() async {
  if (_controller == null || !_controller!.value.isInitialized) {
    return null;
  }
  try {
    final image = await _controller!.takePicture();
    final directory = await getApplicationDocumentsDirectory();
    
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final imagePath = '${directory.path}/$timestamp.jpg';
    await image.saveTo(imagePath);
    return imagePath;
  } catch (e) {
    print('Error saving image: $e');
    return null;
  }
}

  

  // Method to build the camera preview.
  Widget buildCameraPreview() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: Text('Camera not initialized'));
    }
    return CameraPreview(_controller!);
  }

  // Dispose the controller when no longer needed.
  void dispose() {
    _controller?.dispose();
  }
}
