import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final title = args?['title'] ?? 'Recipe Details';
    final description = (args?['description'] != null && args!['description'].toString().isNotEmpty)
        ? args['description']
        : 'No description available.';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Html(
            data: description,
            style: {
              "b": Style(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              "a": Style(
                color: Colors.blue,
                textDecoration: TextDecoration.underline,
              ),
            },
            
        ),
      ),
    );
  }
}
