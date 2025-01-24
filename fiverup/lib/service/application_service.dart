import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to apply for a job
  Future<void> applyForJob(String jobId, String offeredBy) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user authenticated.");
      }

      // Save the application
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

  // Method to fetch applications for a job
  Future<List<Map<String, dynamic>>> fetchApplications(String jobId) async {
    try {
      final querySnapshot = await _firestore
          .collection('applications')
          .where('jobId', isEqualTo: jobId)
          .get();

      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error fetching applications: $e");
      return [];
    }
  }
}
