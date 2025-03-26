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
  print("Documents directory: ${directory.path}"); // Debug print
  final imageDir = Directory(directory.path);
  final files = imageDir.listSync().where((item) {
    return item.path.endsWith('.jpg');
  }).toList();
  files.forEach((file) => print('Found file: ${file.path}')); // Debug print
  setState(() {
    _images = files.map((item) => File(item.path)).toList();
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Captured Meals")),
      body: _images.isEmpty
          ? const Center(child: Text("No images captured yet."))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.file(
                    _images[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
    );
  }
}
