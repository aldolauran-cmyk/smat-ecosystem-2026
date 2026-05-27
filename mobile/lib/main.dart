// mobile/lib/main.dart

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_page.dart';
import 'services/auth_service.dart';
import 'models/modelos_seguridad.dart'; // <-- Añadido
import 'services/administrador_roles.dart'; // <-- Añadido

void main() => runApp(const SMATApp());

class SMATApp extends StatelessWidget {
  const SMATApp({super.key});

  // Esta función hace el trabajo doble: verifica el Token y el Rol al mismo tiempo
  Future<Map<String, dynamic>> _verificarAutenticacionYRol() async {
    final authService = AuthService();
    
    // 1. Buscamos el token como ya lo hacías
    final token = await authService.getToken();
    
    // 2. Buscamos el rol del usuario (si no hay, por defecto es enfermero)
    final prefs = await authService.getRol(); 
    
    // 3. Convertimos el texto del rol al Enum que creamos en tus modelos
    final rolUsuario = RolUsuario.values.firstWhere(
      (e) => e.name == prefs,
      orElse: () => RolUsuario.enfermero,
    );

    return {
      'autenticado': token != null,
      'rol': rolUsuario,
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Map<String, dynamic>>(
        future: _verificarAutenticacionYRol(), // <-- Nuestra nueva verificación
        builder: (context, snapshot) {
          // Mientras carga, muestra el círculo de progreso igual que antes
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          // Si el usuario está autenticado, evaluamos su rol
          if (snapshot.hasData && snapshot.data!['autenticado'] == true) {
            final RolUsuario rol = snapshot.data!['rol'];

            // 🛡️ CONTROL DE ACCESO (RBAC):
            // Aquí decides qué permiso mínimo se necesita para entrar a la HomePage.
            // Por ejemplo, que tenga el permiso de 'verPacientes'.
            if (AdministradorRoles.tienePermiso(rol, Permiso.verPacientes)) {
              return const HomePage();
            } else {
              // Si está logueado pero no tiene permisos para esta app:
              return const Scaffold(
                body: Center(
                  child: Text(
                    'Acceso Restringido\nNo tienes permisos para ingresar a este panel.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              );
            }
          }

          // Si no hay datos o no está autenticado, va al Login
          return const LoginScreen();
        },
      ),
    );
  }
}