import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Classes/Recipe.dart';
import 'api_key.dart';

Future<Recipe?> fetchRecipe(String recipeName) async {
  final String searchUrl = "https://api.spoonacular.com/recipes/complexSearch";
  final Uri searchUri = Uri.parse(searchUrl).replace(queryParameters: {
    "query": recipeName,       // The recipe name you want to search for
    "apiKey": apiKey,          // Your Spoonacular API key for authentication
  });  
  final http.Response searchResponse = await http.get(searchUri);
  if (searchResponse.statusCode == 200) {
    final Map<String, dynamic> searchResults = json.decode(searchResponse.body);
    final List<dynamic> recipes = searchResults["results"] ?? [];
    if (recipes.isNotEmpty) {
      final int recipeId = recipes[0]["id"];  // Get the ID of the first recipe
      final String recipeUrl = "https://api.spoonacular.com/recipes/$recipeId/information";  // The URL for recipe details
      final Uri recipeUri = Uri.parse(recipeUrl).replace(queryParameters: {"apiKey": apiKey});
      final http.Response recipeResponse = await http.get(recipeUri);
      if (recipeResponse.statusCode == 200) {
        final Map<String, dynamic> recipeData = json.decode(recipeResponse.body);
        final Recipe recipe = Recipe.fromJson(recipeData);
        return recipe;
      } else {
        print("Failed to fetch full recipe details");
      }
    } else {
      print("No recipes found for $recipeName");
    }
  } else {
    print("Failed to fetch search results");
  }
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
