import 'Classes/Recipe.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> sendToApi(Recipe recipe1, Recipe recipe2, String? prevInput) async {
  String? name1 = recipe1.getName();
  String? name2 = recipe2.getName();
  List<dynamic>? steps1 = recipe1.getSteps();
  List<dynamic>? steps2 = recipe2.getSteps();
  List<dynamic>? ingredients1 = recipe1.getIngredients();
  List<dynamic>? ingredients2 = recipe2.getIngredients();
  String? prev = prevInput; 

  var data = {
    'recipe1_name': name1,
    'recipe1_steps': steps1,
    'recipe1_ingredients': ingredients1,
    'recipe2_name': name2,
    'recipe2_steps': steps2,
    'recipe2_ingredients': ingredients2,
    'prevInput' : prev,
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


Future<String> sendMessageToApi(String message) async {
  var data = {
    'message': message, // The general message to send
  };
  var url = Uri.parse('http://localhost:5001/send_message'); // Flask server URL for sending a message
  try {
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return response.body; 
    } else {
      return 'Failed to send message: ${response.statusCode}';
    }
  } catch (e) {
    return 'Error sending message: $e';
  }
}
