import 'Classes/Recipe.dart';
import 'recipe_details_page.dart';
import 'SendInfoToApi.dart';
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
  final recipe1String = _recipe1Controller.text.trim();
  final recipe2String = _recipe2Controller.text.trim();

  if (recipe1String.isEmpty || recipe2String.isEmpty) {
    print("Please enter both recipes.");
    return;
  }

  Recipe? recipe1 = await fetchRecipe(recipe1String);
  if (recipe1 == null) {
    print("Recipe 1 not found");
    return;
  }

  await delayBetweenRequests();

  Recipe? recipe2 = await fetchRecipe(recipe2String);
  if (recipe2 == null) {
    print("Recipe 2 not found");
    return;
  }

  // Call API and get response
  String apiResponse = await sendToApi(recipe1, recipe2);

  // Save the user inputs and API response to Firebase Realtime Database
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
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(100, 33, 27, 1),
        title: Text(widget.title, style: const TextStyle(color: Color.fromRGBO(218, 176, 115, 1))),
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
