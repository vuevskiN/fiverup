import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/notification_service.dart';

class ApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();

  Future<void> applyForJob(String jobId, String offeredBy) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user authenticated.");
      }

      await _firestore.collection('applications').add({
        'jobId': jobId,
        'offeredBy': offeredBy,
        'applicantEmail': currentUser.email,
        'appliedAt': Timestamp.now(),
      });

      print("Application submitted successfully.");
    } catch (e) {
      print("Error applying for job: $e");
    }
  }

  Future<void> deleteApplicationById(String applicationId) async {
    try {
      await _firestore.collection('applications').doc(applicationId).delete();
      print("Application deleted successfully.");
    } catch (e) {
      print("Error deleting application: $e");
    }
  }

  Future<void> processApplication(
      String applicantEmail, String status, String applicationId) async {
    try {
      await _notificationService.sendNotification(
        senderEmail: FirebaseAuth.instance.currentUser!.email!,
        receiverEmail: applicantEmail,
        status: status,
      );

      await deleteApplicationById(applicationId);
    } catch (e) {
      print("Error processing application: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchApplications(String jobId) async {
    try {
      final querySnapshot = await _firestore
          .collection('applications')
          .where('jobId', isEqualTo: jobId)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching applications: $e");
      return [];
    }
  }
}
