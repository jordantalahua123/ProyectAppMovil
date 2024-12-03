import 'package:flutter/material.dart';
import '../controllers/rating_controller.dart';

class RatingView extends StatefulWidget {
  const RatingView({Key? key}) : super(key: key);

  @override
  _RatingViewState createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  int _selectedRating = 0;
  final _feedbackController = TextEditingController();
  final RatingController _ratingController = RatingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _onRatingSelected(int index) {
    setState(() {
      _selectedRating = index + 1;
    });
  }

  void _submitFeedback() async {
    if (_selectedRating == 0) {
      // Opcionalmente maneja el caso en el que no se seleccione una calificación
      return;
    }

    await _ratingController.submitRating(
      _selectedRating,
      _feedbackController.text,
    );

    Navigator.pop(context); // Regresa después de enviar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Califica nuestra aplicación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '¿Cómo calificarías nuestra aplicación?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => _onRatingSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      _selectedRating > index ? Icons.star : Icons.star_border,
                      color: _selectedRating > index ? Colors.yellow : Colors.grey,
                      size: _selectedRating > index ? 40 : 30,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                labelText: 'Deja tu comentario (opcional)',
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Enviar',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
