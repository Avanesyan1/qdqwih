import 'package:diplom_main/Model/categoriesInfo.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  final int categoryIndex;

  const CategoriesScreen({Key? key, required this.categoryIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CategoryInfo categoryInfo = CategoriesInfo.continents[categoryIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Континент'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              categoryInfo.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Описание:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              categoryInfo.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Культурные особенности:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              categoryInfo.culturalFeatures,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}