import 'package:flutter/material.dart';
import '../../models/recipe_model.dart';
import '../../controllers/recipe_controller.dart';
import 'package:uuid/uuid.dart';

class RecipeCreateView extends StatefulWidget {
  @override
  _RecipeCreateViewState createState() => _RecipeCreateViewState();
}

class _RecipeCreateViewState extends State<RecipeCreateView> {
  final _formKey = GlobalKey<FormState>();
  final RecipeController _controller = RecipeController();

  final _nombreController = TextEditingController();
  final _descripcionDetalleController = TextEditingController();
  final _descripcionRegionController = TextEditingController();
  final _tiempoPreparacionController = TextEditingController();
  final _imagenURLController = TextEditingController();

  List<TextEditingController> _instruccionesControllers = [TextEditingController()];

  Map<String, List<Map<String, TextEditingController>>> _ingredientesControllers = {
    'frutas': [],
    'lacteos': [],
    'proteinas': [],
    'verduras': [],
    'semillas': [],
  };

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionDetalleController.dispose();
    _descripcionRegionController.dispose();
    _tiempoPreparacionController.dispose();
    _imagenURLController.dispose();
    for (var controller in _instruccionesControllers) {
      controller.dispose();
    }
    for (var category in _ingredientesControllers.values) {
      for (var ingredientControllers in category) {
        ingredientControllers.values.forEach((controller) => controller.dispose());
      }
    }
    super.dispose();
  }

  void _addInstruction() {
    setState(() {
      _instruccionesControllers.add(TextEditingController());
    });
  }

  void _removeInstruction(int index) {
    setState(() {
      _instruccionesControllers[index].dispose();
      _instruccionesControllers.removeAt(index);
    });
  }

  void _addIngredient(String category) {
    setState(() {
      _ingredientesControllers[category]!.add({
        'nombre': TextEditingController(),
        'cantidad': TextEditingController(),
        'unidad': TextEditingController(),
        'calorias': TextEditingController(),
        'grasas': TextEditingController(),
        'proteinas': TextEditingController(),
        'carbohidratos': TextEditingController(),
        'glucosa': TextEditingController(),
      });
    });
  }

  void _removeIngredient(String category, int index) {
    setState(() {
      _ingredientesControllers[category]![index].values.forEach((controller) => controller.dispose());
      _ingredientesControllers[category]!.removeAt(index);
    });
  }

  Future<void> _createRecipe() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newRecipe = Recipe(
        recetaID: Uuid().v4(),
        nombre: _nombreController.text,
        descripcion: Descripcion(
          detalle: _descripcionDetalleController.text,
          region: _descripcionRegionController.text,
        ),
        tiempoPreparacion: int.tryParse(_tiempoPreparacionController.text) ?? 0,
        instrucciones: _instruccionesControllers
            .map((controller) => controller.text)
            .where((text) => text.isNotEmpty)
            .toList(),
        ingredientes: Ingredientes(
          frutas: _buildIngredientesList('frutas'),
          lacteos: _buildIngredientesList('lacteos'),
          proteinas: _buildIngredientesList('proteinas'),
          verduras: _buildIngredientesList('verduras'),
          semillas: _buildIngredientesList('semillas'),
        ),
        imagenURL: _imagenURLController.text,
      );

      try {
        await _controller.createRecipe(newRecipe);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la receta: $e')),
        );
      }
    }
  }

  List<Ingrediente>? _buildIngredientesList(String category) {
    final ingredientes = _ingredientesControllers[category]!
        .map((controllers) => Ingrediente(
              nombre: controllers['nombre']!.text,
              cantidad: int.tryParse(controllers['cantidad']!.text) ?? 0,
              unidad: controllers['unidad']!.text,
              informacionNutricional: InformacionNutricional(
                calorias: double.tryParse(controllers['calorias']!.text) ?? 0,
                grasas: double.tryParse(controllers['grasas']!.text) ?? 0,
                proteinas: double.tryParse(controllers['proteinas']!.text) ?? 0,
                carbohidratos: double.tryParse(controllers['carbohidratos']!.text) ?? 0,
                glucosa: double.tryParse(controllers['glucosa']!.text) ?? 0,
              ),
            ))
        .toList();
    return ingredientes.isNotEmpty ? ingredientes : null;
  }

  Widget _buildIngredientFields(String category, int index) {
    final controllers = _ingredientesControllers[category]![index];
    return ExpansionTile(
      title: Text(controllers['nombre']!.text.isEmpty ? 'Nuevo Ingrediente' : controllers['nombre']!.text),
      children: [
        _buildTextField(controllers['nombre']!, 'Nombre'),
        _buildTextField(controllers['cantidad']!, 'Cantidad', inputType: TextInputType.number),
        _buildTextField(controllers['unidad']!, 'Unidad'),
        _buildTextField(controllers['calorias']!, 'Calorías', inputType: TextInputType.number),
        _buildTextField(controllers['grasas']!, 'Grasas', inputType: TextInputType.number),
        _buildTextField(controllers['proteinas']!, 'Proteínas', inputType: TextInputType.number),
        _buildTextField(controllers['carbohidratos']!, 'Carbohidratos', inputType: TextInputType.number),
        _buildTextField(controllers['glucosa']!, 'Glucosa', inputType: TextInputType.number),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () => _removeIngredient(category, index),
            child: Text('Eliminar Ingrediente'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Nueva Receta'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            _buildTextField(_nombreController, 'Nombre'),
            _buildTextField(_descripcionDetalleController, 'Descripción'),
            _buildTextField(_descripcionRegionController, 'Región'),
            _buildTextField(_tiempoPreparacionController, 'Tiempo de Preparación (minutos)', inputType: TextInputType.number),
            SizedBox(height: 16),
            ..._instruccionesControllers.asMap().entries.map(
              (entry) => Row(
                children: [
                  Expanded(
                    child: _buildTextField(entry.value, 'Instrucción ${entry.key + 1}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeInstruction(entry.key),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _addInstruction,
              child: Text('Agregar Instrucción'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
            ),
            SizedBox(height: 16),
            ..._ingredientesControllers.entries.map((entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key.toUpperCase(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...entry.value.asMap().entries.map((ingredientEntry) => 
                  _buildIngredientFields(entry.key, ingredientEntry.key)
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _addIngredient(entry.key),
                  child: Text('Agregar ${entry.key}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                ),
              ],
            )),
            SizedBox(height: 16),
            _buildTextField(_imagenURLController, 'URL de la Imagen'),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createRecipe,
                child: Text('Crear Receta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}