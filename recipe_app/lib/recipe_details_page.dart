import 'package:flutter/material.dart';
import 'Classes/Recipe.dart'; // Adjust the import path if needed

class RecipeDetailsPage extends StatelessWidget {
  final String recipe1;
  final String recipe2;
  final Recipe combinedRecipe;

  const RecipeDetailsPage({
    super.key,
    required this.recipe1,
    required this.recipe2,
    required this.combinedRecipe,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left AppBar-style section
          Container(
            width: 200,
            color: const Color.fromRGBO(100, 33, 27, 1), // Match the AppBar color
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Combined Recipe Title",
                    style: TextStyle(
                      color: Color.fromRGBO(218, 176, 115, 1),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
              
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "CookTime:  ${combinedRecipe.getTime()}",
                    style: const TextStyle(color: Color.fromRGBO(218, 176, 115, 1)),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    "Recipe 1: $recipe1",
                    style: const TextStyle(color: Color.fromRGBO(218, 176, 115, 1)),
                  ),
                  Text(
                    "Recipe 2: $recipe2",
                    style: const TextStyle(color: Color.fromRGBO(218, 176, 115, 1)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Ingredients",
                    style: TextStyle(
                      color: Color.fromRGBO(218, 176, 115, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    combinedRecipe.getIngredients().join("\n"), // Replace with actual ingredients
                    style: const TextStyle(color: Color.fromRGBO(218, 176, 115, 1)),
                  ),
                ],
              ),
            ),
          ),
          // Right main section
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 219, 198, 166),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Directions",
                      style: TextStyle(
                        color: Color.fromRGBO(100, 33, 27, 1),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      combinedRecipe.getSteps().join("\n"), // Replace with actual steps
                      style: const TextStyle(color: Color.fromRGBO(100, 33, 27, 1)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
