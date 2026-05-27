// mobile/lib/models/modelos_seguridad.dart

enum Permiso {
  gestionarUsuarios,
  gestionarRoles,
  verTodosLosDatos,
  editarTodosLosDatos,
  eliminarTodosLosDatos,
  verPacientes,
  editarPacientes,
  crearCitas,
  verHistorialMedico,
  editarHistorialMedico,
}

enum RolUsuario {
  administrador,
  doctor,
  enfermero,
}