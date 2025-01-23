import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveSearchHistory(String searchQuery) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userRef.collection('searchHistory').add({
        'query': searchQuery,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  } catch (e) {
    print("Error saving search history: $e");
  }
}

Future<List<String>> getLast3Searches() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final snapshot = await userRef
          .collection('searchHistory')
          .orderBy('timestamp', descending: true)
          .limit(3)
          .get();

      return snapshot.docs.map((doc) => doc['query'] as String).toList();
    }
    return [];
  } catch (e) {
    print("Error fetching search history: $e");
    return [];
  }
}
