import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';
import '../models/preference_model.dart';

class RecipeService {
  final CollectionReference _recipesCollection =
      FirebaseFirestore.instance.collection('recipes');

  Future<List<Recipe>> getRecipes() async {
    QuerySnapshot snapshot = await _recipesCollection.get();
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['recetaID'] = doc.id; // Ensure the document ID is included
      return Recipe.fromMap(data);
    }).toList();
  }

  Future<Recipe> getRecipe(String id) async {
    DocumentSnapshot doc = await _recipesCollection.doc(id).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['recetaID'] = doc.id;
    return Recipe.fromMap(data);
  }

  Future<void> createRecipe(Recipe recipe) async {
    await _recipesCollection.doc(recipe.recetaID).set(recipe.toMap());
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _recipesCollection.doc(recipe.recetaID).update(recipe.toMap());
  }

  Future<void> deleteRecipe(String id) async {
    await _recipesCollection.doc(id).delete();
  }

  Future<List<Recipe>> getRecommendedRecipes(
      UserPreferences preferences) async {
    QuerySnapshot snapshot = await _recipesCollection.get();
    List<Recipe> allRecipes = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['recetaID'] = doc.id;
      return Recipe.fromMap(data);
    }).toList();

    List<Recipe> recommendedRecipes = [];

    for (Recipe recipe in allRecipes) {
      bool matchesPreferences = false;

      // Comprobar si la receta tiene ingredientes que coincidan con las preferencias del usuario
      if (preferences.likesFrutas &&
          recipe.ingredientes.frutas != null &&
          recipe.ingredientes.frutas!.isNotEmpty) {
        matchesPreferences = true;
      }
      if (preferences.likesVerduras &&
          recipe.ingredientes.verduras != null &&
          recipe.ingredientes.verduras!.isNotEmpty) {
        matchesPreferences = true;
      }
      if (preferences.likesLacteos &&
          recipe.ingredientes.lacteos != null &&
          recipe.ingredientes.lacteos!.isNotEmpty) {
        matchesPreferences = true;
      }
      if (preferences.likesProteinas &&
          recipe.ingredientes.proteinas != null &&
          recipe.ingredientes.proteinas!.isNotEmpty) {
        matchesPreferences = true;
      }
      if (preferences.likesSemillas &&
          recipe.ingredientes.semillas != null &&
          recipe.ingredientes.semillas!.isNotEmpty) {
        matchesPreferences = true;
      }

      // Comprobar si la receta pertenece a una región favorita del usuario
      if (preferences.favoriteRegions.contains(recipe.region)) {
        matchesPreferences = true;
      }

      // Si la receta coincide con alguna preferencia, agregarla a la lista de recomendadas
      if (matchesPreferences) {
        recommendedRecipes.add(recipe);
      }
    }

    return recommendedRecipes;
  }
}
