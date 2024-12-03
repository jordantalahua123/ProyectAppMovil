import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;

class RecipeUploadService {
  final CollectionReference _recipesCollection =
      FirebaseFirestore.instance.collection('recipes');

  Future<void> uploadRecipesFromFile(String filePath) async {
    try {
      // Leer el archivo
      String fileContent = await rootBundle.loadString(filePath);

      // Parsear el contenido JSON
      List<dynamic> recipesList = jsonDecode(fileContent);

      // Iterar sobre cada receta y subirla a Firebase
      for (var recipeData in recipesList) {
        await _recipesCollection.doc(recipeData['recetaID']).set(recipeData);
      }

      print('Todas las recetas se han subido correctamente.');
    } catch (e) {
      print('Error al subir recetas: $e');
    }
  }
}
