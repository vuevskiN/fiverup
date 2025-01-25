import 'package:cloud_firestore/cloud_firestore.dart';

class ImageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference for images
  CollectionReference imagesCollection = FirebaseFirestore.instance.collection('images');

  // Fetch the profile image icon for a specific user
  Future<String?> getUserProfileImage(String userId) async {
    try {
      // Fetch the profile image icon based on the userId (name)
      QuerySnapshot snapshot = await imagesCollection.where('userId', isEqualTo: userId).get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first['icon']; // Return the icon name (string)
      }
    } catch (e) {
      print("Error fetching profile image: $e");
    }
    return null;
  }

  // Update the profile image icon in Firestore for a specific user
  Future<void> updateProfileImageIcon(String userId, String iconName) async {
    try {
      // Update the user's profile image icon in Firestore
      QuerySnapshot snapshot = await imagesCollection.where('userId', isEqualTo: userId).get();
      if (snapshot.docs.isNotEmpty) {
        // Update the document if it exists
        await snapshot.docs.first.reference.update({'icon': iconName});
      } else {
        // If no document exists, create a new one
        await imagesCollection.add({
          'userId': userId,
          'icon': iconName,
        });
      }
    } catch (e) {
      print("Error updating profile image: $e");
    }
  }
}
