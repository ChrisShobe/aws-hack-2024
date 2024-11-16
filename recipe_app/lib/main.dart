import 'package:flutter/material.dart';
import 'spoonacular.dart';
import 'Classes/Recipe.dart';
import 'recipe_details_page.dart';


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

  // Fetch the first recipe
  Recipe? recipe1 = await fetchRecipe(recipe1String);
  if (recipe1 == null) {
    print("Recipe 1 not found");
    return;
  }

  // Add a delay between the two requests
  await delayBetweenRequests();

  // Fetch the second recipe
  Recipe? recipe2 = await fetchRecipe(recipe2String);
  if (recipe2 == null) {
    // Handle the case where recipe2 is null
    print("Recipe 2 not found");
    return;
  }

  // Merge the two recipes
  Recipe recipe3 = recipe1.merge(recipe1, recipe2);
  recipe3.printSteps();

  // Navigate to the recipe details page with a custom transition
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 700), // Set transition duration
      pageBuilder: (context, animation, secondaryAnimation) {
        return RecipeDetailsPage(
          recipe1: recipe1String,
          recipe2: recipe2String,
          combinedRecipe: recipe3,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide in from the right
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );
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
