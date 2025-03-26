import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/recipe_card.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _recipes = [];
  bool _isLoading = false;
  String _errorMessage = '';
  Timer? _debounce;

  // Search recipes with debouncing to avoid frequent API calls.
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
        // Show a local notification with the search results
        NotificationService().showNotification(
          title: 'Search Completed',
          body: 'Found ${recipes.length} recipes for "$query".',
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error fetching recipes. Please try again.';
        });
      }
    });
  }

  // Clear search text and results.
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _recipes = [];
      _errorMessage = '';
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ICiracku'), 
        backgroundColor: const Color.fromARGB(255, 243, 123, 10),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "What’s in your mind?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          // Search Bar
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
          // Display Loading, Error, or Results
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
                    title: _recipes[index]['title'] ?? 'No Title Available',
                   description: _recipes[index]['summary'] ?? 'No Description Available',
                ),
              ),
            ),
          // Scan Ingredients Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/scan');
              },
              child: Text("Scan Ingredients"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
