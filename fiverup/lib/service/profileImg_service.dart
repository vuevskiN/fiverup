import 'package:cloud_firestore/cloud_firestore.dart';

class ImageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference imagesCollection = FirebaseFirestore.instance.collection('images');


  Future<String?> getUserProfileImage(String userId) async {
    try {
      var profileSnapshot = await _firestore
          .collection('profiles')
          .where('userId', isEqualTo: userId)
          .get();

      if (profileSnapshot.docs.isNotEmpty) {
        var profileDoc = profileSnapshot.docs.first;
        return profileDoc['imageUrl'];
      }
    } catch (e) {
      print("Error fetching profile image: $e");
    }
    return null;
  }

  Future<void> printAllImages() async {
    try {
      QuerySnapshot snapshot = await imagesCollection.get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          print("Document ID: ${doc.id}, Data: ${doc.data()}");
        }
      } else {
        print("No documents found in the images collection.");
      }
    } catch (e) {
      print("Error fetching all images: $e");
    }
  }

  Future<void> updateProfileImageIcon(String userId, String iconName) async {
    try {
      QuerySnapshot snapshot = await imagesCollection.where('userId', isEqualTo: userId).get();
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.update({'icon': iconName});
      } else {
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
