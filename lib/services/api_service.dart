import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://api.spoonacular.com/recipes';

  Future<List<dynamic>> fetchRecipes(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/complexSearch?query=$query&apiKey=YOUR_API_KEY'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results']; // assuming the API returns a 'results' key
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
