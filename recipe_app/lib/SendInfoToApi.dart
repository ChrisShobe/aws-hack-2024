import 'Classes/Recipe.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendToApi(Recipe recipe1, Recipe recipe2) async {
  // Extract the name, steps, and ingredients from both recipes
  String? name1 = recipe1.getName();
  String? name2 = recipe2.getName();
  List<String>? steps1 = recipe1.getSteps();
  List<String>? steps2 = recipe2.getSteps();
  List<String>? ingredients1 = recipe1.getIngredients();
  List<String>? ingredients2 = recipe2.getIngredients();
  
  // Create a JSON object with the names, steps, and ingredients of the two recipes
  var data = {
    'recipe1_name': name1,
    'recipe1_steps': steps1,
    'recipe1_ingredients': ingredients1,
    'recipe2_name': name2,
    'recipe2_steps': steps2,
    'recipe2_ingredients': ingredients2,
  };

  // Define the API URL where the data will be sent
  var url = Uri.parse('http://localhost:5001/send_data');  // Flask server URL
  
  try {
    // Send a POST request with the JSON data
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    // Optionally handle the response (e.g., print confirmation)
    if (response.statusCode == 200) {
      print('Data sent successfully: ${response.body}');
    } else {
      print('Failed to send data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending data: $e');
  }
}
