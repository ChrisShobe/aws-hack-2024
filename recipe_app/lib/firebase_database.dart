import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Helper method to preprocess input list
  List<String> preprocessInput(List<String> inputList) {
    return inputList
        .map((entry) => entry
            .toLowerCase() // Convert to lowercase
            .replaceAll(RegExp(r'[^a-z0-9\s]'), '') // Remove non-alphanumeric characters
            .trim()) // Remove leading/trailing whitespace
        .toList()
        ..sort(); // Sort the list
  }

  // Helper method to convert list to a concatenated string for easier matching
  String listToString(List<String?> list) {
    return list.join(' ').toLowerCase(); // Concatenate and convert to lowercase
  }

  // Method to write new data (for main.dart functionality)
  Future<void> writeDataToFirestore(List<String> userInput, String responseBody) async {
    try {
      // Preprocess the userInput list
      userInput = preprocessInput(userInput);

      var inputString = listToString(userInput); // Concatenate the list into a string

      // Debugging: Check the formatted inputString
      print("Formatted Input String to be stored: $inputString");

      var data = {
        'Input': inputString,
        'Output': responseBody,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('knowledgeBase').add(data);

      print('Data successfully written to Firestore.');
    } catch (e) {
      print('Error writing to Firestore: $e');
    }
  }

  // Method to write or update data (for RecipeDetailsPage functionality)
  Future<void> writeOrUpdateData(List<String> userInput, String responseBody, int score) async {
    try {
      // Preprocess the userInput list
      userInput = preprocessInput(userInput);

      String inputString = listToString(userInput); // Concatenate the list into a string

      // Debugging: Check the formatted inputString
      print("Formatted Input String for Update: $inputString");

      // Query Firestore for documents with the same Input
      QuerySnapshot querySnapshot = await _firestore
          .collection('knowledgeBase')
          .where('Input', isEqualTo: inputString)
          .get();

      print("Query result: ${querySnapshot.docs.length} document(s) found");

      if (querySnapshot.docs.isNotEmpty) {
        // Update the first matching document's score
        DocumentSnapshot existingDoc = querySnapshot.docs.first;
        await _firestore
            .collection('knowledgeBase')
            .doc(existingDoc.id)
            .update({'score': score});
        print('Score updated for existing document.');
      } else {
        // Add a new document if no matching document is found
        var data = {
          'Input': inputString,
          'Output': responseBody,
          'score': score,
          'timestamp': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('knowledgeBase').add(data);
        print('New document added to Firestore.');
      }
    } catch (e) {
      print('Error in writeOrUpdateData: $e');
    }
  }
  Future<void> removeData(List<String?> recipes) async {
    try {
      // Assume you have a method to access the database reference for the recipes
      CollectionReference recipesCollection = FirebaseFirestore.instance.collection('recipes');

      // Create a document reference for the recipe entry
      DocumentReference recipeDoc = recipesCollection.doc(recipes.join("_"));

      // Delete the document
      await recipeDoc.delete();
      print("Old recipe removed from database.");
    } catch (e) {
      print('Error removing recipe data: $e');
    }
  }
  // Method to check if recipes exist in the database
  Future<bool> checkRecipesExist(List<String?> recipeNames) async {
    try {
      // Ensure the list is not null or empty
      if (recipeNames.isEmpty) {
        print('No recipe names provided.');
        return false;
      }

      // Preprocess the recipeNames list
      recipeNames = preprocessInput(recipeNames.whereType<String>().toList());

      String inputString = listToString(recipeNames); // Concatenate the list into a string

      // Debugging: Check the formatted inputString
      print("Formatted Input String for Query: $inputString");

      // Query Firestore for documents where Input matches the concatenated string
      var query = _firestore
        .collection('knowledgeBase')
        .where('Input', isEqualTo: inputString);

      // Fetch a single snapshot of the query results
      QuerySnapshot querySnapshot = await query.get();

      // Debugging: Log the number of documents found
      print("Query result: ${querySnapshot.docs.length} document(s) found");

      // Check if any documents exist
      if (querySnapshot.docs.isNotEmpty) {
        print('One or more recipes exist in the database.');
        return true;
      } else {
        print('None of the recipes exist in the database.');
        return false;
      }
    } catch (e) {
      print('Error checking recipes existence: $e');
      return false;
    }
  }
  // Method to get the score for a specific input
  Future<int?> getScore(List<String> userInput) async {
    try {
      // Preprocess the userInput list
      userInput = preprocessInput(userInput);

      String inputString = listToString(userInput); // Concatenate the list into a string

      // Debugging: Check the formatted inputString
      print("Formatted Input String for Score Query: $inputString");

      // Query Firestore for documents with the same Input
      QuerySnapshot querySnapshot = await _firestore
          .collection('knowledgeBase')
          .where('Input', isEqualTo: inputString)
          .get();

      // Debugging: Log the number of documents found
      print("Query result: ${querySnapshot.docs.length} document(s) found");

      // Check if the document exists
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        // Retrieve the score from the document
        int? score = doc['score'];

        print('Retrieved score: $score');
        return score;
      } else {
        print('No matching entry found in the database.');
        return null; // Return null if no matching entry is found
      }
    } catch (e) {
      print('Error retrieving score: $e');
      return null; // Return null in case of error
    }
  }
  // Method to get the output for a specific input
Future<String?> getOutput(List<String> userInput) async {
  try {
    // Preprocess the userInput list
    userInput = preprocessInput(userInput);

    String inputString = listToString(userInput); // Concatenate the list into a string

    // Debugging: Check the formatted inputString
    print("Formatted Input String for Output Query: $inputString");

    // Query Firestore for documents with the same Input
    QuerySnapshot querySnapshot = await _firestore
        .collection('knowledgeBase')
        .where('Input', isEqualTo: inputString)
        .get();

    // Debugging: Log the number of documents found
    print("Query result: ${querySnapshot.docs.length} document(s) found");

    // Check if the document exists
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      // Retrieve the output from the document
      String? output = doc['Output'];

      print('Retrieved output: $output');
      return output;
    } else {
      print('No matching entry found in the database.');
      return null; // Return null if no matching entry is found
    }
  } catch (e) {
    print('Error retrieving output: $e');
    return null; // Return null in case of error
  }
}


}
