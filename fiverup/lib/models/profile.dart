class Profile {
  final String id;
  final String name;
  final String profession;
  final String about;
  final String imageUrl;
  final String avatarUrl;
  final Map<String, dynamic> icons; // Added icons field

  Profile({
    required this.id,
    required this.name,
    required this.profession,
    required this.about,
    required this.imageUrl,
    required this.avatarUrl,
    required this.icons, // Add icons parameter
  });

  factory Profile.fromFirestore(String id, Map<String, dynamic> data) {
    return Profile(
      id: id,
      name: data['name'] ?? '',
      profession: data['profession'] ?? '',
      about: data['about'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      icons: data['icons'] ?? {}, // Handle icons field
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profession': profession,
      'about': about,
      'imageUrl': imageUrl,
      'avatarUrl': avatarUrl,
      'icons': icons, // Include icons in serialization
    };
  }
}
