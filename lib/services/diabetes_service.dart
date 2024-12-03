import 'package:http/http.dart' as http;
import 'dart:convert';

class DiabetesService {
  final String apiUrl = "https://glucofit-modelo.onrender.com/predict";

  Future<String> checkDiabetesStatus(Map<String, dynamic> data) async {
    try {
      var url = Uri.parse(apiUrl);
      var response = await http.post(url,
          body: json.encode(data),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        return result['aptitud'] == 1
            ? "Apto para diabetes"
            : "No apto para diabetes";
      } else {
        return "Error en la predicción";
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }
}
