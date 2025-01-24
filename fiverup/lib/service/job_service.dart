import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/job.dart';

class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addJob(Job job) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('jobs').add({
        'title': job.title,
        'description': job.description,
        'hourlyRate': job.hourlyRate,
        'createdBy': user.email,
        'seeking': job.seeking,
        'offering': job.offering,
        'dueDate': job.dueDate, // Save as Firestore Timestamp
      });
    }
  }


  Future<void> updateJob(String jobId, Job updatedJob) async {
    await _firestore.collection('jobs').doc(jobId).update({
      'title': updatedJob.title,
      'description': updatedJob.description,
      'hourlyRate': updatedJob.hourlyRate,
      'seeking': updatedJob.seeking,
      'offering': updatedJob.offering,
      'dueDate': updatedJob.dueDate, // Update Firestore Timestamp
    });
  }


  // Delete a job
  Future<void> deleteJob(String jobId) async {
    await _firestore.collection('jobs').doc(jobId).delete();
  }

  Stream<List<Job>> getAllJobs() {
    return _firestore.collection('jobs').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Job.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }


  // Fetch a single job by its ID
  Future<Job?> getJobById(String jobId) async {
    DocumentSnapshot doc = await _firestore.collection('jobs').doc(jobId).get();
    if (doc.exists) {
      return Job.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> addCommentToJob(String jobId, String commentText, String userEmail) async {
    try {
      final comment = {
        'userEmail': userEmail,
        'comment': commentText,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Add comment to the job's 'comments' field in Firestore
      await _firestore.collection('jobs').doc(jobId).update({
        'comments': FieldValue.arrayUnion([comment]), // Use arrayUnion to add to the list
      });
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }


  final CollectionReference jobsCollection =
  FirebaseFirestore.instance.collection('jobs');


}
