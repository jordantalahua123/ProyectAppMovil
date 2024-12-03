import 'package:flutter/material.dart';
import '../models/preference_model.dart';
import '../services/preference_service.dart';
import '../views/recipe/recipe_list_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreferenceOnboardingView extends StatefulWidget {
  @override
  _PreferenceOnboardingViewState createState() => _PreferenceOnboardingViewState();
}

class _PreferenceOnboardingViewState extends State<PreferenceOnboardingView> {
  final PageController _pageController = PageController();
  late UserPreferences _preferences;
  final PreferenceService _preferenceService = PreferenceService(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _preferences = UserPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Personaliza tu experiencia')),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          _buildPreferencePage(
            '¿Te gustan las frutas?',
            _preferences.likesFrutas,
            (value) => setState(() => _preferences.likesFrutas = value),
          ),
          _buildPreferencePage(
            '¿Te gustan las verduras?',
            _preferences.likesVerduras,
            (value) => setState(() => _preferences.likesVerduras = value),
          ),
          _buildPreferencePage(
            '¿Te gustan los lácteos?',
            _preferences.likesLacteos,
            (value) => setState(() => _preferences.likesLacteos = value),
          ),
          _buildPreferencePage(
            '¿Te gustan las proteínas?',
            _preferences.likesProteinas,
            (value) => setState(() => _preferences.likesProteinas = value),
          ),
          _buildPreferencePage(
            '¿Te gustan las semillas?',
            _preferences.likesSemillas,
            (value) => setState(() => _preferences.likesSemillas = value),
          ),
          _buildRegionSelectionPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0)
                ElevatedButton(
                  onPressed: () => _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: Text('Anterior'),
                ),
              ElevatedButton(
                onPressed: _currentPage == 5 ? _finishOnboarding : () => _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                child: Text(_currentPage == 5 ? 'Finalizar' : 'Siguiente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferencePage(String question, bool value, ValueChanged<bool> onChanged) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(question, style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 20),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildRegionSelectionPage() {
    List<String> regions = ['Sierra', 'Costa'];
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text('Selecciona tus regiones favoritas:', style: Theme.of(context).textTheme.titleLarge),
        ...regions.map((region) => CheckboxListTile(
          title: Text(region),
          value: _preferences.favoriteRegions.contains(region),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                if (!_preferences.favoriteRegions.contains(region)) {
                  _preferences.favoriteRegions.add(region);
                }
              } else {
                _preferences.favoriteRegions.remove(region);
              }
            });
          },
        )).toList(),
      ],
    );
  }

  void _finishOnboarding() async {
    await _preferenceService.saveUserPreferences(_preferences);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => RecipeListView()),
    );
  }
}