import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> writeDataToFirestore(List<String> userInput, String responseBody) async {
    try {
      // Create a structured JSON object to match your Firestore setup
      var data = {
        'Input': userInput, // The list of inputs (e.g., Recipe 1 and Recipe 2)
        'Output': responseBody, // The API response
      };

      // Write the data to Firestore under the "knowledgeBase" collection
      await _firestore.collection('knowledgeBase').add(data);

      print('Data successfully written to Firestore.');
    } catch (e) {
      print('Error writing to Firestore: $e');
    }
  }
}
