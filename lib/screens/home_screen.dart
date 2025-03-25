import 'package:flutter/material.dart';
import '../widgets/recipe_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('iCiracku: Recipe Finder'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "What’s in your fridge? Let’s find a recipe!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/scan');
            },
            child: Text("Scan Ingredients"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => RecipeCard(
                title: "Recipe $index",
                description: "Tasty dish $index",
              ),
            ),
          )
        ],
      ),
    );
  }
}
