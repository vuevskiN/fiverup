import 'package:flutter/material.dart';
import 'header_section.dart';
import 'promo_section.dart';
import 'button_section.dart';
import 'category_section.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            HeaderSection(),
            PromoSection(),
            ButtonSection(),
            CategorySection(),
          ],
        ),
      ),
    );
  }
}