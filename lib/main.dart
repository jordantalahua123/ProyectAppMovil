import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/auth_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print('Conexión exitosa a Firebase');
  } catch (e) {
    print('Error al conectar con Firebase: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth MVC Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthView(),
    );
  }
}
