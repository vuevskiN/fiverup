import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/profile.dart';

class ProfileService extends ChangeNotifier {  // Extend ChangeNotifier
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference profilesCollection = FirebaseFirestore.instance.collection('profiles');


  Profile? _profile;
  Profile? get profile => _profile;

  Future<List<Profile>> getAllProfiles() async {
    try {
      // Fetch all documents in the collection
      var profilesSnapshot = await profilesCollection.get();

      // Map documents to Profile objects
      List<Profile> profiles = profilesSnapshot.docs.map((doc) {
        return Profile.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      return profiles;
    } catch (e) {
      print("Error fetching all profiles: $e");
      return []; // Return an empty list in case of an error
    }
  }

  Future<Profile?> getUserProfile(String userId) async {
    try {
      var profileSnapshot = await profilesCollection
          .where('userId', isEqualTo: userId)
          .get();

      if (profileSnapshot.docs.isNotEmpty) {
        var profileDoc = profileSnapshot.docs.first;
        _profile = Profile.fromFirestore(profileDoc.id, profileDoc.data() as Map<String, dynamic>);
        notifyListeners();  // Notify listeners when profile is fetched
        return _profile;  // Return profile
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
    return null;  // Return null if no profile is found
  }

  // Get profile by profile ID and return Profile? instead of void
  Future<Profile?> getProfileById(String profileId) async {
    try {
      var profileDoc = await profilesCollection.doc(profileId).get();

      if (profileDoc.exists) {
        _profile = Profile.fromFirestore(profileDoc.id, profileDoc.data() as Map<String, dynamic>);
        notifyListeners();  // Notify listeners when profile is fetched by ID
        return _profile;  // Return profile
      }
    } catch (e) {
      print("Error fetching profile by ID: $e");
    }
    return null;  // Return null if profile is not found or error occurs
  }

  Future<String?> getProfileByEmail(String email) async {
    try {
      var profileSnapshot = await profilesCollection
          .where('email', isEqualTo: email) // Filter by email
          .get();

      if (profileSnapshot.docs.isNotEmpty) {
        var profileDoc = profileSnapshot.docs.first;
        var profile = Profile.fromFirestore(profileDoc.id, profileDoc.data() as Map<String, dynamic>);

        // Return the avatarIcon field
        return profile.icons['avatarIcon'];
      }
    } catch (e) {
      print("Error fetching profile by email: $e");
    }
    return null; // Return null if no profile matches or an error occurs
  }



  // Update profile and notify listeners
  Future<void> updateProfile(String profileId, Profile updatedProfile) async {
    try {
      var profileDoc = await profilesCollection.doc(profileId).get();

      if (profileDoc.exists) {
        await profileDoc.reference.update({
          'name': updatedProfile.name,
          'profession': updatedProfile.profession,
          'about': updatedProfile.about,
          'imageUrl': updatedProfile.imageUrl,
          'avatarUrl': updatedProfile.avatarUrl,
          'icons': updatedProfile.icons,
        });
        _profile = updatedProfile;  // Update the profile state
        notifyListeners();  // Notify listeners after profile update
      } else {
        print("Profile not found for id: $profileId");
      }
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  Future<void> updateProfileIcon(String profileId, String iconName, String iconValue) async {
    try {
      var profileDoc = await profilesCollection.doc(profileId).get();

      if (profileDoc.exists) {
        await profileDoc.reference.update({
          'icons': {iconName: iconValue},  // Save the icon name as string (e.g., 'home', 'person')
        });
        // No need to fetch profile again as we're only updating one field
      } else {
        print("Profile not found for id: $profileId");
      }
    } catch (e) {
      print("Error updating profile icon: $e");
    }
  }


  // Remove profile icon and notify listeners
  Future<void> removeProfileIcon(String userId, String iconName) async {
    try {
      var profileSnapshot = await profilesCollection
          .where('userId', isEqualTo: userId)
          .get();

      if (profileSnapshot.docs.isNotEmpty) {
        var profileDoc = profileSnapshot.docs.first;
        var icons = Map<String, dynamic>.from(profileDoc['icons'] ?? {});

        // Remove the specific icon
        icons.remove(iconName);

        await profileDoc.reference.update({'icons': icons});

        // Update the profile state and notify listeners
        _profile = Profile.fromFirestore(profileDoc.id, profileDoc.data() as Map<String, dynamic>);
        notifyListeners();
      }
    } catch (e) {
      print("Error removing profile icon: $e");
    }
  }

  // Print all profiles (optional for debugging)
  Future<void> printAllProfilesWithIcons() async {
    try {
      var profilesSnapshot = await profilesCollection.get();

      for (var doc in profilesSnapshot.docs) {
        print("Profile ID: ${doc.id}, Data: ${doc.data()}");
      }
    } catch (e) {
      print("Error fetching profiles: $e");
    }
  }
}
