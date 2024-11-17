import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to write new data (for main.dart functionality)
  Future<void> writeDataToFirestore(List<String> userInput, String responseBody) async {
    try {
      var data = {
        'Input': userInput,
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
      // Query Firestore for documents with the same Input
      QuerySnapshot querySnapshot = await _firestore
          .collection('knowledgeBase')
          .where('Input', isEqualTo: userInput)
          .get();

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
          'Input': userInput,
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
}
