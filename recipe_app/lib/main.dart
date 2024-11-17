import 'Classes/Recipe.dart';
import 'recipe_details_page.dart';
import 'SendInfoToApi.dart';
import 'JsonParser.dart';
import 'dart:convert';

void main() {

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_database.dart'; // Firebase service file
import 'spoonacular.dart';

const FirebaseOptions MyFirebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyASRwMzIQGyydlOhqG1RVQTRtstNJthg-Y",
  authDomain: "recipeapp-85fd0.firebaseapp.com",
  databaseURL: "https://recipeapp-85fd0-default-rtdb.firebaseio.com",
  projectId: "recipeapp-85fd0",
  storageBucket: "recipeapp-85fd0.firebasestorage.app",
  messagingSenderId: "275828398349",
  appId: "1:275828398349:web:135b40b70b93807b8d3844",
  measurementId: "G-RNQMXSY33C"
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: MyFirebaseOptions);
  runApp(const MyApp());
}
void parseRecipeJson(String jsonData, Recipe recipe3) {
  try {
    // Parse the JSON string
    var data = jsonDecode(jsonData);

    // Extract the message and received message
    String receivedMessage = data['received_message'] ?? '';
    
    // Initialize empty lists for ingredients and instructions
    List<String> ingredientsList = [];
    List<String> instructionsList = [];

    // Flags to track whether we are reading ingredients or instructions
    bool readingIngredients = false;
    bool readingInstructions = false;

    // Split the received message into lines
    List<String> lines = receivedMessage.split('\n');

    // Process each line
    for (var line in lines) {
      // Check if the line contains a keyword for ingredients
      if (line.toLowerCase().contains('ingredients')) {
        readingIngredients = true;
        readingInstructions = false; // Stop reading instructions when we start ingredients
        continue;
      }
      
      // Check if the line contains a keyword for steps or instructions
      if (line.toLowerCase().contains('steps') || 
          line.toLowerCase().contains('instructions') ||
          line.toLowerCase().contains('directions')) {
        readingIngredients = false; // Stop reading ingredients when we start instructions
        readingInstructions = true;
        continue;
      }

      // If we're reading ingredients, add the line to the ingredients list
      if (readingIngredients) {
        ingredientsList.add(line.trim());
      }

      // If we're reading instructions, add the line to the instructions list
      if (readingInstructions) {
        instructionsList.add(line.trim());
      }
    }

    // Output the lists
    print('Ingredients List:');
    print(ingredientsList.join(', '));  // Joining the list with commas
    recipe3.setIngredients(ingredientsList);
    print('\nInstructions List:');
    recipe3.setSteps(instructionsList);
    instructionsList.forEach((step) => print(step));  // Printing each instruction

  } catch (e) {
    print('Error parsing the recipe JSON: $e');
  }
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
  await Future.delayed(Duration(seconds: 2)); // 2-second delay
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _recipe1Controller = TextEditingController();
  final TextEditingController _recipe2Controller = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService(); // Initialize Firebase service

  // This function is called when the button is pressed
  void _onPressed() async {
    final recipe1String = _recipe1Controller.text;
    final recipe2String = _recipe2Controller.text;

    // Fetch Recipe 1
    Recipe? recipe1 = await fetchRecipe(recipe1String);
    if (recipe1 == null) {
      print("Recipe 1 not found");
      return;
    }

    await delayBetweenRequests(); // Wait between requests

    // Fetch Recipe 2
    Recipe? recipe2 = await fetchRecipe(recipe2String);
    if (recipe2 == null) {
      print("Recipe 2 not found");
      return;
    }
    Recipe recipe3 = await recipe1.merge(recipe1, recipe2);
    String apiResponse = await sendToApi(recipe1, recipe2, null);
    String parsedData = await sendMessageToApi(apiResponse);
    print(parsedData);
    parseRecipeJson(parsedData, recipe3);


    // recipe3.printSteps();
    // print(apiResponse);

    // Process the ingredients and steps for the combined recipe
    //JsonParser.AppendToRecipe3(ingredientsJson, stepsJson, recipe3);

    // Navigate to the RecipeDetailsPage
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) {
          return RecipeDetailsPage(
            recipe1: recipe1String,
            recipe2: recipe2String,
            recipe3: recipe3,  // Pass the merged recipe as combinedRecipe
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
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

  await delayBetweenRequests();

  Recipe? recipe2 = await fetchRecipe(recipe2String);
  if (recipe2 == null) {
    print("Recipe 2 not found");
    return;
  }

  // Call API and get response
  String apiResponse = await sendToApi(recipe1, recipe2);

  // Save the user inputs and API response to Firestore
  await _firebaseService.writeDataToFirestore([recipe1String, recipe2String], apiResponse);

  // Merge recipes (if required by your application logic)
  Recipe recipe3 = await recipe1.merge(recipe1, recipe2);

  // Navigate to RecipeDetailsPage and pass the merged recipe and API response
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (context, animation, secondaryAnimation) {
        return RecipeDetailsPage(
          recipe1: recipe1String,
          recipe2: recipe2String,
          combinedRecipe: recipe3,
          apiResponse: apiResponse, // Pass the response to the details page
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
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
      appBar: PreferredSize(
  preferredSize: const Size.fromHeight(100), // Set the desired height here
  child: AppBar(
    backgroundColor: const Color.fromRGBO(100, 33, 27, 1),
    title: Row(
      children: [
        // Logo on the left
        Image.asset(
          'assets/logo.png', // Path to your logo in the assets folder
          height: 60, // Adjust the logo size to fit the taller AppBar
        ),
        const Spacer(), // Spacer to push the app name to the center
        // App name in the center
        Text(
          'Literally Cooking',
          style: const TextStyle(
            color: Color.fromRGBO(218, 176, 115, 1),
            fontSize: 40, // Adjust font size as needed
          ),
        ),
        const Spacer(), // Spacer to balance alignment
      ],
    ),
    centerTitle: false, // Turn off default centering for manual adjustments
  ),
),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
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
      ),
    );
  }
}
