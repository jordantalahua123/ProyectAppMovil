import 'package:flutter/material.dart';
import 'package:gluco_fit/views/menu/menu_list.dart';
import '../controllers/auth_controller.dart';
import 'recipe/recipe_list_view.dart';
import 'package:gluco_fit/views/FAQ_view.dart';
import 'auth_view.dart';
import '../services/recipe_upload_service.dart';
import 'package:gluco_fit/views/recomendations/recomendation_view.dart';
import 'educativo/educativo_view.dart';
import 'rating_view.dart';
import 'consejos_view.dart';

class HomeView extends StatelessWidget {
  final AuthController _authController = AuthController();
  final RecipeUploadService _uploadService = RecipeUploadService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD1F3E7),
      appBar: AppBar(
        title: Text('Menú Principal'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _authController.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AuthView()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenid@ de vuelta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset('lib/assets/glucofit_logo.jpeg',
                      fit: BoxFit.contain),
                ),
              ),
              SizedBox(height: 30),
              _buildMenuItem(Icons.lock, 'Feedback', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RatingView()),
                );
              }),
              SizedBox(height: 15),
              _buildMenuItem(Icons.book, 'FAQ', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQScreen()),
                );
              }),
              SizedBox(height: 15),
              _buildMenuItem(Icons.book, 'Recursos educativos', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EducativoView()),
                );
              }),

              SizedBox(height: 15),
              _buildMenuItem(Icons.book, 'Consejos de Expertos', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConsejosView()),
                );
              }),

              SizedBox(height: 15),

              // Botón pequeño para subir recetas
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _uploadService.uploadRecipesFromFile(
                        'lib/assets/resources/recetasSierra.txt');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Recetas subidas correctamente')),
                    );
                  },
                  child: Text('Subir Recetas'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    textStyle: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: 'Recetas'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Educativos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.recommend), label: 'Recomendaciones'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeView()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipeListView()),
              );
              break;
            // Aquí puedes agregar la lógica para las otras opciones del menú
            default:
              break;
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
              MaterialPageRoute(
                  builder: (context) =>
                      RecommendationsView()), // Navega a la vista de recomendaciones
            );
          }
          // Aquí puedes agregar la lógica para las otras opciones del menú
        },
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            SizedBox(width: 16),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
