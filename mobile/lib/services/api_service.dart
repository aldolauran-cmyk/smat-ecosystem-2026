import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/estacion.dart';

class ApiService {
  // IMPORTANTE: Para Chrome usa 127.0.0.1
  final String baseUrl = "http://127.0.0.1:8000";

  Future<List<Estacion>> fetchEstaciones() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/estaciones/'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Estacion.fromJson(data)).toList();
      } else {
        throw Exception('Error del servidor');
      }
    } catch (e) {
      throw Exception('Fallo de red');
    }
  }
}
