// API Endpoints constants for KrakenDraw
/// Centralized API endpoint paths matching Backend-Draw routes

class ApiEndpoints {
  static const String base = '';

  // Auth endpoints
  static const String authRegister = '/auth/register/';
  static const String authLogin = '/auth/login/';
  static const String authLogout = '/auth/logout/';
  static const String authMe = '/auth/me/';

  // Profile (Usuario) endpoints
  static const String perfil = '/perfil/';
  static const String perfilPassword = '/perfil/password';
  static const String perfilIcono = '/perfil/icono';

  // Dashboard endpoints
  static const String dashboardResumen = '/dashboard/resumen';
  static const String dashboardMembresias = '/dashboard/membresias';
  static const String dashboardTendencia = '/dashboard/tendencia';
  static const String dashboardActividad = '/dashboard/actividad';
  static const String dashboardTecnologias = '/dashboard/tecnologias';
  static const String dashboardProyectosUsuarios = '/dashboard/proyectos-usuarios';
  static const String dashboardContactos = '/dashboard/contactos';

  // Pagos endpoints
  static const String pagosMiSuscripcion = '/pagos/mi-suscripcion';
  static const String pagosHistorial = '/pagos/historial';
  static const String pagosCheckout = '/pagos/checkout';
  static const String pagosVerificarSesion = '/pagos/verificar-sesion';
  static const String pagosSincronizarPendientes = '/pagos/sincronizar-pendientes';

  // Logs (Download history) endpoints
  static const String logs = '/logs/';
  static const String logsDetail = '/logs/:id';
  static const String logsRegenerar = '/logs/:id/regenerar';
}