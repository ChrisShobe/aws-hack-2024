import 'Classes/Recipe.dart';

void SendToApi(Recipe recipe1, Recipe recipe2) {
  print('Recipe 1: ${recipe1.title}');
  print('Ingredients:');
  for (var ingredient in recipe1.getIngredients()) {
    print('- $ingredient');
  }
  print('Steps:');
  for (var step in recipe1.getSteps()) {
    print('- $step');
  }

  print('\nRecipe 2: ${recipe2.title}');
  print('Ingredients:');
  for (var ingredient in recipe2.getIngredients()) {
    print('- $ingredient');
  }
  print('Steps:');
  for (var step in recipe2.getSteps()) {
    print('- $step');
  }
}
