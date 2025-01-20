import 'package:flutter/material.dart';
import '../add new user/search_screen.dart';

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
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 42),
      margin: EdgeInsets.only(top: 117),
      child: Column(
        children: [
          Text(
            'Scale your professional',
            style: TextStyle(
              fontSize: 21,
              color: Colors.white,
              letterSpacing: -0.42,
            ),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'workforce with',
                style: TextStyle(
                  fontSize: 21,
                  color: Colors.white,
                  letterSpacing: -0.42,
                ),
              ),
              SizedBox(width: 7),
              Text(
                'freelancers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: -0.54,
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black),
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for any service...',
                      hintStyle: TextStyle(
                        fontSize: 13,
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
