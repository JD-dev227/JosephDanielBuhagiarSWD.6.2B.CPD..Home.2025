import 'dart:async';

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/recipe_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _recipes = [];
  bool _isLoading = false;
  String _errorMessage = '';
  Timer? _debounce;

  // Function to fetch recipes based on the search query
  void _searchRecipes(String query) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() {
          _recipes = [];
          _errorMessage = '';
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final recipes = await ApiService.fetchRecipes(query);
        setState(() {
          _recipes = recipes;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error fetching recipes. Please try again.';
        });
      }
    });
  }

  // Clear the search field and results
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _recipes = [];
      _errorMessage = '';
    });
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for recipes...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _searchRecipes,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: _clearSearch,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          if (_isLoading)
            CircularProgressIndicator()
          else if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            )
          else if (_recipes.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No results found. Please try a different search.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) => RecipeCard(
                  title: _recipes[index]['title'],
                  description: _recipes[index]['summary'],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
