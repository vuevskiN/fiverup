import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendNotification({
    required String senderEmail,
    required String receiverEmail,
    required String status,
  }) async {
    await _firestore.collection('notifications').add({
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getNotifications() {
    return _firestore
        .collection('notifications') // No filters applied here
        .orderBy('timestamp', descending: true) // Ordered by timestamp
        .snapshots()
        .map((snapshot) {
      print("Fetched ${snapshot.docs.length} notifications."); // Debugging line
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }


}
