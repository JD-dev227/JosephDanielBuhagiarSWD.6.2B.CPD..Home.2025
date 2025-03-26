import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];

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

  Widget buildCameraPreview() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: Text('Camera not initialized'));
    }
    return CameraPreview(_controller!);
  }

  Future<XFile?> captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return null;
    }
    try {
      return await _controller!.takePicture();
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _controller?.dispose();
  }
}
