import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final imageDir = Directory(directory.path);
    final files = imageDir.listSync().where((item) {
      return item.path.endsWith('.jpg');
    }).toList();
    
    setState(() {
      _images = files.map((item) => File(item.path)).toList();
    });
  }

  Future<void> _deleteImage(File image) async {
    try {
      await image.delete();
      // Reload images after deletion.
      _loadImages();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Captured Meals")),
      body: _images.isEmpty
          ? const Center(child: Text("No images captured yet."))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.file(
                        _images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Delete button overlay
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await _deleteImage(_images[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
