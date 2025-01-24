import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<String>> fetchUserEmails() async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print("No user authenticated.");
      return [];
    }

    // Log current user ID for debugging
    print("Current user UID: ${currentUser.uid}");

    // Fetch users' emails from the 'users' collection
    final querySnapshot = await FirebaseFirestore.instance.collection('users').get();

    // Log the number of documents fetched
    print("Fetched ${querySnapshot.docs.length} documents from 'users' collection.");

    // If no documents are found, return an empty list
    if (querySnapshot.docs.isEmpty) {
      print("No users found in the 'users' collection.");
      return [];
    }

    // Map the email from each document and return it as a list
    final emails = querySnapshot.docs.map((doc) {
      print("Found email: ${doc['email']}");
      return doc['email'] as String;
    }).toList();

    return emails;
  } catch (e) {
    print("Error fetching user emails: $e");
    return [];
  }
}
