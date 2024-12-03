import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/recurso_educativo_model.dart';
import 'package:path/path.dart' as path;

class RecursoEducativoService {
  final CollectionReference _recursosCollection = FirebaseFirestore.instance.collection('recursos_educativos');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<RecursoEducativo>> getRecursosEducativos() async {
    QuerySnapshot querySnapshot = await _recursosCollection.get();
    return querySnapshot.docs.map((doc) {
      return RecursoEducativo.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<String> _uploadFile(File file, String tipo) async {
    String fileName = path.basename(file.path);
    String folder = tipo == 'video' ? 'videos' : 'imagenes';
    Reference storageRef = _storage.ref().child('recursos_educativos/$folder/$fileName');
    UploadTask uploadTask = storageRef.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> addRecursoEducativo(String descripcion, File file, String tipo) async {
    String url = await _uploadFile(file, tipo);
    await _recursosCollection.add({
      'descripcion': descripcion,
      'url': url,
      'tipo': tipo,
    });
  }

  Future<void> updateRecursoEducativo(String id, String descripcion, File? file, String tipo) async {
    Map<String, dynamic> updateData = {'descripcion': descripcion, 'tipo': tipo};
    if (file != null) {
      String url = await _uploadFile(file, tipo);
      updateData['url'] = url;
    }
    await _recursosCollection.doc(id).update(updateData);
  }

  Future<void> deleteRecursoEducativo(String id) async {
    // Primero, obtén el documento para conseguir la URL del archivo
    DocumentSnapshot doc = await _recursosCollection.doc(id).get();
    String url = (doc.data() as Map<String, dynamic>)['url'] ?? '';

    // Elimina el archivo de Firebase Storage
    if (url.isNotEmpty) {
      try {
        await FirebaseStorage.instance.refFromURL(url).delete();
      } catch (e) {
        print("Error deleting file from storage: $e");
      }
    }

    // Luego, elimina el documento de Firestore
    await _recursosCollection.doc(id).delete();
  }
}