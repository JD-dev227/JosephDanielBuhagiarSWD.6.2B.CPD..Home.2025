import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraService {
  late CameraController _controller;
  late List<CameraDescription> _cameras;

  // Get list of available cameras
  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras[0], // You can select the camera you want (0 is for the back camera)
      ResolutionPreset.high, // Camera resolution
    );
    await _controller.initialize();
  }

  // Start camera preview
  Widget buildCameraPreview() {
    return _controller.value.isInitialized
        ? CameraPreview(_controller)
        : Center(child: CircularProgressIndicator());
  }

  // Capture image
  Future<XFile> captureImage() async {
    if (!_controller.value.isInitialized) {
      throw CameraException('Camera not initialized', 'Camera is not initialized properly');
    }
    return await _controller.takePicture();
  }

  // Dispose camera controller when done
  void dispose() {
    _controller.dispose();
  }
}
