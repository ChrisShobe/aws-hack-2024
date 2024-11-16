import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey = "019ac8f5318a4d3582a5f7fc34eafc70";


Future<Map<String, dynamic>?> fetchRecipe(String recipeName) async {
  print("Fetching recipe for $recipeName...");
  final String searchUrl = "https://api.spoonacular.com/recipes/complexSearch";
  final Uri searchUri = Uri.parse(searchUrl).replace(queryParameters: {
    "query": recipeName,       // The recipe name you want to search for
    "apiKey": apiKey,          // Your Spoonacular API key for authentication
  });

  // Make the HTTP GET request using the constructed URI
  final http.Response searchResponse = await http.get(searchUri);

  // Check if the request was successful (HTTP status 200)
  if (searchResponse.statusCode == 200) {
    print("Request successful");
    
    // Parse the JSON response body into a Dart Map
    final Map<String, dynamic> searchResults = json.decode(searchResponse.body);
    
    // Extract the list of recipes from the response (results is a list of recipes)
    final List<dynamic> recipes = searchResults["results"] ?? [];

    // If recipes were found, fetch details for the first recipe
    if (recipes.isNotEmpty) {
      final int recipeId = recipes[0]["id"];  // Get the ID of the first recipe
      final String recipeUrl = "https://api.spoonacular.com/recipes/$recipeId/information";  // The URL for recipe details
      final Uri recipeUri = Uri.parse(recipeUrl).replace(queryParameters: {"apiKey": apiKey});
      
      // Make another HTTP GET request to fetch the full details of the selected recipe
      final http.Response recipeResponse = await http.get(recipeUri);

      // Check if the request was successful (HTTP status 200)
      if (recipeResponse.statusCode == 200) {
        print("Full Recipe Data: ${recipeResponse.body}");
        return json.decode(recipeResponse.body);
      }
    }
  }
  // If no recipe is found or an error occurs, return null
  return null;
}



void printRecipe(Map<String, dynamic>? recipe) {
  if (recipe != null) {
    print("Title: ${recipe['title']}\n");

    print("Ingredients:");
    final List<dynamic> ingredients = recipe["extendedIngredients"] ?? [];
    for (var ingredient in ingredients) {
      print(
          "- ${ingredient['amount']} ${ingredient['unit']} ${ingredient['name']}");
    }

    print("\nSteps:");
    final List<dynamic> instructions =
        recipe["analyzedInstructions"] ?? [{}];
    if (instructions.isNotEmpty) {
      final List<dynamic> steps = instructions[0]["steps"] ?? [];
      for (var step in steps) {
        print("${step['number']}. ${step['step']}");
      }
    } else {
      print("No steps available.");
    }
  } else {
    print("Recipe not found.");
  }
}
