import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rating_model.dart';

class RatingController {
  final CollectionReference _ratingsCollection =
      FirebaseFirestore.instance.collection('ratings');

  // Método para enviar la calificación a Firebase
  Future<void> submitRating(int rating, String feedback) async {
    final ratingModel = Rating(
      id: _ratingsCollection.doc().id,
      rating: rating,
      feedback: feedback,
    );

    try {
      await _ratingsCollection.doc(ratingModel.id).set(ratingModel.toMap());
      print('Rating submitted successfully');
    } catch (e) {
      print('Failed to submit rating: $e');
    }
  }
}
