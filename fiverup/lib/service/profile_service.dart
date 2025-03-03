import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/profile.dart';

class ProfileService extends ChangeNotifier {
  CollectionReference profilesCollection = FirebaseFirestore.instance.collection('profiles');


  Profile? _profile;
  Profile? get profile => _profile;

  Future<List<Profile>> getAllProfiles() async {
    try {
      var profilesSnapshot = await profilesCollection.get();

      List<Profile> profiles = profilesSnapshot.docs.map((doc) {
        return Profile.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      return profiles;
    } catch (e) {
      print("Error fetching all profiles: $e");
      return [];
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
        notifyListeners();
        return _profile;
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
    return null;
  }

  Future<Profile?> getProfileById(String profileId) async {
    try {
      var profileDoc = await profilesCollection.doc(profileId).get();

      if (profileDoc.exists) {
        _profile = Profile.fromFirestore(profileDoc.id, profileDoc.data() as Map<String, dynamic>);
        notifyListeners();
        return _profile;
      }
    } catch (e) {
      print("Error fetching profile by ID: $e");
    }
    return null;
  }

  Future<String?> getProfileByEmail(String email) async {
    try {
      var profileSnapshot = await profilesCollection
          .where('email', isEqualTo: email)
          .get();

      if (profileSnapshot.docs.isNotEmpty) {
        var profileDoc = profileSnapshot.docs.first;
        var profile = Profile.fromFirestore(profileDoc.id, profileDoc.data() as Map<String, dynamic>);

        return profileDoc.id;
      }
    } catch (e) {
      print("Error fetching profile by email: $e");
    }
    return null;
  }



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
          'skills' : updatedProfile.skills ?? []
        });
        _profile = updatedProfile;
        notifyListeners();
      } else {
        print("Profile not found for id: $profileId");
      }
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  Future<void> addProfile({
    required String userId,
    required String email,
    List<String>? skills,
  }) async {
    try {
      await profilesCollection.doc(userId).set({
        'userId': userId,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'name': '',
        'profession': '',
        'about': '',
        'imageUrl': '',
        'avatarUrl': '',
        'icons': {},
        'skills' : skills ?? []
      });
    } catch (e) {
      print("Error adding profile: $e");
    }
  }


  Future<void> updateProfileIcon(String profileId, String iconName, String iconValue) async {
    try {
      var profileDoc = await profilesCollection.doc(profileId).get();

      if (profileDoc.exists) {
        await profileDoc.reference.update({
          'icons': {iconName: iconValue},
        });

      } else {
        print("Profile not found for id: $profileId");
      }
    } catch (e) {
      print("Error updating profile icon: $e");
    }
  }


  Future<void> removeProfileIcon(String userId, String iconName) async {
    try {
      var profileSnapshot = await profilesCollection
          .where('userId', isEqualTo: userId)
          .get();

      if (profileSnapshot.docs.isNotEmpty) {
        var profileDoc = profileSnapshot.docs.first;
        var icons = Map<String, dynamic>.from(profileDoc['icons'] ?? {});

        icons.remove(iconName);

        await profileDoc.reference.update({'icons': icons});

        _profile = Profile.fromFirestore(profileDoc.id, profileDoc.data() as Map<String, dynamic>);
        notifyListeners();
      }
    } catch (e) {
      print("Error removing profile icon: $e");
    }
  }

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
