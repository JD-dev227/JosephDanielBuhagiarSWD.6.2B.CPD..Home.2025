import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String description;

  const RecipeCard({Key? key, required this.title, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        onTap: () {
          // Navigate to the Recipe Screen with details
          Navigator.pushNamed(
            context,
            '/recipe',
            arguments: {'title': title, 
                        'description': description,},
          );
        },
      ),
    );
  }
}
