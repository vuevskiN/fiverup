import 'package:flutter/material.dart';

import '../filter/search_screen.dart';

// 1. Create the Popular model
class Popular {
  final String name;
  final IconData icon;

  Popular({required this.name, required this.icon});
}

// 2. A service to get the popular items (simulating it here with a list)
class PopularService {
  static List<Popular> getPopularItems() {
    return [
      Popular(
        name: 'Software Developer',
        icon: Icons.computer, // Using the computer icon for Software Developer
      ),
      Popular(
        name: 'Graphic Designer',
        icon: Icons.design_services, // Using the design services icon for Graphic Designer
      ),
      Popular(
        name: 'Music Producer',
        icon: Icons.music_note, // Using the music note icon for Music Producer
      ),
      Popular(
        name: 'Content Writer',
        icon: Icons.create, // Using the create icon for Content Writer
      ),
      Popular(
        name: 'Data Analyst',
        icon: Icons.analytics, // Using the analytics icon for Data Analyst
      ),
      Popular(
        name: 'Consultant',
        icon: Icons.business, // Using the business icon for Consultant
      ),
    ];
  }
}

class PopularSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch the list of popular items from the service
    List<Popular> popularItems = PopularService.getPopularItems();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 61),
            child: Text(
              'Popular Job Seekers/Offerings',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0x40414569),
                letterSpacing: -0.9,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 150, // Height of the popular row
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularItems.length,
              itemBuilder: (context, index) {
                return PopularTile(popular: popularItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 3. Tile widget to display each popular item
// 3. Tile widget to display each popular item
class PopularTile extends StatelessWidget {
  final Popular popular;

  PopularTile({required this.popular});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the SearchScreen with the name of the clicked popular item as the search query
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(searchQuery: popular.name),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 16), // Space between tiles
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              popular.icon,
              size: 50, // Set icon size
              color: Colors.black,
            ),
            SizedBox(height: 10),
            Text(
              popular.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0x22232325),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

