import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/profile.dart';

class ProfileService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch a single profile by ID
  Future<Profile?> getProfileById(String profileId) async {
    DocumentSnapshot doc = await _firestore.collection('profiles').doc(profileId).get();
    if (doc.exists) {
      return Profile.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }


  // Add a new profile
  Future<void> addProfile(Profile profile) async {
    await _firestore.collection('profiles').add(profile.toMap());
    notifyListeners(); // Notify listeners after the profile is added
  }

  // Update an existing profile
  Future<void> updateProfile(String profileId, Profile updatedProfile) async {
    await _firestore.collection('profiles').doc(profileId).update(updatedProfile.toMap());
    notifyListeners(); // Notify listeners after the profile is updated
  }

  // Delete a profile
  Future<void> deleteProfile(String profileId) async {
    await _firestore.collection('profiles').doc(profileId).delete();
    notifyListeners(); // Notify listeners after the profile is deleted
  }

  // Fetch all profiles and stream them
  Stream<List<Profile>> getAllProfiles() {
    return _firestore.collection('profiles').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Profile.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
