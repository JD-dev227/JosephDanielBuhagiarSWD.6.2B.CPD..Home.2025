import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];

  // Get list of available cameras
  Future<void> initializeCamera() async {
    try {
      // Ensure cameras are available
      _cameras = await availableCameras();
      
      if (_cameras.isEmpty) {
        throw Exception('No cameras found on the device');
      }

      // Initialize camera controller with error handling
      _controller = CameraController(
        _cameras[0], 
        ResolutionPreset.high,
        // Add imageFormatGroup for better compatibility
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      // Ensure initialization
      await _controller!.initialize();
    } on CameraException catch (e) {
      // Handle specific camera initialization errors
      debugPrint('Camera initialization error: ${e.code} - ${e.description}');
      rethrow;
    } catch (e) {
      // Handle any other unexpected errors
      debugPrint('Unexpected camera initialization error: $e');
      rethrow;
    }
  }

  // Start camera preview with null safety
  Widget buildCameraPreview() {
    if (_controller == null) {
      return const Center(child: Text('Camera not initialized'));
    }

    return _controller!.value.isInitialized
        ? CameraPreview(_controller!)
        : const Center(child: CircularProgressIndicator());
  }

  // Capture image with more robust error handling
  Future<XFile?> captureImage() async {
    if (_controller == null) {
      debugPrint('Camera not initialized');
      return null;
    }

    if (!_controller!.value.isInitialized) {
      debugPrint('Camera is not fully initialized');
      return null;
    }

    try {
      return await _controller!.takePicture();
    } on CameraException catch (e) {
      debugPrint('Error capturing image: ${e.code} - ${e.description}');
      return null;
    }
  }

  // Properly dispose of camera controller
  void dispose() {
    _controller?.dispose();
  }


  CameraDescription? get currentCamera => 
      _cameras.isNotEmpty ? _cameras[0] : null;
}