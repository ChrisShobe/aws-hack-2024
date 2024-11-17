import 'package:flutter/material.dart';
import 'Classes/Recipe.dart'; 

class RecipeDetailsPage extends StatelessWidget {
  final String recipe1;
  final String recipe2;
  final Recipe recipe3; // This will be the recipe with merged ingredients and steps
  final TextEditingController _moreInfo = TextEditingController();

  RecipeDetailsPage({
    super.key,
    required this.recipe1,
    required this.recipe2,
    required this.recipe3
  });

  void _onPressed(){
    final moreinfo = _moreInfo.text;
    print(moreinfo);
  }

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
              child: SingleChildScrollView(
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
                      "CookTime:  ${recipe3.getTime()}",  // Use recipe3 for time
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
                      recipe3.getIngredients().join("\n"),  // Print ingredients of recipe3
                      style: const TextStyle(color: Color.fromRGBO(218, 176, 115, 1)),
                    ),
                    // const SizedBox(height: 16),
                    // const Text(
                    //   "Steps",
                    //   style: TextStyle(
                    //     color: Color.fromRGBO(218, 176, 115, 1),
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // const SizedBox(height: 8),
                    // Text(
                    //   recipe3.getSteps().join("\n"),  // Print steps of recipe3
                    //   style: const TextStyle(color: Color.fromRGBO(218, 176, 115, 1)),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          // Right main section
          Expanded(
            child: Container(
              height: 1000,
              color: const Color.fromARGB(255, 219, 198, 166),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "API Response",
                        style: TextStyle(
                          color: Color.fromRGBO(100, 33, 27, 1),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          recipe3.getSteps().join("\n"), // Replace API response with Recipe 3 details
                          style: const TextStyle(color: Color.fromRGBO(100, 33, 27, 1)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: TextField(
                          controller: _moreInfo,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Recipe 2',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: SizedBox(
                          height: 50,
                          width: 1000,
                          child: ElevatedButton(
                            onPressed: _onPressed,
                            child: const Text('Generate Recipe'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
