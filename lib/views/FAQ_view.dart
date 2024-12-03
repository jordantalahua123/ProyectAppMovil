import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  final List<FAQItem> faqItems = [
    FAQItem(
      question: '¿Cómo funciona el sistema de preferencias?',
      answer: 'El sistema de preferencias te permite personalizar tu experiencia. Puedes indicar tus alergias, dietas específicas (como vegetariana o sin gluten), y objetivos nutricionales. Basándose en esta información, la aplicación te recomendará recetas y planes de comidas adaptados a tus necesidades.',
    ),
    FAQItem(
      question: '¿Cómo se añaden nuevas recetas?',
      answer: 'Puedes añadir nuevas recetas de dos formas:\n1. Manualmente: Ingresa los ingredientes, pasos de preparación y información nutricional.\n2. Importación: Usa la función de escaneo para importar recetas de libros de cocina o sitios web compatibles.',
    ),
    FAQItem(
      question: '¿Para qué puedo usar esta aplicación nutricional?',
      answer: 'Nuestra aplicación tiene múltiples usos:\n- Planificar comidas saludables\n- Seguir tus objetivos nutricionales\n- Descubrir nuevas recetas\n- Llevar un registro de tu ingesta diaria\n- Aprender sobre nutrición y hábitos alimenticios saludables',
    ),
    FAQItem(
      question: '¿Cómo puedo personalizar mi plan de comidas?',
      answer: 'Puedes personalizar tu plan de comidas ajustando tus preferencias, excluyendo ciertos ingredientes, o seleccionando recetas específicas para cada día. La aplicación te ayudará a mantener un balance nutricional mientras respeta tus elecciones.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB5F1CC), // Fondo verde claro
      appBar: AppBar(
        title: Text('Preguntas Frecuentes', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: faqItems.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ExpansionTile(
              title: Text(
                faqItems[index].question,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    faqItems[index].answer,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}