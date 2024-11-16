import 'dart:convert';
import 'Ingredient.dart';
import 'Step.dart';

class Recipe {
  bool vegetarian;
  bool vegan;
  bool glutenFree;
  bool dairyFree;
  bool veryHealthy;
  bool cheap;
  bool veryPopular;
  bool sustainable;
  bool lowFodmap;
  int weightWatcherSmartPoints;
  String gaps;
  int? preparationMinutes;
  int? cookingMinutes;
  int aggregateLikes;
  int healthScore;
  String creditsText;
  String sourceName;
  double pricePerServing;
  List<Ingredient> extendedIngredients;
  int id;
  String title;
  int readyInMinutes;
  int servings;
  String sourceUrl;
  String image;
  String summary;
  List<String> cuisines;
  List<String> dishTypes;
  List<String> diets;
  List<String> occasions;
  String instructions;
  List<AnalyzedInstruction> analyzedInstructions;
  double spoonacularScore;
  String spoonacularSourceUrl;

  Recipe({
    required this.vegetarian,
    required this.vegan,
    required this.glutenFree,
    required this.dairyFree,
    required this.veryHealthy,
    required this.cheap,
    required this.veryPopular,
    required this.sustainable,
    required this.lowFodmap,
    required this.weightWatcherSmartPoints,
    required this.gaps,
    this.preparationMinutes,
    this.cookingMinutes,
    required this.aggregateLikes,
    required this.healthScore,
    required this.creditsText,
    required this.sourceName,
    required this.pricePerServing,
    required this.extendedIngredients,
    required this.id,
    required this.title,
    required this.readyInMinutes,
    required this.servings,
    required this.sourceUrl,
    required this.image,
    required this.summary,
    required this.cuisines,
    required this.dishTypes,
    required this.diets,
    required this.occasions,
    required this.instructions,
    required this.analyzedInstructions,
    required this.spoonacularScore,
    required this.spoonacularSourceUrl,
  });

  // To get all the steps from analyzed instructions
  List<String> getSteps() {
    List<String> steps = [];
    for (var instruction in analyzedInstructions) {
      for (var step in instruction.steps) {
        steps.add(step.step);
      }
    }
    return steps;
  }

  // To get all ingredients from extendedIngredients
  List<String> getIngredients() {
    List<String> ingredients = [];
    for (var ingredient in extendedIngredients) {
      ingredients.add(ingredient.name ?? '');
    }
    return ingredients;
  }

  // To convert from JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    print("recipe from json function called");
    print(json['extendedIngredients'] as List);
    var ingredientsList = (json['extendedIngredients'] as List).map((ingredient) => Ingredient.fromJson(ingredient)).toList();
    print("ingredients list initialized");
    var instructionsList = (json['analyzedInstructions'] as List)
        .map((instruction) => AnalyzedInstruction.fromJson(instruction))
        .toList();
    print("ingstructions list initialized");
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
    var ingredientsList = extendedIngredients.map((e) => e.toJson()).toList();
    var instructionsList = analyzedInstructions.map((e) => e.toJson()).toList();

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
      'extendedIngredients': ingredientsList,
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
      'analyzedInstructions': instructionsList,
      'spoonacularScore': spoonacularScore,
      'spoonacularSourceUrl': spoonacularSourceUrl,
    };
  }
}



class AnalyzedInstruction {
  String name;
  List<Step> steps;

  AnalyzedInstruction({
    required this.name,
    required this.steps,
  });

  factory AnalyzedInstruction.fromJson(Map<String, dynamic> json) {
    var stepsList = (json['steps'] as List)
        .map((step) => Step.fromJson(step))
        .toList();

    return AnalyzedInstruction(
      name: json['name'] ?? '',
      steps: stepsList,
    );
  }

  Map<String, dynamic> toJson() {
    var stepsList = steps.map((e) => e.toJson()).toList();
    return {
      'name': name,
      'steps': stepsList,
    };
  }
}


