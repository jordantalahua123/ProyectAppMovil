class RecursoEducativo {
  final String id;
  final String descripcion;
  final String url;
  final String tipo; // 'imagen' o 'video'

  RecursoEducativo({
    required this.id,
    required this.descripcion,
    required this.url,
    required this.tipo,
  });

  factory RecursoEducativo.fromFirestore(Map<String, dynamic> data, String id) {
    return RecursoEducativo(
      id: id,
      descripcion: data['descripcion'] ?? '',
      url: data['url'] ?? '',
      tipo: data['tipo'] ?? 'imagen',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'descripcion': descripcion,
      'url': url,
      'tipo': tipo,
    };
  }
}