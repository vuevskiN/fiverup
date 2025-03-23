import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../models/applicationHistory.dart';

class ApplicationHistoryService {
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;

  Future<void> logApplicationDecision(
      String applicantEmail,
      String status,
      firestore.Timestamp appliedAt,
      String? offeredBy
      ) async {
    await _firestore.collection('application_history').add({
      'applicantEmail': applicantEmail,
      'status': status,
      'appliedAt': appliedAt,
      'decisionAt': firestore.Timestamp.now(),
      'offeredBy': offeredBy,
    });
  }

  Stream<List<ApplicationHistory>> fetchApplicationHistory(
      String loggedInUserEmail) {
    return _firestore.collection('application_history').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ApplicationHistory.fromMap(doc.data(), doc.id);
      }).where((history) => history.offeredBy == loggedInUserEmail).toList();
    });
        }



  Future<void> deleteApplicationHistory(String id) async {
    await _firestore.collection('application_history').doc(id).delete();
  }
}