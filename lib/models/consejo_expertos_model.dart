class ConsejoExperto {
  String id;
  String nombre;
  String consejo;

  ConsejoExperto({
    required this.id,
    required this.nombre,
    required this.consejo,
  });

  // Método para convertir un mapa de Firestore a un objeto ConsejoExperto
  factory ConsejoExperto.fromMap(Map<String, dynamic> map, String documentId) {
    return ConsejoExperto(
      id: documentId,
      nombre: map['nombre'] ?? '',
      consejo: map['consejo'] ?? '',
    );
  }

  // Método para convertir un objeto ConsejoExperto a un mapa que pueda ser guardado en Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'consejo': consejo,
    };
  }
}
