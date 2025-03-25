import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://api.spoonacular.com/recipes';
  final String apiKey = '310176b5966c45458ca73cf083e96c9a'; // Replace with your Spoonacular API key

  // Fetch recipes based on a search query
  Future<List<dynamic>> fetchRecipes(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/complexSearch?query=$query&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results']; // Assuming the API response contains a 'results' field
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
