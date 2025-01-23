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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(searchQuery: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF415A77),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
      margin: EdgeInsets.only(top: 100),
      child: Column(
        children: [
          Text(
            'Scale your professional',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
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
                  fontSize: 24,
                  color: Colors.white,
                  letterSpacing: -0.42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'freelancers',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -0.54,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for any service...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1B263B),
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _performSearch(), // Trigger search on submit
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _performSearch,
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
