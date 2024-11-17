import 'dart:convert';
import 'Classes/Recipe.dart';

class JsonParser {
  // Splits the recipe JSON into ingredients and steps
  static Map<String, dynamic> splitRecipeJson(String recipeJson) {
    try {
      // Decode the recipe JSON
      Map<String, dynamic> parsedJson = jsonDecode(recipeJson);

      // Extract the `model_responses` field, where the recipe information resides
      String modelResponses = parsedJson['model_responses'] ?? '';

      // Prepare lists for ingredients and steps
      List<String> ingredients = [];
      List<String> steps = [];

      // Flag to track when we are in the "ingredients" or "steps" section
      bool inIngredients = false;
      bool inSteps = false;

      // Initialize a map for the parsed recipe JSON output
      Map<String, dynamic> parsedRecipeJson = {
        'ingredients': ingredients,
        'steps': steps,
      };

      // Split the modelResponses by sentences or meaningful markers instead of words
      List<String> sections = modelResponses.split(RegExp(r'(?<=\.)\s*'));

      for (String section in sections) {
        String trimmedSection = section.trim().toLowerCase();

        // Check for "ingredients" section start
        if (trimmedSection.contains('ingredients')) {
          inIngredients = true;
          continue; // Skip processing this line as it's the header
        }

        // Check for any of the step-related keywords: "Directions", "Steps", "Instructions"
        if (trimmedSection.contains('steps') || trimmedSection.contains('directions') || trimmedSection.contains('instructions')) {
          inSteps = true;
          continue; // Skip processing this line as it's the header
        }

        // Add to ingredients list if in ingredients section
        if (inIngredients) {
          if (trimmedSection.isEmpty) continue;  // Skip empty lines
          ingredients.add(trimmedSection);
        }

        // Add to steps list if in steps section
        if (inSteps) {
          if (trimmedSection.isEmpty) continue;  // Skip empty lines
          steps.add(trimmedSection);
        }
      }

      // Return the map with the ingredients and steps
      return parsedRecipeJson;
    } catch (e) {
      throw Exception('Error parsing recipe JSON: $e');
    }
  }

  // Processes the ingredients and steps JSON strings, and updates the recipe
  static void AppendToRecipe3(
  String stepsJson, String ingredientsJson, Recipe recipe3) {
  try {
    // Check if the input JSON is valid
    Map<String, dynamic> ingredientsMap = jsonDecode(ingredientsJson);
    Map<String, dynamic> stepsMap = jsonDecode(stepsJson);

    // Make sure 'ingredients' and 'steps' exist and are lists
    List<dynamic> newIngredients = List<dynamic>.from(ingredientsMap['ingredients'] ?? []);
    List<dynamic> newSteps = List<dynamic>.from(stepsMap['steps'] ?? []);

    // Initialize or get the current ingredients and steps in recipe3
    List<dynamic> currentIngredients = recipe3.ingredients ?? [];
    List<dynamic> currentSteps = recipe3.steps ?? [];

    // Add new ingredients and steps to recipe3
    currentIngredients.addAll(newIngredients);
    currentSteps.addAll(newSteps);

    // Print the updated ingredients and steps
    print('Updated Ingredients: $currentIngredients');
    print('Updated Steps: $currentSteps');

    // Update the recipe3 object
    recipe3.ingredients = currentIngredients;
    recipe3.steps = currentSteps;
  } catch (e) {
    throw Exception('Error appending ingredients and steps to recipe3: $e');
  }
}

}
