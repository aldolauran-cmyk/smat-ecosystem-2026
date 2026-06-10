// mobile/lib/enrutador.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'models/modelos_seguridad.dart';
import 'services/administrador_roles.dart';

// Pantallas básicas de prueba para el ecosistema
class PaginaDashboard extends StatelessWidget { const PaginaDashboard({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Panel Principal (Dashboard)'))); }
class PaginaPacientes extends StatelessWidget { const PaginaPacientes({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Sección de Pacientes'))); }
class PaginaNoAutorizado extends StatelessWidget { const PaginaNoAutorizado({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Acceso Restringido')), body: const Center(child: Text('No cuentas con los permisos necesarios para ver esto.'))); }

// Simulación temporal del rol del usuario (para pruebas de desarrollo)
RolUsuario obtenerRolDelUsuario() { 
  return RolUsuario.enfermero; // Cambia a 'administrador' o 'doctor' para probar cómo reacciona la navegación
}

final GoRouter enrutadorApp = GoRouter( 
  initialLocation: '/dashboard',
  routes: [ 
    GoRoute( 
      path: '/dashboard', 
      builder: (context, state) => const PaginaDashboard(), 
      redirect: (context, state) { 
        final rol = obtenerRolDelUsuario(); 
        // Si no tiene acceso a los datos generales, lo bloquea
        if (!AdministradorRoles.tienePermiso(rol, Permiso.verTodosLosDatos)) { 
          return '/unauthorized'; 
        } 
        return null; 
      }, 
    ), 
    GoRoute( 
      path: '/patients', 
      builder: (context, state) => const PaginaPacientes(), 
      redirect: (context, state) { 
        final rol = obtenerRolDelUsuario(); 
        // Si no tiene acceso a pacientes, lo desvía
        if (!AdministradorRoles.tienePermiso(rol, Permiso.verPacientes)) { 
          return '/unauthorized'; 
        } 
        return null; 
      }, 
    ), 
    GoRoute(
      path: '/unauthorized', 
      builder: (context, state) => const PaginaNoAutorizado(), 
    ), 
  ], 
);