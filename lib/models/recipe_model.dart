class Recipe {
  final String recetaID;
  final String nombre;
  final Descripcion descripcion;
  final int tiempoPreparacion;
  final List<String> instrucciones;
  final Ingredientes ingredientes;
  final String imagenURL;

  Recipe({
    required this.recetaID,
    required this.nombre,
    required this.descripcion,
    required this.tiempoPreparacion,
    required this.instrucciones,
    required this.ingredientes,
    required this.imagenURL,
  });

  // Add a getter for region
  String get region => descripcion.region;

  factory Recipe.fromMap(Map<String, dynamic> map) {
    try {
      return Recipe(
        recetaID: map['recetaID'] ?? '',
        nombre: map['nombre'] ?? '',
        descripcion: Descripcion.fromMap(map['descripción'] ?? {}),
        tiempoPreparacion: map['tiempoPreparacion'] ?? 0,
        instrucciones: List<String>.from(map['instrucciones'] ?? []),
        ingredientes: Ingredientes.fromMap(map['ingredientes'] ?? {}),
        imagenURL: map['imagenURL'] ?? '',
      );
    } catch (e, stackTrace) {
      print('Error al crear Recipe desde map: $e');
      print('StackTrace: $stackTrace');
      print('Map recibido: $map');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'recetaID': recetaID,
      'nombre': nombre,
      'descripción': descripcion.toMap(),
      'tiempoPreparacion': tiempoPreparacion,
      'instrucciones': instrucciones,
      'ingredientes': ingredientes.toMap(),
      'imagenURL': imagenURL,
    };
  }
}

class Descripcion {
  final String detalle;
  final String region;

  Descripcion({required this.detalle, required this.region});

  factory Descripcion.fromMap(Map<String, dynamic> map) {
    return Descripcion(
      detalle: map['detalle'] ?? '',
      region: map['región'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'detalle': detalle,
      'región': region,
    };
  }
}

class Ingredientes {
  final List<Ingrediente>? frutas;
  final List<Ingrediente>? lacteos;
  final List<Ingrediente>? proteinas;
  final List<Ingrediente>? verduras;
  final List<Ingrediente>? semillas;

  Ingredientes({
    this.frutas,
    this.lacteos,
    this.proteinas,
    this.verduras,
    this.semillas,
  });

  factory Ingredientes.fromMap(Map<String, dynamic> map) {
    return Ingredientes(
      frutas: _parseIngredientes(map['frutas']),
      lacteos: _parseIngredientes(map['lacteos']),
      proteinas: _parseIngredientes(map['proteinas']),
      verduras: _parseIngredientes(map['verduras']),
      semillas: _parseIngredientes(map['semillas']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'frutas': frutas?.map((i) => i.toMap()).toList(),
      'lacteos': lacteos?.map((i) => i.toMap()).toList(),
      'proteinas': proteinas?.map((i) => i.toMap()).toList(),
      'verduras': verduras?.map((i) => i.toMap()).toList(),
      'semillas': semillas?.map((i) => i.toMap()).toList(),
    };
  }

  static List<Ingrediente>? _parseIngredientes(List? list) {
    return list?.map((item) => Ingrediente.fromMap(item)).toList();
  }
}

class Ingrediente {
  final String nombre;
  final int cantidad;
  final String unidad;
  final InformacionNutricional informacionNutricional;

  Ingrediente({
    required this.nombre,
    required this.cantidad,
    required this.unidad,
    required this.informacionNutricional,
  });

  factory Ingrediente.fromMap(Map<String, dynamic> map) {
    return Ingrediente(
      nombre: map['nombre'] ?? '',
      cantidad: map['cantidad'] ?? 0,
      unidad: map['unidad'] ?? '',
      informacionNutricional: InformacionNutricional.fromMap(map['informacionNutricional'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'cantidad': cantidad,
      'unidad': unidad,
      'informacionNutricional': informacionNutricional.toMap(),
    };
  }
}

class InformacionNutricional {
  final double calorias;
  final double grasas;
  final double proteinas;
  final double carbohidratos;
  final double glucosa;

  InformacionNutricional({
    required this.calorias,
    required this.grasas,
    required this.proteinas,
    required this.carbohidratos,
    required this.glucosa,
  });

  factory InformacionNutricional.fromMap(Map<String, dynamic> map) {
    return InformacionNutricional(
      calorias: (map['calorías'] ?? 0).toDouble(),
      grasas: (map['grasas'] ?? 0).toDouble(),
      proteinas: (map['proteínas'] ?? 0).toDouble(),
      carbohidratos: (map['carbohidratos'] ?? 0).toDouble(),
      glucosa: (map['glucosa'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'calorías': calorias,
      'grasas': grasas,
      'proteínas': proteinas,
      'carbohidratos': carbohidratos,
      'glucosa': glucosa,
    };
  }
}