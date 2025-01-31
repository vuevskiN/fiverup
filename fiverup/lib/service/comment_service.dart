import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<String>> fetchFilteredUserEmails() async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        return [];
      }

      final querySnapshot = await _firestore.collection('users').get();
      final allEmails = querySnapshot.docs
          .map((doc) => doc['email'] as String)
          .toList();

      return allEmails.where((email) => email != currentUser.email).toList();
    } catch (e) {
      print("Error fetching user emails: $e");
      return [];
    }
  }

  Future<void> submitComment(String userEmail, String comment, double rating) async {
    try {
      await _firestore.collection('comments').add({
        'comment': comment,
        'userEmail': userEmail,
        'rating': rating,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error submitting comment: $e");
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getCommentsById() async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        return [];
      }

      final querySnapshot = await _firestore
          .collection('comments')
          // .where('userEmail', isEqualTo: currentUser.email)
          // .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error fetching comments: $e");
      return [];
    }
  }

