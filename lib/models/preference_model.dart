class UserPreferences {
  bool likesFrutas;
  bool likesVerduras;
  bool likesLacteos;
  bool likesProteinas;
  bool likesSemillas;
  List<String> favoriteRegions;

  UserPreferences({
    this.likesFrutas = true,
    this.likesVerduras = true,
    this.likesLacteos = true,
    this.likesProteinas = true,
    this.likesSemillas = true,
    List<String>? favoriteRegions,
  }) : this.favoriteRegions = favoriteRegions ?? ['Sierra', 'Costa'];

  Map<String, dynamic> toMap() {
    return {
      'likesFrutas': likesFrutas,
      'likesVerduras': likesVerduras,
      'likesLacteos': likesLacteos,
      'likesProteinas': likesProteinas,
      'likesSemillas': likesSemillas,
      'favoriteRegions': favoriteRegions,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      likesFrutas: map['likesFrutas'] ?? true,
      likesVerduras: map['likesVerduras'] ?? true,
      likesLacteos: map['likesLacteos'] ?? true,
      likesProteinas: map['likesProteinas'] ?? true,
      likesSemillas: map['likesSemillas'] ?? true,
      favoriteRegions: List<String>.from(map['favoriteRegions'] ?? ['Sierra', 'Costa']),
    );
  }
}