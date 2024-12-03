import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../lib/controllers/comment_controller.dart';
import '../../lib/models/comment_model.dart';

import 'comment_controller_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  QuerySnapshot,
  QueryDocumentSnapshot,
  Query
])
void main() {
  group('ComentarioController', () {
    late ComentarioController comentarioController;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollection;
    late MockQuery<Map<String, dynamic>> mockQuery;
    late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
    late MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocumentSnapshot;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference<Map<String, dynamic>>();
      mockQuery = MockQuery<Map<String, dynamic>>();
      mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      mockQueryDocumentSnapshot = MockQueryDocumentSnapshot<Map<String, dynamic>>();
      comentarioController = ComentarioController(firestore: mockFirestore);

      // Simula la colección 'comentarios'
      when(mockFirestore.collection('comentarios')).thenReturn(mockCollection);
    });

    test('agregarComentario debería agregar un nuevo comentario a Firestore', () async {
      final comentario = Comentario(
        comentarioID: '1',
        recetaID: 'receta1',
        usuarioID: 'usuario1',
        texto: 'Un comentario de prueba',
        fecha: DateTime.now(),
        nombreUsuario: 'Usuario de Prueba',
      );

      when(mockCollection.add(any)).thenAnswer((_) async => MockDocumentReference());

      await comentarioController.agregarComentario(comentario);

      verify(mockCollection.add(comentario.toMap())).called(1);
    });

    test('obtenerComentariosPorReceta debería devolver una lista de comentarios', () async {
      final comentario = Comentario(
        comentarioID: '1',
        recetaID: 'receta1',
        usuarioID: 'usuario1',
        texto: 'Un comentario de prueba',
        fecha: DateTime.now(),
        nombreUsuario: 'Usuario de Prueba',
      );

      // Configura el documento simulado para devolver los datos del comentario
      when(mockQueryDocumentSnapshot.data()).thenReturn(comentario.toMap());
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);

      // Simula la consulta encadenada: where -> orderBy -> get
      when(mockCollection.where('recetaID', isEqualTo: anyNamed('isEqualTo'))).thenReturn(mockQuery);
      when(mockQuery.orderBy('fecha', descending: true)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);

      final comentarios = await comentarioController.obtenerComentariosPorReceta('receta1');

      expect(comentarios, isA<List<Comentario>>());
      expect(comentarios.length, 1);
      expect(comentarios.first.texto, comentario.texto);
    });
  });
}
