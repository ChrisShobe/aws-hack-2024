import 'package:flutter/material.dart';
import 'Classes/Recipe.dart';
import 'firebase_database.dart'; // Firebase service
import 'main.dart';
import 'dart:convert';

class RecipeDetailsPage extends StatefulWidget {
  final String recipe1;
  final String recipe2;
  final Recipe recipe3; // This will be the recipe with merged ingredients and steps

  // Constructor
  RecipeDetailsPage({
    super.key,
    required this.recipe1,
    required this.recipe2,
    required this.recipe3,
  });

  @override
  _RecipeDetailsPageState createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  final TextEditingController _moreInfo = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService(); // Firebase service instance

  // onPressed function to handle score submission
  void _onPressed() async {
  final moreInfo = _moreInfo.text.trim();
  List<String?> recipes = [widget.recipe1, widget.recipe2];

  // Validate the score input
  int? score = int.tryParse(moreInfo);
  if (score == null || score < 1 || score > 10) {
    print("Invalid score. Please enter a number between 1 and 10.");
    return;
  }
  print("Score submitted: $score");

  bool exists = await _firebaseService.checkRecipesExist(recipes);
  if (exists) {
    // Fetch the stored score from the database
    int? storedScore = await _firebaseService.getScore([widget.recipe1, widget.recipe2]);

    if (storedScore != null && storedScore < score) {
      // If the current score is better, delete the old entry and add the new one
      print("The current score is better than the stored score. Updating the recipe...");

      // Remove the old recipe from the database
      await _firebaseService.removeData([widget.recipe1, widget.recipe2]);

      // Add the new recipe to the database
      await _firebaseService.writeOrUpdateData([widget.recipe1, widget.recipe2], widget.recipe3.getSteps().join("\n"), score);

      // Trigger UI refresh to reflect updated recipe data
      setState(() {
        // Refresh the recipe data (if needed)
        widget.recipe3.setSteps(widget.recipe3.getSteps());
        widget.recipe3.setIngredients(widget.recipe3.getIngredients());
      });

    } 
    else {
      print("The current score is not better than the stored score.");
      
      // If the stored score is better, fetch and refresh the recipe data
      String? output = await _firebaseService.getOutput([widget.recipe1, widget.recipe2]);
      if (output != null) {
        // Split the output string into a list of steps
        List<String> stepsList = output.split('\n');
        widget.recipe3.setSteps(stepsList);

        // Trigger UI refresh to reflect updated recipe data
        setState(() {
          // Update the recipe3 object and refresh the UI
          widget.recipe3.setSteps(stepsList);
        });
      }
    }
  } else {
    // If the recipes don't exist, write new data
    await _firebaseService.writeOrUpdateData([widget.recipe1, widget.recipe2], widget.recipe3.getSteps().join("\n"), score);

    // Trigger UI refresh to reflect updated recipe data
    setState(() {
      // Refresh the recipe data (if needed)
      widget.recipe3.setSteps(widget.recipe3.getSteps());
      widget.recipe3.setIngredients(widget.recipe3.getIngredients());
    });
  }
}




  void parseRecipeJson(String? jsonData, Recipe recipe3) {
    try {
      if (jsonData != null) {
        var data = jsonDecode(jsonData);

        // Extract the message and received message
        String? receivedMessage = data['received_message'] ?? '';

        // Initialize empty lists for ingredients and instructions
        List<String> ingredientsList = [];
        List<String> instructionsList = [];

        bool readingIngredients = false;
        bool readingInstructions = false;

        if (receivedMessage!.isNotEmpty) {
          // Split the received message into lines
          List<String> lines = receivedMessage.split('\n');

          // Process each line
          for (var line in lines) {
            if (line.toLowerCase().contains('ingredients')) {
              readingIngredients = true;
              readingInstructions = false;
              continue;
            }

            if (line.toLowerCase().contains('steps') || 
                line.toLowerCase().contains('instructions') ||
                line.toLowerCase().contains('directions')) {
              readingIngredients = false;
              readingInstructions = true;
              continue;
            }

            if (readingIngredients) {
              ingredientsList.add(line.trim());
            }

            if (readingInstructions) {
              instructionsList.add(line.trim());
            }
          }
        }

        // Update the recipe3 object and refresh the UI
        setState(() {
          recipe3.setIngredients(ingredientsList);
          recipe3.setSteps(instructionsList);
        });

      }
    } catch (e) {
      print('Error parsing the recipe JSON: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left AppBar-style section
          Container(
            width: 200,
            color: const Color.fromRGBO(100, 33, 27, 1),
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
                      "CookTime:  ${widget.recipe3.getTime()}",
                      style: const TextStyle(color: Color.fromRGBO(218, 176, 115, 1)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Recipe 1: ${widget.recipe1}",
                      style: const TextStyle(color: Color.fromRGBO(218, 176, 115, 1)),
                    ),
                    Text(
                      "Recipe 2: ${widget.recipe2}",
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
                      widget.recipe3.getIngredients().join("\n"),
                      style: const TextStyle(color: Color.fromRGBO(218, 176, 115, 1)),
                    ),
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
                          widget.recipe3.getSteps().join("\n"),
                          style: const TextStyle(color: Color.fromRGBO(100, 33, 27, 1)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: TextField(
                          controller: _moreInfo,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Rating of the Recipe 1-10',
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
                            child: const Text('Submit Score'),
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
