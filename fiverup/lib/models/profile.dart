class Profile {
  final String id;
  final String name;
  final String profession;
  final String about;
  final String imageUrl;
  final String avatarUrl;
  final Map<String, dynamic> icons;
  final List<String>? skills;

  Profile({
    required this.id,
    required this.name,
    required this.profession,
    required this.about,
    required this.imageUrl,
    required this.avatarUrl,
    required this.icons,
    this.skills,
  });

  factory Profile.fromFirestore(String id, Map<String, dynamic> data) {
    return Profile(
      id: id,
      name: data['name'] ?? '',
      profession: data['profession'] ?? '',
      about: data['about'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      icons: data['icons'] ?? {},
      skills: data['skills'] != null ? List<String>.from(data['skills']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profession': profession,
      'about': about,
      'imageUrl': imageUrl,
      'avatarUrl': avatarUrl,
      'icons': icons,
      'skills': skills ?? [],
    };
  }
}
