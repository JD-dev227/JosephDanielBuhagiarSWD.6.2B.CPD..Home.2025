import 'package:flutter/material.dart';
import 'package:ichiraku/services/camera_service.dart';


class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late CameraService _cameraService;

  @override
  void initState() {
    super.initState();
    _cameraService = CameraService();
    _cameraService.initializeCamera();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera Scan')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _cameraService.buildCameraPreview(),
            ElevatedButton(
              onPressed: () async {
                final image = await _cameraService.captureImage();
                print('Captured image path: ${image.path}');
              },
              child: Text('Capture Image'),
            ),
          ],
        ),
      ),
    );
  }
}
