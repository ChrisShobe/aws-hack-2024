import 'Classes/Recipe.dart';

mixin RecipeMergeMixin {
  Recipe merge(Recipe recipe1, Recipe recipe2) {
    return Recipe(
      vegetarian: recipe1.vegetarian ?? recipe2.vegetarian,
      ingredients: (recipe1.ingredients ?? []) + (recipe2.ingredients ?? []),
      title: recipe1.title ?? recipe2.title,
      servings: recipe1.servings ?? recipe2.servings,
      steps: (recipe1.steps ?? []) + (recipe2.steps ?? []),
    );
  }
}
