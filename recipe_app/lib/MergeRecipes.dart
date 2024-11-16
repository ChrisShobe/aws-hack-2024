import 'Classes/Recipe.dart';

mixin RecipeMergeMixin {
  Recipe merge(Recipe recipe1, Recipe recipe2) {
    return Recipe(
      vegetarian: recipe1.vegetarian ?? recipe2.vegetarian,
      vegan: recipe1.vegan ?? recipe2.vegan,
      glutenFree: recipe1.glutenFree ?? recipe2.glutenFree,
      dairyFree: recipe1.dairyFree ?? recipe2.dairyFree,
      veryHealthy: recipe1.veryHealthy ?? recipe2.veryHealthy,
      cheap: recipe1.cheap ?? recipe2.cheap,
      veryPopular: recipe1.veryPopular ?? recipe2.veryPopular,
      sustainable: recipe1.sustainable ?? recipe2.sustainable,
      lowFodmap: recipe1.lowFodmap ?? recipe2.lowFodmap,
      weightWatcherSmartPoints: recipe1.weightWatcherSmartPoints ?? recipe2.weightWatcherSmartPoints,
      gaps: recipe1.gaps ?? recipe2.gaps,
      preparationMinutes: recipe1.preparationMinutes ?? recipe2.preparationMinutes,
      cookingMinutes: recipe1.cookingMinutes ?? recipe2.cookingMinutes,
      aggregateLikes: recipe1.aggregateLikes ?? recipe2.aggregateLikes,
      healthScore: recipe1.healthScore ?? recipe2.healthScore,
      creditsText: recipe1.creditsText ?? recipe2.creditsText,
      sourceName: recipe1.sourceName ?? recipe2.sourceName,
      pricePerServing: recipe1.pricePerServing ?? recipe2.pricePerServing,
      extendedIngredients: (recipe1.extendedIngredients ?? []) + (recipe2.extendedIngredients ?? []),
      id: recipe1.id ?? recipe2.id,
      title: recipe1.title ?? recipe2.title,
      readyInMinutes: recipe1.readyInMinutes ?? recipe2.readyInMinutes,
      servings: recipe1.servings ?? recipe2.servings,
      sourceUrl: recipe1.sourceUrl ?? recipe2.sourceUrl,
      image: recipe1.image ?? recipe2.image,
      summary: recipe1.summary ?? recipe2.summary,
      cuisines: (recipe1.cuisines ?? []) + (recipe2.cuisines ?? []),
      dishTypes: (recipe1.dishTypes ?? []) + (recipe2.dishTypes ?? []),
      diets: (recipe1.diets ?? []) + (recipe2.diets ?? []),
      occasions: (recipe1.occasions ?? []) + (recipe2.occasions ?? []),
      instructions: recipe1.instructions ?? recipe2.instructions,
      analyzedInstructions: (recipe1.analyzedInstructions ?? []) + (recipe2.analyzedInstructions ?? []),
      spoonacularScore: recipe1.spoonacularScore ?? recipe2.spoonacularScore,
      spoonacularSourceUrl: recipe1.spoonacularSourceUrl ?? recipe2.spoonacularSourceUrl,
    );
  }
}
