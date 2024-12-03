import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gluco_fit/main.dart';
import 'package:gluco_fit/views/auth_view.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  setUpAll(() async {
    // Inicializa Firebase
    await Firebase.initializeApp();
  });

  testWidgets('Auth view smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our AuthView is present
    expect(find.byType(AuthView), findsOneWidget);

    // Verify that we have input fields for email and password
    expect(find.byType(TextField), findsNWidgets(2));

    // Verify that we have buttons for sign up and sign in
    expect(find.byType(ElevatedButton), findsNWidgets(2));

    // You can add more specific tests here based on your AuthView implementation
  });
}
