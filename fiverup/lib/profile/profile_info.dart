import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../service/profileImg_service.dart';

class ProfileInfoScreen extends StatefulWidget {
  final Profile profile;
  final ImageService profileImgService = ImageService();

  ProfileInfoScreen({Key? key, required this.profile}) : super(key: key);

  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  // List of animal icons
  final List<IconData> animalIcons = [
    Icons.local_cafe_rounded, // Dog
    Icons.bug_report,  // Cat
    Icons.local_florist,  // Cow
    Icons.apple, // Horse
    Icons.directions_bike, // Sheep
  ];

  IconData _selectedIcon = Icons.person; // Default icon
  String? _storedIconName; // Name of the icon from Firestore

  // Fetch the profile image icon from Firestore
  Future<void> _fetchProfileImageIcon() async {
    try {
      String? iconName = await widget.profileImgService.getUserProfileImage(widget.profile.name);
      if (iconName != null && iconName.isNotEmpty) {
        // Map the stored icon name to the correct IconData
        _selectedIcon = _getIconFromString(iconName);
      } else {
        _selectedIcon = Icons.person; // Default icon
      }
      setState(() {});
    } catch (e) {
      print('Failed to fetch profile image: $e');
    }
  }

  // Helper method to map icon name string to IconData
  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'local_cafe_rounded':
        return Icons.local_cafe_rounded;
      case 'bug_report':
        return Icons.bug_report;
      case 'local_florist':
        return Icons.local_florist;
      case 'apple':
        return Icons.apple;
      case 'directions_bike':
        return Icons.directions_bike;
      default:
        return Icons.person; // Default icon
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileImageIcon(); // Fetch the profile icon when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Main avatar
        CircleAvatar(
          radius: 50,
          child: Icon(
            _selectedIcon,
            size: 50,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${widget.profile.name}',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 16),

        // Display animal icons below the avatar
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: animalIcons.map((icon) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIcon = icon; // Update the selected icon when clicked
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(
                    icon,
                    size: 30,
                    color: _selectedIcon == icon ? Colors.blue : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Update button
        ElevatedButton(
          onPressed: () {
            _updateProfileImage(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B263B),
          ),
          child: const Text(
            'Update Profile Image',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  // Method to update the profile image to the selected animal icon
  Future<void> _updateProfileImage(BuildContext context) async {
    try {
      String iconName = _getIconString(_selectedIcon); // Convert IconData to string

      // Update the profile image with the selected icon (store in Firestore)
      await widget.profileImgService.updateProfileImageIcon(widget.profile.name, iconName);

      // Refresh the UI
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile image: $e')),
      );
    }
  }

  // Helper method to map IconData to string
  String _getIconString(IconData icon) {
    switch (icon) {
      case Icons.local_cafe_rounded:
        return 'local_cafe_rounded';
      case Icons.bug_report:
        return 'bug_report';
      case Icons.local_florist:
        return 'local_florist';
      case Icons.apple:
        return 'apple';
      case Icons.directions_bike:
        return 'directions_bike';
      default:
        return 'person'; // Default icon
    }
  }
}
