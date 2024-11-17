import 'Classes/Recipe.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> sendToApi(Recipe recipe1, Recipe recipe2) async {
  String? name1 = recipe1.getName();
  String? name2 = recipe2.getName();
  List<String>? steps1 = recipe1.getSteps();
  List<String>? steps2 = recipe2.getSteps();
  List<String>? ingredients1 = recipe1.getIngredients();
  List<String>? ingredients2 = recipe2.getIngredients();

  var data = {
    'recipe1_name': name1,
    'recipe1_steps': steps1,
    'recipe1_ingredients': ingredients1,
    'recipe2_name': name2,
    'recipe2_steps': steps2,
    'recipe2_ingredients': ingredients2,
  };

  var url = Uri.parse('http://localhost:5001/send_data'); // Flask server URL

  try {
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return response.body; // Return the response body
    } else {
      return 'Failed to send data: ${response.statusCode}';
    }
  } catch (e) {
    return 'Error sending data: $e';
  }
}
