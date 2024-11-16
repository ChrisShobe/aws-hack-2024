import 'package:flutter/material.dart';
import 'spoonacular.dart';
import 'Classes/Recipe.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(100, 33, 27, 1)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Recipe App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<void> delayBetweenRequests() async {
  await Future.delayed(Duration(seconds: 5)); // 5-second delay
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _recipe1Controller = TextEditingController();
  final TextEditingController _recipe2Controller = TextEditingController();

  // This function is called when the button is pressed
  void _onPressed() async {
    // Retrieve text from the controllers
    final recipe1String = _recipe1Controller.text;
    final recipe2String = _recipe2Controller.text;
    Recipe? recipe1 = await fetchRecipe(recipe1String);
    if (recipe1 == null) {
      print("Recipe 1 not found");
      return;
    }
    await delayBetweenRequests();
    Recipe? recipe2 = await fetchRecipe(recipe2String);
    if (recipe2 == null) {
      // Handle the case where recipe2 is null
      print("Recipe 2 not found");
      return;
    }
    Recipe recipe3;
    recipe3 = recipe1.merge(recipe1, recipe2);
    recipe3.printSteps(); 
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 198, 166),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(100, 33, 27, 1),
        title: Text(widget.title, style: const TextStyle(color: Color.fromRGBO(218, 176, 115, 1))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: RichText(
                text: const TextSpan(
                  text: "Please Type in the recipes you would like",
                  style: TextStyle(fontSize: 24),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: TextField(
                controller: _recipe1Controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Recipe 1',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: TextField(
                controller: _recipe2Controller,
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
    );
  }
}

class RecipeDetailsPage extends StatelessWidget {
  final String recipe1;
  final String recipe2;

  const RecipeDetailsPage({
    super.key,
    required this.recipe1,
    required this.recipe2,
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
                  const Text(
                    "- Ingredient 1\n- Ingredient 2\n- Ingredient 3",
                    style: TextStyle(color: Color.fromRGBO(218, 176, 115, 1)),
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
                    const Text(
                      "1. Step 1\n2. Step 2\n3. Step 3",
                      style: TextStyle(color: Color.fromRGBO(100, 33, 27, 1)),
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
