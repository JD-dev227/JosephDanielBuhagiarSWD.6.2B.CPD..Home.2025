import 'package:flutter/material.dart';

class RecipeScreen extends StatelessWidget {
  final String title;
  final String description;

  RecipeScreen({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(description),
      ),
    );
  }
}
