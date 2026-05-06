import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // 10.0.2.2 es la dirección para conectar el emulador de Android con tu PC (localhost)
  final String baseUrl = "http://10.0.2.2:8000";

  // Intentar iniciar sesión
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/token'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String token = data['access_token'];

        // Guardar el Token en la memoria del celular
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        return true;
      }
    } catch (e) {
      print("Error de conexión: $e");
    }
    return false;
  }

  // Obtener el token guardado para otras peticiones
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Borrar el token al cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
