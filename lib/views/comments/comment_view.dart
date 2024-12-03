import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/comment_model.dart';
import '../../models/recipe_model.dart';

class ComentariosView extends StatefulWidget {
  final Recipe receta;

  ComentariosView({required this.receta});

  @override
  _ComentariosViewState createState() => _ComentariosViewState();
}

class _ComentariosViewState extends State<ComentariosView> {
  final TextEditingController _comentarioControllerTexto = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<QuerySnapshot>? _comentariosStream;

  @override
  void initState() {
    super.initState();
    _setupComentariosStream();
  }

  void _setupComentariosStream() {
    _comentariosStream = _firestore
        .collection('comentarios')
        .where('recetaID', isEqualTo: widget.receta.recetaID)
        .orderBy('fecha', descending: true)
        .snapshots();
  }

  Future<void> _agregarComentario() async {
    if (_comentarioControllerTexto.text.isNotEmpty) {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentReference docRef = _firestore.collection('comentarios').doc();
        
        Comentario nuevoComentario = Comentario(
          comentarioID: docRef.id,
          recetaID: widget.receta.recetaID,
          usuarioID: currentUser.uid,
          texto: _comentarioControllerTexto.text,
          fecha: DateTime.now(),
          nombreUsuario: currentUser.displayName ?? 'Usuario',
        );

        await docRef.set(nuevoComentario.toMap());
        _comentarioControllerTexto.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Debes iniciar sesión para comentar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _comentariosStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No hay comentarios aún'));
              }

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  try {
                    Comentario comentario = Comentario.fromMap(data);
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    comentario.nombreUsuario,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${comentario.fecha.day}/${comentario.fecha.month}/${comentario.fecha.year}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(comentario.texto),
                          ],
                        ),
                      ),
                    );
                  } catch (e) {
                    print('Error al parsear comentario: $e');
                    return SizedBox(); // Ignorar comentarios que no se pueden parsear
                  }
                }).toList(),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _comentarioControllerTexto,
                  decoration: InputDecoration(
                    hintText: 'Agrega un comentario...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: _agregarComentario,
                child: Icon(Icons.send),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}