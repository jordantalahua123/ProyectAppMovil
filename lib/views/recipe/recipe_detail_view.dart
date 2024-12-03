import 'package:flutter/material.dart';
import '../../models/recipe_model.dart';
import '../../services/diabetes_service.dart';
import '../comments/comment_view.dart';
import '../../controllers/recipe_controller.dart';
import 'recipe_edit_view.dart'; // Asegúrate de importar la vista de edición

class RecipeDetailView extends StatefulWidget {
  final Recipe recipe;

  RecipeDetailView({required this.recipe});

  @override
  _RecipeDetailViewState createState() => _RecipeDetailViewState();
}

class _RecipeDetailViewState extends State<RecipeDetailView> {
  final DiabetesService diabetesService = DiabetesService();
  final RecipeController recipeController = RecipeController(); // Controlador para la receta

  late Recipe _recipe = widget.recipe;
  String diabetesStatus = "";
  bool isDiabetesStatusVisible = false;

  void _checkDiabetesStatus() async {
    // Inicializar valores nutricionales
    double totalCalorias = 0;
    double totalGrasas = 0;
    double totalProteinas = 0;
    double totalCarbohidratos = 0;
    double totalGlucosa = 0;

    int totalFrutas = _recipe.ingredientes.frutas?.length ?? 0;
    int totalLacteos = _recipe.ingredientes.lacteos?.length ?? 0;
    int totalProteinasIng = _recipe.ingredientes.proteinas?.length ?? 0;
    int totalVerduras = _recipe.ingredientes.verduras?.length ?? 0;
    int totalSemillas = _recipe.ingredientes.semillas?.length ?? 0;

    // Sumar valores nutricionales de cada ingrediente
    _sumarValoresNutricionales(List<Ingrediente>? ingredientes) {
      if (ingredientes != null) {
        for (var ingrediente in ingredientes) {
          totalCalorias += ingrediente.informacionNutricional.calorias;
          totalGrasas += ingrediente.informacionNutricional.grasas;
          totalProteinas += ingrediente.informacionNutricional.proteinas;
          totalCarbohidratos += ingrediente.informacionNutricional.carbohidratos;
          totalGlucosa += ingrediente.informacionNutricional.glucosa;
        }
      }
    }

    _sumarValoresNutricionales(_recipe.ingredientes.proteinas);
    _sumarValoresNutricionales(_recipe.ingredientes.frutas);
    _sumarValoresNutricionales(_recipe.ingredientes.lacteos);
    _sumarValoresNutricionales(_recipe.ingredientes.verduras);
    _sumarValoresNutricionales(_recipe.ingredientes.semillas);

    // Mapa de las regiones
    Map<String, int> regionMap = {
      "Costa": 1,
      "Sierra": 2,
      "Oriente": 3,
      // Añadir más regiones según sea necesario
    };

    // Convertir la región a un número utilizando el mapa
    int regionValue = regionMap[_recipe.region] ?? 0; // Por defecto a 0 si la región no existe

    // Construir los datos para enviar a la API según la estructura correcta
    Map<String, dynamic> data = {
      "Region": regionValue,
      "TiempoPrep": _recipe.tiempoPreparacion,
      "Calorias": totalCalorias,
      "Grasas": totalGrasas,
      "Proteinas": totalProteinas,
      "Carbohidratos": totalCarbohidratos,
      "Glucosa": totalGlucosa,
      "Frutas": totalFrutas,
      "Lacteos": totalLacteos,
      "ProteinasIng": totalProteinasIng,
      "Verduras": totalVerduras,
      "Semillas": totalSemillas,
      "TipoDiabetes": 2 // Asegúrate de pasar el tipo de diabetes correctamente
    };

    // Llamar al servicio y actualizar el estado
    String result = await diabetesService.checkDiabetesStatus(data);
    setState(() {
      diabetesStatus = result == "1" ? "Apto para diabetes" : "No apto para diabetes";
      isDiabetesStatusVisible = true; // Mostrar el texto con el resultado
    });
  }

  void _deleteRecipe() async {
    await recipeController.deleteRecipe(_recipe.recetaID);
    Navigator.pop(context); // Regresa a la pantalla anterior después de eliminar
  }

  void _navigateToEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeEditView(recipe: _recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD1F3E7),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  _recipe.nombre,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                background: Image.network(
                  _recipe.imagenURL,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: Colors.grey[300]);
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoSection('Descripción', _recipe.descripcion.detalle),
                    _buildInfoSection('Región', _recipe.descripcion.region),
                    _buildInfoSection('Tiempo de Preparación', '${_recipe.tiempoPreparacion} minutos'),
                    _buildIngredientSection(),
                    _buildInstructionSection(),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _checkDiabetesStatus,
                      child: Text('Consultar si es apto para diabetes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                    ),
                    if (isDiabetesStatusVisible)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          diabetesStatus,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _navigateToEdit,
                          child: Text('Editar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _deleteRecipe,
                          child: Text('Eliminar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Comentarios',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 400),
                child: ComentariosView(receta: _recipe),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            content,
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredientes:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        _buildIngredientList(_recipe.ingredientes),
      ],
    );
  }

  Widget _buildIngredientList(Ingredientes ingredientes) {
    List<Widget> ingredientWidgets = [];

    void addIngredients(String category, List<Ingrediente>? ingredients) {
      if (ingredients != null && ingredients.isNotEmpty) {
        ingredientWidgets
            .add(Text(category, style: TextStyle(fontWeight: FontWeight.bold)));
        ingredientWidgets.addAll(ingredients
            .map((i) => Text('• ${i.nombre}: ${i.cantidad} ${i.unidad}')));
      }
    }

    addIngredients('Frutas', ingredientes.frutas);
    addIngredients('Lácteos', ingredientes.lacteos);
    addIngredients('Proteínas', ingredientes.proteinas);
    addIngredients('Verduras', ingredientes.verduras);
    addIngredients('Semillas', ingredientes.semillas);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ingredientWidgets);
  }

  Widget _buildInstructionSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instrucciones:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          ..._recipe.instrucciones.map((i) => Text('• $i')),
        ],
      ),
    );
  }
}
