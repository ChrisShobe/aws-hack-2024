import 'Classes/Recipe.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendToApi(Recipe recipe1, Recipe recipe2) async {
  // Extract names (titles) from both recipes
  String? name1 = recipe1.getName();
  String? name2 = recipe2.getName();
  
  // Create a JSON object with the names of the two recipes
  var data = {
    'recipe1_name': name1,
    'recipe2_name': name2,
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
  } catch (e) {
    print('Error sending data: $e');
  }
}
