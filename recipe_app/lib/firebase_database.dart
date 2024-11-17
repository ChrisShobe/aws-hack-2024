import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  Future<void> writeResponseToFirebase(String responseBody) async {
    try {
      // Parse the response body if necessary
      var responseData = jsonDecode(responseBody);

      // Write the data to Firebase under a specific path
      await _database.child('apiResponses').push().set(responseData);

      print('Data successfully written to Firebase.');
    } catch (e) {
      print('Error writing to Firebase: $e');
    }
  }
}