class Rating {
  String id; // Identificador único para la calificación
  int rating; // Valor de la calificación entre 1 y 5
  String? feedback; // Comentarios opcionales del usuario

  Rating({required this.id, required this.rating, this.feedback});

  // Método para convertir el modelo a un mapa, útil para Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rating': rating,
      'feedback': feedback,
    };
  }

  // Método para crear un objeto Rating desde un mapa
  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      id: map['id'],
      rating: map['rating'],
      feedback: map['feedback'],
    );
  }
}
