import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import '../../lib/models/recipe_model.dart';
import '../../lib/controllers/recipe_controller.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late RecipeController recipeController;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    recipeController = RecipeController(firestore: fakeFirestore);
  });

  group('RecipeController Tests', () {
    final recetaID = 'test_id';
    final recipe = Recipe(
      recetaID: recetaID,
      nombre: 'Test Recipe',
      descripcion: Descripcion(detalle: 'Test Detail', region: 'Test Region'),
      tiempoPreparacion: 30,
      instrucciones: ['Step 1', 'Step 2'],
      ingredientes: Ingredientes(
        frutas: [Ingrediente(nombre: 'Manzana', cantidad: 2, unidad: 'Piezas', informacionNutricional: InformacionNutricional(calorias: 52, grasas: 0.2, proteinas: 0.3, carbohidratos: 14, glucosa: 10))],
        lacteos: [],
        proteinas: [],
        verduras: [],
        semillas: [],
      ),
      imagenURL: 'http://test.com/image.png',
    );

    test('Create Recipe', () async {
      await recipeController.createRecipe(recipe);

      final snapshot = await fakeFirestore.collection('recipes').doc(recetaID).get();
      final createdRecipe = Recipe.fromMap(snapshot.data() as Map<String, dynamic>);

      expect(createdRecipe.nombre, 'Test Recipe');
      expect(createdRecipe.descripcion.detalle, 'Test Detail');
    });

    test('Get Recipe', () async {
      await recipeController.createRecipe(recipe);

      final fetchedRecipe = await recipeController.getRecipe(recetaID);

      expect(fetchedRecipe.nombre, 'Test Recipe');
      expect(fetchedRecipe.descripcion.detalle, 'Test Detail');
    });

    test('Update Recipe', () async {
      await recipeController.createRecipe(recipe);

      final updatedRecipe = Recipe(
        recetaID: recetaID,
        nombre: 'Updated Recipe',
        descripcion: Descripcion(detalle: 'Updated Detail', region: 'Updated Region'),
        tiempoPreparacion: 40,
        instrucciones: ['Updated Step 1'],
        ingredientes: Ingredientes(
          frutas: [Ingrediente(nombre: 'Pera', cantidad: 3, unidad: 'Piezas', informacionNutricional: InformacionNutricional(calorias: 57, grasas: 0.1, proteinas: 0.4, carbohidratos: 15, glucosa: 9))],
          lacteos: [],
          proteinas: [],
          verduras: [],
          semillas: [],
        ),
        imagenURL: 'http://test.com/updated_image.png',
      );

      await recipeController.updateRecipe(updatedRecipe);

      final snapshot = await fakeFirestore.collection('recipes').doc(recetaID).get();
      final fetchedRecipe = Recipe.fromMap(snapshot.data() as Map<String, dynamic>);

      expect(fetchedRecipe.nombre, 'Updated Recipe');
      expect(fetchedRecipe.descripcion.detalle, 'Updated Detail');
    });

    test('Delete Recipe', () async {
      await recipeController.createRecipe(recipe);

      await recipeController.deleteRecipe(recetaID);

      final snapshot = await fakeFirestore.collection('recipes').doc(recetaID).get();

      expect(snapshot.exists, isFalse);
    });
  });
}
