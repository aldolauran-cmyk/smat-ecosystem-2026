// mobile/lib/services/auth_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // No necesitamos el baseUrl por ahora porque usaremos el truco
  final String baseUrl = "http://localhost:8000"; 

  Future<bool> login(String username, String password) async {
    // Simulamos que el servidor nos dio permiso
    final String token = "token_de_prueba_aldo_123"; 
    
    // Simulación: Asignamos un rol al iniciar sesión para probar el RBAC.
    // Puedes cambiarlo aquí por 'doctor' o 'administrador' para probar los accesos.
    final String rolSimulado = "enfermero"; 
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token); 
    await prefs.setString('rol_usuario', rolSimulado); // <-- Guardamos el rol en el dispositivo
    
    return true; 
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // --- NUEVA FUNCIÓN PARA LEER EL ROL EN EL MAIN.DART ---
  Future<String> getRol() async {
    final prefs = await SharedPreferences.getInstance();
    // Si no encuentra ningún rol guardado, por defecto devuelve 'enfermero'
    return prefs.getString('rol_usuario') ?? 'enfermero';
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('rol_usuario'); // <-- Limpiamos también el rol al cerrar sesión
  }
}