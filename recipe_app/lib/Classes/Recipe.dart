import 'package:recipe_app/MergeRecipes.dart';

class Recipe with RecipeMergeMixin{
  bool? vegetarian;
  List<String>? ingredients;
  String? title;
  int? servings;
  List<String>? steps; // Unified list for steps
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
  
  String? getName(){
    return title;
  }
  int getTime() {
    return (preparationMinutes ?? 0) + (cookingMinutes ?? 0);
  }
  List<String> getSteps() {
    // Ensure that steps is not null before returning
    return steps ?? [];
  }
   List<String> getIngredients() {
    // Ensure that steps is not null before returning
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
    // Ensure 'steps' is not null and has items
    if (steps != null && steps!.isNotEmpty) {
      for (var step in steps!) {
        print(step);
      }
    } else {
      print('No steps available.');
    }
  }

}
