import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employerPayment.dart';

class EmployerPaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = "employer_payments";

  Future<void> addPayment(EmployerPayment payment) async {
    await _firestore.collection(collectionName).doc(payment.id).set(payment.toMap());
  }

  Future<void> deletePayment(String paymentId) async {
    await _firestore.collection(collectionName).doc(paymentId).delete();
  }

  Stream<List<EmployerPayment>> getPaymentsForEmployer(String employerId) {
    return _firestore
        .collection(collectionName)
        .where('employerId', isEqualTo: employerId) // Filter by employer
        .orderBy('timestamp', descending: true) // Sort latest first
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => EmployerPayment.fromMap(doc.data(), doc.id)).toList());
  }
}
