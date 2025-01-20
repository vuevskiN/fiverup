import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(  // Wrap the entire Column with SingleChildScrollView
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 61),
            child: Text(
              'Popular categories',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0x40414569),
                letterSpacing: -0.9,
              ),
            ),
          ),
          CategoryRow(
            categories: [
              Category(
                title: 'Programming\n& Tech',
                imageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/29f15c21ef70c60a06ec8d0f20b659f4e3f44301a03df6e6bf5c2fa7b2a02162?placeholderIfAbsent=true&apiKey=a8695391dc78414caaae2cf40409f049',
              ),
              Category(
                title: 'Music & Audio',
                imageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/1690a2d96aa05437238b69fcec0fb6a46aef5753908ff349b074fb2ddfad2983?placeholderIfAbsent=true&apiKey=a8695391dc78414caaae2cf40409f049',
              ),
              Category(
                title: 'Graphics &\nDesign',
                imageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/a137cc9a80e4ba911ef754143cb053d60ab7e6f1dcaf27ab018ce4959dd28488?placeholderIfAbsent=true&apiKey=a8695391dc78414caaae2cf40409f049',
              ),
            ],
          ),
          CategoryRow(
            categories: [
              Category(
                title: 'Video &\nAnimation',
                imageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/7c20ee3ffe3d8615284e4cb4c920d3d01c5fcd3e5b174a892e8af71217a19c83?placeholderIfAbsent=true&apiKey=a8695391dc78414caaae2cf40409f049',
              ),
              Category(
                title: 'Consulting',
                imageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/d5987f95f8bbbe008f4bbb53ab2485f62d76365d5226b29fd187294d9ddb08dc?placeholderIfAbsent=true&apiKey=a8695391dc78414caaae2cf40409f049',
              ),
              Category(
                title: 'Writing &\nTranslation',
                imageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/0df8e75130b9df398796ebc2e92405b5a458875de7d6b0b964ca379aa5129fd6?placeholderIfAbsent=true&apiKey=a8695391dc78414caaae2cf40409f049',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryRow extends StatelessWidget {
  final List<Category> categories;

  CategoryRow({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: categories.map((category) => CategoryTile(category: category)).toList(),
      ),
    );
  }
}

class Category {
  final String title;
  final String imageUrl;

  Category({required this.title, required this.imageUrl});
}

class CategoryTile extends StatelessWidget {
  final Category category;

  CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 97,
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.027), blurRadius: 1)],
        border: Border.all(color: Colors.white),
      ),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Replace Image.network with Icon
          Icon(
            Icons.computer, // You can change this to any appropriate icon
            size: 40,
            color: Colors.black, // Adjust icon color if necessary
          ),
          SizedBox(height: 10),
          Text(
            category.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0x22232325),
            ),
          ),
        ],
      ),
    );
  }
}
