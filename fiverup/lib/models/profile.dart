class Profile {
  final String id;
  final String name;
  final String profession;
  final String about;
  final String imageUrl;
  final String avatarUrl; // Add a separate avatar URL

  Profile({
    required this.id,
    required this.name,
    required this.profession,
    required this.about,
    required this.imageUrl,
    required this.avatarUrl, // Include avatar URL
  });

  // Factory method to create a Profile from Firestore data
  factory Profile.fromFirestore(String id, Map<String, dynamic> data) {
    return Profile(
      id: id,
      name: data['name'] ?? '',
      profession: data['profession'] ?? '',
      about: data['about'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '', // Include avatar URL
    );
  }

  // Convert a Profile to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profession': profession,
      'about': about,
      'imageUrl': imageUrl,
      'avatarUrl': avatarUrl, // Include avatar URL
    };
  }
}
