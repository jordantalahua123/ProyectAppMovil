import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/preference_model.dart';

class PreferenceService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PreferenceService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  Future<void> saveUserPreferences(UserPreferences preferences) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _firestore
          .collection('user_preferences')
          .doc(userId)
          .set(preferences.toMap());
    } else {
      throw Exception('No user logged in');
    }
  }

  Future<UserPreferences?> getUserPreferences() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final doc =
          await _firestore.collection('user_preferences').doc(userId).get();
      if (doc.exists) {
        return UserPreferences.fromMap(doc.data()!);
      } else {
        return null; // Return null if no preferences exist
      }
    }
    throw Exception('No user logged in');
  }

  Future<bool> hasUserPreferences() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final doc =
          await _firestore.collection('user_preferences').doc(userId).get();
      return doc.exists;
    }
    return false;
  }

  Future<UserPreferences?> fetchUserPreferences() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final doc =
            await _firestore.collection('user_preferences').doc(userId).get();
        if (doc.exists) {
          return UserPreferences.fromMap(doc.data()!);
        } else {
          return null; // Devuelve null si no existen preferencias
        }
      } else {
        throw Exception('No user logged in');
      }
    } catch (e) {
      print('Error fetching user preferences: $e');
      return null;
    }
  }
}
