import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/notification_service.dart';

class ApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();

  Future<void> applyForJob(String jobId, String appliciantEmail, double price, String title) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user authenticated.");
      }

      await _firestore.collection('applications').add({
        'jobId': jobId,
        'offeredBy': appliciantEmail,
        'applicantEmail': currentUser.email,
        'appliedAt': Timestamp.now(),
        'title': title,
        'price': price,
        'status': 'pending'
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

      if (status == 'rejected') {
        await deleteApplicationById(applicationId);
      }
    } catch (e) {
      print("Error processing application: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchApplications(String jobId) async {
    try {
      final querySnapshot = await _firestore
          .collection('applications')
          .where('jobId', isEqualTo: jobId)
        .where('status', isEqualTo: 'pending')
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

  Future<List<Map<String, dynamic>>> fetchUserApplications() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user authenticated.");
      }

      final querySnapshot = await _firestore
          .collection('applications')
          .where('offeredBy', isEqualTo: currentUser.email)
          .where('status', isEqualTo: 'pending')
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching user's applications: $e");
      return [];
    }
  }


  Future<List<Map<String, dynamic>>> fetchApplicationsForUser() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      print("current email: ${currentUser}");
      if (currentUser == null) {
        throw Exception("No user authenticated.");
      }

      final querySnapshot = await _firestore
          .collection('applications')
          .where('offeredBy', isEqualTo: currentUser.email)
        //  .where('status', isEqualTo: 'pending')
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching applications: $e");
      return [];
    }
  }


  Future<List<Map<String, dynamic>>> fetchJobApplications(String jobId) async {
    try {
      final snapshot = await _firestore
          .collection('applications')
          .where('jobId', isEqualTo: jobId)
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error fetching applications: $e");
      return [];
    }
  }
}
