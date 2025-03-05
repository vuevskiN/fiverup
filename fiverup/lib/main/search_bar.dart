import 'package:flutter/material.dart';
import '../filter/search_screen.dart';

class PromoSection extends StatefulWidget {
  @override
  _PromoSectionState createState() => _PromoSectionState();
}

class _PromoSectionState extends State<PromoSection> {
  final TextEditingController _searchController = TextEditingController();

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(searchQuery: query), // Send query to search page
        ),
      );
    }

    else{
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(searchQuery: query.isEmpty ? '' : query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xCC415A77),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 2, blurRadius: 8)],
      ),
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Column(
        children: [
          Text(
            'Scale your professional',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFFE0E1DD),
              letterSpacing: -0.42,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'workforce with',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  letterSpacing: -0.42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'FiverUp',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.amberAccent,
                  letterSpacing: -0.54,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6, spreadRadius: 2)],
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for any job...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1B263B),
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _performSearch(), // Search on enter
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _performSearch, // Search on button press
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
