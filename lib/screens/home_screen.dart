import 'package:flutter/material.dart';
import 'package:ichiraku/services/api_service.dart';
import '../widgets/recipe_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiService _apiService = ApiService(); // Initialize ApiService
  List<dynamic> _recipes = []; // List to hold the fetched recipes
  bool _isLoading = false; // Track loading state

  // Fetch recipes from the API based on the search query
  void _fetchRecipes(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch recipes from the API (query can be dynamic)
      final recipes = await _apiService.fetchRecipes(query);
      setState(() {
        _recipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRecipes('fridge'); // Fetch recipes for example query 'fridge'
  }

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
              Navigator.pushNamed(context, '/scan'); // Navigate to scan screen
            },
            child: Text("Scan Ingredients"),
          ),
          // If loading, show a loading indicator
          if (_isLoading)
            CircularProgressIndicator(),
          // Else, show the recipes in a list
          if (!_isLoading)
            Expanded(
              child: ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  return RecipeCard(
                    title: _recipes[index]['title'], // Fetch title from API
                    description: _recipes[index]['summary'], // Fetch description
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
