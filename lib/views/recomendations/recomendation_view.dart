import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/recipe_model.dart';
import '../../models/preference_model.dart';
import '../../services/recipe_service.dart';
import '../../services/preference_service.dart';
import '../home_view.dart';
import '../recipe/recipe_list_view.dart';
import '../educativo/educativo_view.dart';

class RecommendationsView extends StatefulWidget {
  @override
  _RecommendationsViewState createState() => _RecommendationsViewState();
}

class _RecommendationsViewState extends State<RecommendationsView> {
  RecipeService _recipeService = RecipeService();
  PreferenceService _preferenceService = PreferenceService(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
  Recipe? recommendedRecipe;
  UserPreferences? userPreferences;

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    userPreferences = await _preferenceService.getUserPreferences();

    if (userPreferences != null) {
      List<Recipe> recipes =
          await _recipeService.getRecommendedRecipes(userPreferences!);
      setState(() {
        recommendedRecipe = recipes.isNotEmpty ? recipes[0] : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recomendaciones'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tus Preferencias',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildPreferencesSummary(),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _fetchRecommendations,
                icon: Icon(Icons.search),
                label: Text('Buscar Recomendaciones'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  textStyle: TextStyle(fontSize: 18),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              SizedBox(height: 30),
              if (recommendedRecipe != null) _buildRecommendationCard(),
              if (recommendedRecipe == null)
                Center(
                  child: Text(
                    'No se encontraron recomendaciones.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(), // Añade el menú aquí
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Recetas'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Educativos'),
        BottomNavigationBarItem(icon: Icon(Icons.recommend), label: 'Recomendaciones'),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeView()),
          );
        }
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecipeListView()),
          );
        }
        if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EducativoView()),
            );
          }
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecommendationsView()),
          );
        }
      },
    );
  }

  Widget _buildPreferencesSummary() {
    if (userPreferences == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Card(
      color: Colors.teal[50],
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPreferenceRow('Frutas', userPreferences!.likesFrutas),
            _buildPreferenceRow('Verduras', userPreferences!.likesVerduras),
            _buildPreferenceRow('Lácteos', userPreferences!.likesLacteos),
            _buildPreferenceRow('Proteínas', userPreferences!.likesProteinas),
            _buildPreferenceRow('Semillas', userPreferences!.likesSemillas),
            Text(
              'Regiones Favoritas: ${userPreferences!.favoriteRegions.join(', ')}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceRow(String label, bool likes) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        Icon(
          likes ? Icons.check_circle : Icons.cancel,
          color: likes ? Colors.green : Colors.red,
        ),
      ],
    );
  }

  Widget _buildRecommendationCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hoy te recomendamos:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (recommendedRecipe!.imagenURL.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  recommendedRecipe!.imagenURL,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 15),
            Text(
              recommendedRecipe!.nombre,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              recommendedRecipe!.descripcion.detalle,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Acciones al presionar el botón
              },
              child: Text('Ver más detalles'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
