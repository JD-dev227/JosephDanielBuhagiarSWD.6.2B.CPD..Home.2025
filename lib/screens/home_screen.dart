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
        title: const Text('ICiracku'),
        backgroundColor: const Color.fromARGB(255, 243, 123, 10),
        centerTitle: true,
      ),
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  // Small screen (e.g., phones)
                  return Column(
                    children: _buildMainContent(),
                  );
                } else {
                  // Large screen (e.g., tablets, web)
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: _buildMainContent(),
                        ),
                      ),
                      // Maybe show a sidebar or additional panel here for large screens
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.grey[100],
                          child: Center(child: Text('Extra Panel')),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            // Positioned side buttons (floating)
            Positioned(
              right: 16,
              bottom: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: 'captureMeals',
                    tooltip: "Capture Meals",
                    onPressed: () {
                      Navigator.pushNamed(context, '/scan');
                    },
                    child: Icon(Icons.camera_alt),
                  ),
                  const SizedBox(height: 16),
                  FloatingActionButton(
                    heroTag: 'viewCapturedMeals',
                    tooltip: "View Captured Meals",
                    onPressed: () {
                      Navigator.pushNamed(context, '/gallery');
                    },
                    child: Icon(Icons.photo_library),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
    List<Widget> _buildMainContent() {
    return [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "What’s in your mind?",
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
                decoration: const InputDecoration(
                  hintText: 'Search for recipes...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: _searchRecipes,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSearch,
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      if (_isLoading)
        const CircularProgressIndicator()
      else if (_errorMessage.isNotEmpty)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
          ),
        )
      else if (_recipes.isEmpty)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: const Text(
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
    ];
  }
}
