import 'package:cloud_firestore/cloud_firestore.dart';

class Comentario {
  final String comentarioID;
  final String recetaID;
  final String usuarioID;
  final String texto;
  final DateTime fecha;
  final String nombreUsuario;

  Comentario({
    required this.comentarioID,
    required this.recetaID,
    required this.usuarioID,
    required this.texto,
    required this.fecha,
    required this.nombreUsuario,
  });

  factory Comentario.fromMap(Map<String, dynamic> map) {
    return Comentario(
      comentarioID: map['comentarioID'] ?? '',
      recetaID: map['recetaID'] ?? '',
      usuarioID: map['usuarioID'] ?? '',
      texto: map['texto'] ?? '',
      fecha: map['fecha'] != null ? (map['fecha'] as Timestamp).toDate() : DateTime.now(),
      nombreUsuario: map['nombreUsuario'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'comentarioID': comentarioID,
      'recetaID': recetaID,
      'usuarioID': usuarioID,
      'texto': texto,
      'fecha': Timestamp.fromDate(fecha),
      'nombreUsuario': nombreUsuario,
    };
  }
}
