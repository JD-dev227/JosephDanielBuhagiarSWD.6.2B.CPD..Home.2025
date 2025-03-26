import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiKey = 'dbedb8c5f790449d9cc6a5515ef8dd51'; 
  static const String _baseUrl = 'https://api.spoonacular.com/recipes';

  // Fetch recipes based on a search query
  static Future<List<dynamic>> fetchRecipes(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/complexSearch?query=$query&apiKey=$_apiKey&addRecipeInformation=true'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
