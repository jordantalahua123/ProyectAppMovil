import 'package:flutter/material.dart';
import '../models/consejo_expertos_model.dart';
import '../services/consejo_expertos_services.dart';

class ConsejosView extends StatelessWidget {
  final ConsejoExpertoService consejoService = ConsejoExpertoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consejos de Salud'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<ConsejoExperto>>(
        future: consejoService.getConsejos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los consejos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay consejos disponibles'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final consejo = snapshot.data![index];
                  return _buildConsejoCard(
                    consejo.nombre,
                    consejo.consejo,
                    Icons
                        .health_and_safety, // Puedes personalizar el ícono según sea necesario
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildConsejoCard(String title, String description, IconData icon,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.teal,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
