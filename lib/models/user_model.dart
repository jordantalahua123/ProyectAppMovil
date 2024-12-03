import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String nombre;
  final int edad;
  final String genero;
  final DateTime createdAt;

  User({
    required this.uid,
    required this.email,
    required this.nombre,
    required this.edad,
    required this.genero,
    required this.createdAt,
  });

  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      uid: id,
      email: data['email'] ?? '',
      nombre: data['nombre'] ?? '',
      edad: data['edad'] ?? 0,
      genero: data['genero'] ?? '',
      createdAt: data['createdAt'] is Timestamp 
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.parse(data['createdAt'] as String),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'nombre': nombre,
      'edad': edad,
      'genero': genero,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}