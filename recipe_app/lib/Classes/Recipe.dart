import 'package:recipe_app/MergeRecipes.dart';
import 'dart:convert';
import 'package:recipe_app/JsonParser.dart';

class Recipe with RecipeMergeMixin {
  bool? vegetarian;
  List<dynamic>? ingredients;
  String? title;
  int? servings;
  List<dynamic>? steps; // Unified list for steps
  int? preparationMinutes;
  int? cookingMinutes;

  // Constructor
  Recipe({
    this.vegetarian,
    this.ingredients,
    this.title,
    this.servings,
    this.steps,
    this.preparationMinutes,
    this.cookingMinutes,
  });

  String? getName() {
    return title;
  }

  int getTime() {
    return (preparationMinutes ?? 0) + (cookingMinutes ?? 0);
  }

  List<dynamic> getSteps() {
    return steps ?? [];
  }

  List<dynamic> getIngredients() {
    return ingredients ?? [];
  }

  // To convert from JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    // Extract ingredients as a simple list of strings
    List<String> ingredientsList = [];
    var ingredientsJson = json['extendedIngredients'] as List?;
    if (ingredientsJson != null) {
      for (var ingredientJson in ingredientsJson) {
        if (ingredientJson != null && ingredientJson['name'] != null) {
          ingredientsList.add(ingredientJson['name'] as String);
        }
      }
    }
    // Extract steps from analyzedInstructions and add them as strings to the steps list
    List<String> stepsList = [];
    var instructionsJson = json['analyzedInstructions'] as List?;
    if (instructionsJson != null) {
      for (var instructionJson in instructionsJson) {
        if (instructionJson != null && instructionJson['steps'] != null) {
          for (var step in instructionJson['steps']) {
            if (step != null && step['step'] != null) {
              stepsList.add(step['step'] as String);
            }
          }
        }
      }
    }
    return Recipe(
      vegetarian: json['vegetarian'],
      ingredients: ingredientsList,
      title: json['title'],
      servings: json['servings'],
      steps: stepsList,
      preparationMinutes: json['preparationMinutes'],
      cookingMinutes: json['cookingMinutes'],
    );
  }

  // Calculate total time to cook (sum of preparation and cooking time)
  int getTotalTime() {
    int totalTime = 0;
    totalTime = (preparationMinutes ?? 0) + (cookingMinutes ?? 0);
    return totalTime;
  }

  void printSteps() {
    if (steps != null && steps!.isNotEmpty) {
      for (var step in steps!) {
        print(step);
      }
    } else {
      print('No steps available.');
    }
  }

  // Set ingredients from JSON string
  void setIngredients(List<dynamic> newIngredients) {
    ingredients = newIngredients;
  }

  // Set steps from JSON string
  void setSteps(List<dynamic> newSteps) {
    steps = newSteps;
  }

void ParseStrings(List<dynamic> ingredients, List<dynamic> steps) {
  // Parse ingredients and remove any unnecessary characters
  List<String> parsedIngredients = [];
  for (var ingredient in ingredients) {
    // Assuming ingredients are in string format, just clean them up
    if (ingredient is String) {
      parsedIngredients.add(ingredient.trim());
    }
  }

  // Parse steps and remove any unnecessary characters
  List<String> parsedSteps = [];
  for (var step in steps) {
    // Assuming steps are in string format, just clean them up
    if (step is String) {
      parsedSteps.add(step.trim());
    }
  }
  // Set the cleaned lists back to the class
  setIngredients(parsedIngredients);
  setSteps(parsedSteps);
}

}
