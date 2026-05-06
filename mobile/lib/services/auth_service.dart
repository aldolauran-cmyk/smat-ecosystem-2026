import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // No necesitamos el baseUrl por ahora porque usaremos el truco
  final String baseUrl = "http://localhost:8000"; 

  Future<bool> login(String username, String password) async {
    // Simulamos que el servidor nos dio permiso
    final String token = "token_de_prueba_aldo_123"; 
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token); 
    
    return true; 
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
