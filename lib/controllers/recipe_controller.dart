import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';

class RecipeController {
  final CollectionReference _recipesCollection;

  RecipeController({FirebaseFirestore? firestore})
      : _recipesCollection = (firestore ?? FirebaseFirestore.instance).collection('recipes');

  Future<List<Recipe>> getRecipes({String? region}) async {
    QuerySnapshot snapshot;
    if (region != null) {
      snapshot = await _recipesCollection
          .where('descripción.región', isEqualTo: region)
          .get();
    } else {
      snapshot = await _recipesCollection.get();
    }
    return snapshot.docs
        .map((doc) => Recipe.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<Recipe> getRecipe(String id) async {
    DocumentSnapshot doc = await _recipesCollection.doc(id).get();
    return Recipe.fromMap(doc.data() as Map<String, dynamic>);
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
}