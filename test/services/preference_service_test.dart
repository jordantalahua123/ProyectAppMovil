import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:gluco_fit/services/preference_service.dart';
import 'package:gluco_fit/models/preference_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

@GenerateMocks([firebase_auth.FirebaseAuth, firebase_auth.User])
import 'preference_service_test.mocks.dart';

void main() {
  late PreferenceService preferenceService;
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeFirestore = FakeFirebaseFirestore();
    preferenceService = PreferenceService(
      firestore: fakeFirestore,
      auth: mockFirebaseAuth,
    );
  });

  group('PreferenceService', () {
    test('saveUserPreferences should save user preferences to Firestore', () async {
      // Arrange
      final mockUser = MockUser();
      when(mockUser.uid).thenReturn('test-uid');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      final preferences = UserPreferences(
        likesFrutas: false,
        likesVerduras: true,
        likesLacteos: false,
        likesProteinas: true,
        likesSemillas: false,
        favoriteRegions: ['Amazonía'],
      );

      // Act
      await preferenceService.saveUserPreferences(preferences);

      // Assert
      final docSnapshot = await fakeFirestore.collection('user_preferences').doc('test-uid').get();
      expect(docSnapshot.exists, true);
      expect(docSnapshot.data()?['likesFrutas'], false);
      expect(docSnapshot.data()?['favoriteRegions'], ['Amazonía']);
    });

    test('getUserPreferences should return user preferences if they exist', () async {
      // Arrange
      final mockUser = MockUser();
      when(mockUser.uid).thenReturn('test-uid');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      await fakeFirestore.collection('user_preferences').doc('test-uid').set({
        'likesFrutas': false,
        'likesVerduras': true,
        'likesLacteos': false,
        'likesProteinas': true,
        'likesSemillas': false,
        'favoriteRegions': ['Amazonía'],
      });

      // Act
      final result = await preferenceService.getUserPreferences();

      // Assert
      expect(result, isNotNull);
      expect(result?.likesFrutas, false);
      expect(result?.favoriteRegions, ['Amazonía']);
    });

    test('getUserPreferences should return null if no preferences exist', () async {
      // Arrange
      final mockUser = MockUser();
      when(mockUser.uid).thenReturn('test-uid');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      // Act
      final result = await preferenceService.getUserPreferences();

      // Assert
      expect(result, isNull);
    });

    test('hasUserPreferences should return true if preferences exist', () async {
      // Arrange
      final mockUser = MockUser();
      when(mockUser.uid).thenReturn('test-uid');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      await fakeFirestore.collection('user_preferences').doc('test-uid').set({
        'likesFrutas': true,
      });

      // Act
      final result = await preferenceService.hasUserPreferences();

      // Assert
      expect(result, true);
    });

    test('hasUserPreferences should return false if preferences do not exist', () async {
      // Arrange
      final mockUser = MockUser();
      when(mockUser.uid).thenReturn('test-uid');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      // Act
      final result = await preferenceService.hasUserPreferences();

      // Assert
      expect(result, false);
    });

    test('should throw exception if no user is logged in', () async {
      // Arrange
      when(mockFirebaseAuth.currentUser).thenReturn(null);

      // Act & Assert
      expect(
        () => preferenceService.saveUserPreferences(UserPreferences()),
        throwsA(isA<Exception>()),
      );
      expect(
        () => preferenceService.getUserPreferences(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
