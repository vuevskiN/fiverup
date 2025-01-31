import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For modern fonts
import '../filter/search_screen.dart';


class PopularSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Popular> popularItems = PopularService.getPopularItems();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Popular Job Seekers/Offerings',
              style: GoogleFonts.poppins(
                fontSize: 22, // Adjusted to fit into one line
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: 6, // Limit to 6 items for 2 rows of 3 cards each
            itemBuilder: (context, index) {
              return PopularTile(popular: popularItems[index]);
            },
          ),
        ],
      ),
    );
  }
}

class PopularTile extends StatelessWidget {
  final Popular popular;

  PopularTile({required this.popular});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(searchQuery: popular.name),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 6, offset: Offset(0, 2))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8), // Reduced padding for smaller size
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                popular.icon,
                size: 35, // Further reduced icon size for a smaller card
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8), // Reduced space between icon and text
            Text(
              popular.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12, // Smaller font size
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Popular {
  final String name;
  final IconData icon;

  Popular({required this.name, required this.icon});
}

class PopularService {
  static List<Popular> getPopularItems() {
    return [
      Popular(
        name: 'Software Developer',
        icon: Icons.computer,
      ),
      Popular(
        name: 'Graphic Designer',
        icon: Icons.design_services,
      ),
      Popular(
        name: 'Music Producer',
        icon: Icons.music_note,
      ),
      Popular(
        name: 'Content Writer',
        icon: Icons.create,
      ),
      Popular(
        name: 'Data Analyst',
        icon: Icons.analytics,
      ),
      Popular(
        name: 'Consultant',
        icon: Icons.business,
      ),
    ];
  }
}