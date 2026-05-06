import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart'; // Importamos el servicio anterior

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000";

  Future<bool> crearEstacion(String nombre, String ubicacion) async {
    // 1. Buscamos el token en la memoria del celular
    final token = await AuthService().getToken();

    // 2. Enviamos la petición con el header de Authorization
    final response = await http.post(
      Uri.parse('$baseUrl/estaciones/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Aquí pegamos el token
      },
      body: jsonEncode({'nombre': nombre, 'ubicacion': ubicacion}),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
