import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/preference_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  final firebase_auth.FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final PreferenceService _preferenceService;

  AuthController({
    firebase_auth.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    PreferenceService? preferenceService,
  })  : this.auth = auth ?? firebase_auth.FirebaseAuth.instance,
        this.firestore = firestore ?? FirebaseFirestore.instance,
        this._preferenceService = preferenceService ?? PreferenceService(
          firestore: FirebaseFirestore.instance,
          auth: firebase_auth.FirebaseAuth.instance,
        );

  Future<User?> registerUser(String email, String password, String nombre, int edad, String genero) async {
    try {
      final result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = User(
        uid: result.user!.uid,
        email: email,
        nombre: nombre,
        edad: edad,
        genero: genero,
        createdAt: DateTime.now(),
      );

      await firestore.collection('users').doc(user.uid).set(user.toFirestore());
      return user;
    } catch (e) {
      print('Error en el registro: $e');
      rethrow;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final doc = await firestore.collection('users').doc(result.user!.uid).get();
      return User.fromFirestore(doc.data()!, doc.id);
    } catch (e) {
      print('Error en el inicio de sesión: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = auth.currentUser;
      if (firebaseUser != null) {
        final doc = await firestore.collection('users').doc(firebaseUser.uid).get();
        if (doc.exists) {
          return User.fromFirestore(doc.data()!, doc.id);
        }
      }
      return null;
    } catch (e) {
      print('Error al obtener el usuario actual: $e');
      return null;
    }
  }

  Future<bool> isFirstTimeUser() async {
    final user = await getCurrentUser();
    if (user != null) {
      return !(await _preferenceService.hasUserPreferences());
    }
    return false;
  }
}