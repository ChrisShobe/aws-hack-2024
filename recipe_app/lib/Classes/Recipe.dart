import 'dart:convert';

import 'package:recipe_app/MergeRecipes.dart';

class Recipe with RecipeMergeMixin{
  bool? vegetarian;
  bool? vegan;
  bool? glutenFree;
  bool? dairyFree;
  bool? veryHealthy;
  bool? cheap;
  bool? veryPopular;
  bool? sustainable;
  bool? lowFodmap;
  int? weightWatcherSmartPoints;
  String? gaps;
  int? preparationMinutes;
  int? cookingMinutes;
  int? aggregateLikes;
  int? healthScore;
  String? creditsText;
  String? sourceName;
  double? pricePerServing;
  List<String>? extendedIngredients;
  int? id;
  String? title;
  int? readyInMinutes;
  int? servings;
  String? sourceUrl;
  String? image;
  String? summary;
  List<String>? cuisines;
  List<String>? dishTypes;
  List<String>? diets;
  List<String>? occasions;
  String? instructions;
  List<String>? analyzedInstructions;
  double? spoonacularScore;
  String? spoonacularSourceUrl;

  // Constructor
  Recipe({
    this.vegetarian,
    this.vegan,
    this.glutenFree,
    this.dairyFree,
    this.veryHealthy,
    this.cheap,
    this.veryPopular,
    this.sustainable,
    this.lowFodmap,
    this.weightWatcherSmartPoints,
    this.gaps,
    this.preparationMinutes,
    this.cookingMinutes,
    this.aggregateLikes,
    this.healthScore,
    this.creditsText,
    this.sourceName,
    this.pricePerServing,
    this.extendedIngredients,
    this.id,
    this.title,
    this.readyInMinutes,
    this.servings,
    this.sourceUrl,
    this.image,
    this.summary,
    this.cuisines,
    this.dishTypes,
    this.diets,
    this.occasions,
    this.instructions,
    this.analyzedInstructions,
    this.spoonacularScore,
    this.spoonacularSourceUrl,
  });

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

    // Extract instructions as simple strings
    List<String> instructionsList = [];
    var instructionsJson = json['analyzedInstructions'] as List?;
    if (instructionsJson != null) {
      for (var instructionJson in instructionsJson) {
        if (instructionJson != null && instructionJson['steps'] != null) {
          for (var step in instructionJson['steps']) {
            if (step != null && step['step'] != null) {
              instructionsList.add(step['step'] as String);
            }
          }
        }
      }
    }

    return Recipe(
      vegetarian: json['vegetarian'],
      vegan: json['vegan'],
      glutenFree: json['glutenFree'],
      dairyFree: json['dairyFree'],
      veryHealthy: json['veryHealthy'],
      cheap: json['cheap'],
      veryPopular: json['veryPopular'],
      sustainable: json['sustainable'],
      lowFodmap: json['lowFodmap'],
      weightWatcherSmartPoints: json['weightWatcherSmartPoints'],
      gaps: json['gaps'],
      preparationMinutes: json['preparationMinutes'],
      cookingMinutes: json['cookingMinutes'],
      aggregateLikes: json['aggregateLikes'],
      healthScore: json['healthScore'],
      creditsText: json['creditsText'],
      sourceName: json['sourceName'],
      pricePerServing: json['pricePerServing'],
      extendedIngredients: ingredientsList,
      id: json['id'],
      title: json['title'],
      readyInMinutes: json['readyInMinutes'],
      servings: json['servings'],
      sourceUrl: json['sourceUrl'],
      image: json['image'],
      summary: json['summary'],
      cuisines: List<String>.from(json['cuisines'] ?? []),
      dishTypes: List<String>.from(json['dishTypes'] ?? []),
      diets: List<String>.from(json['diets'] ?? []),
      occasions: List<String>.from(json['occasions'] ?? []),
      instructions: json['instructions'],
      analyzedInstructions: instructionsList,
      spoonacularScore: json['spoonacularScore'],
      spoonacularSourceUrl: json['spoonacularSourceUrl'],
    );
  }

  // To convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'vegetarian': vegetarian,
      'vegan': vegan,
      'glutenFree': glutenFree,
      'dairyFree': dairyFree,
      'veryHealthy': veryHealthy,
      'cheap': cheap,
      'veryPopular': veryPopular,
      'sustainable': sustainable,
      'lowFodmap': lowFodmap,
      'weightWatcherSmartPoints': weightWatcherSmartPoints,
      'gaps': gaps,
      'preparationMinutes': preparationMinutes,
      'cookingMinutes': cookingMinutes,
      'aggregateLikes': aggregateLikes,
      'healthScore': healthScore,
      'creditsText': creditsText,
      'sourceName': sourceName,
      'pricePerServing': pricePerServing,
      'extendedIngredients': extendedIngredients,
      'id': id,
      'title': title,
      'readyInMinutes': readyInMinutes,
      'servings': servings,
      'sourceUrl': sourceUrl,
      'image': image,
      'summary': summary,
      'cuisines': cuisines,
      'dishTypes': dishTypes,
      'diets': diets,
      'occasions': occasions,
      'instructions': instructions,
      'analyzedInstructions': analyzedInstructions,
      'spoonacularScore': spoonacularScore,
      'spoonacularSourceUrl': spoonacularSourceUrl,
    };
  }

  // To get all the steps from analyzedInstructions
  List<String> getSteps() {
    return analyzedInstructions ?? [];
  }

  // To get all ingredients from extendedIngredients
  List<String> getIngredients() {
    return extendedIngredients ?? [];
  }
  void printIngredients() {
      if (extendedIngredients != null && extendedIngredients!.isNotEmpty) {
        print('Ingredients:');
        for (var ingredient in extendedIngredients!) {
          print('- $ingredient');
        }
      } else {
        print('No ingredients available.');
      }
    }

    // Print out all the steps
    void printSteps() {
      if (analyzedInstructions != null && analyzedInstructions!.isNotEmpty) {
        print('Steps:');
        for (var step in analyzedInstructions!) {
          print('- $step');
        }
      } else {
        print('No steps available.');
      }
    }
}
