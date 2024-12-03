import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:gluco_fit/controllers/auth_controller.dart';
import 'package:gluco_fit/models/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

@GenerateMocks([firebase_auth.FirebaseAuth, firebase_auth.UserCredential, firebase_auth.User])
import 'auth_controller_test.mocks.dart';

void main() {
  late AuthController authController;
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeFirestore = FakeFirebaseFirestore();
    authController = AuthController(
      auth: mockFirebaseAuth,
      firestore: fakeFirestore,
    );
  });

  group('AuthController', () {
    test('registerUser should create a new user', () async {
      // Arrange
      final email = 'test@example.com';
      final password = 'password123';
      final nombre = 'Test User';
      final edad = 25;
      final genero = 'Masculino';

      final mockUser = MockUser();
      final mockUserCredential = MockUserCredential();
      
      when(mockUser.uid).thenReturn('test-uid');
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);

      // Act
      final result = await authController.registerUser(email, password, nombre, edad, genero);

      // Assert
      expect(result, isA<User>());
      expect(result?.email, email);
      expect(result?.nombre, nombre);
      expect(result?.edad, edad);
      expect(result?.genero, genero);
      
      final docSnapshot = await fakeFirestore.collection('users').doc('test-uid').get();
      expect(docSnapshot.exists, true);
      expect(docSnapshot.data()?['email'], email);
    });

    test('signIn should authenticate user and return User object', () async {
      // Arrange
      final email = 'test@example.com';
      final password = 'password123';

      final mockUser = MockUser();
      final mockUserCredential = MockUserCredential();
      
      when(mockUser.uid).thenReturn('test-uid');
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);

      await fakeFirestore.collection('users').doc('test-uid').set({
        'email': email,
        'nombre': 'Test User',
        'edad': 25,
        'genero': 'Masculino',
        'createdAt': Timestamp.now(),
      });

      // Act
      final result = await authController.signIn(email, password);

      // Assert
      expect(result, isA<User>());
      expect(result?.email, email);
    });

    test('signOut should sign out the user', () async {
      // Arrange
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async => {});

      // Act
      await authController.signOut();

      // Assert
      verify(mockFirebaseAuth.signOut()).called(1);
    });

    test('getCurrentUser should return current user if authenticated', () async {
      // Arrange
      final mockUser = MockUser();
      when(mockUser.uid).thenReturn('test-uid');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      await fakeFirestore.collection('users').doc('test-uid').set({
        'email': 'test@example.com',
        'nombre': 'Test User',
        'edad': 25,
        'genero': 'Masculino',
        'createdAt': Timestamp.now(),
      });

      // Act
      final result = await authController.getCurrentUser();

      // Assert
      expect(result, isA<User>());
      expect(result?.uid, 'test-uid');
    });
  });
}