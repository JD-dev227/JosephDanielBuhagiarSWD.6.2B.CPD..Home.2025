import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String description;

  RecipeCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.pushNamed(context, '/recipe',
              arguments: {'title': title, 'description': description});
        },
      ),
    );
  }
}
