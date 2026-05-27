// mobile/lib/services/administrador_roles.dart

import '../models/modelos_seguridad.dart';

class AdministradorRoles {
  // Mapa de permisos asignados a cada rol
  static final Map<RolUsuario, List<Permiso>> permisosPorRol = {
    RolUsuario.administrador: [
      Permiso.gestionarUsuarios,
      Permiso.gestionarRoles,
      Permiso.verTodosLosDatos,
      Permiso.editarTodosLosDatos,
      Permiso.eliminarTodosLosDatos,
      Permiso.verPacientes,
      Permiso.editarPacientes,
    ],
    RolUsuario.doctor: [
      Permiso.verPacientes,
      Permiso.editarPacientes,
      Permiso.crearCitas,
      Permiso.verHistorialMedico,
      Permiso.editarHistorialMedico,
    ],
    RolUsuario.enfermero: [
      Permiso.verPacientes,
      Permiso.crearCitas,
      Permiso.verHistorialMedico,
    ],
  };

  // Función para comprobar si un rol específico tiene un permiso determinado
  static bool tienePermiso(RolUsuario rol, Permiso permiso) {
    return permisosPorRol[rol]?.contains(permiso) ?? false;
  }
}