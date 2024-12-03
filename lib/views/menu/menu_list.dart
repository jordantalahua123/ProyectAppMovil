import 'package:flutter/material.dart';

class RecipesOfTheDayScreen extends StatefulWidget {
  @override
  _RecipesOfTheDayScreenState createState() => _RecipesOfTheDayScreenState();
}

class _RecipesOfTheDayScreenState extends State<RecipesOfTheDayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recetas del día'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Encontrar recetas...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildRecipeCard(
                  'Lorem ipsum',
                  'Mexicana',
                  'Saludable',
                  'lib/assets/glucofit_logo.jpeg',
                ),
                _buildRecipeCard(
                  'Lorem ipsum',
                  'Mexicana',
                  'Saludable',
                  'lib/assets/glucofit_logo.jpeg',
                ),
                _buildRecipeCard(
                  'Lorem ipsum',
                  'Mexicana',
                  'Saludable',
                  'lib/assets/glucofit_logo.jpeg',
                ),
                _buildRecipeCard(
                  'Lorem ipsum',
                  'Mexicana',
                  'Saludable',
                  'lib/assets/glucofit_logo.jpeg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(
    String title,
    String cuisine,
    String healthiness,
    String imagePath,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.asset(
                imagePath,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(cuisine),
                      Spacer(),
                      Text(healthiness),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
