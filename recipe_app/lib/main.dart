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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _recipe1Controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Recipe 1',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _recipe2Controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Recipe 2',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _onPressed,
                child: const Text('Generate Recipe'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
