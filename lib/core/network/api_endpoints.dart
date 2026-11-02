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

  // Dashboard personal (BI) endpoints
  static const String dashboardResumen = '/dashboard/mi-resumen';
  static const String dashboardTendencia = '/dashboard/mi-tendencia';
  static const String dashboardTecnologias = '/dashboard/mi-tecnologias';
  static const String dashboardTecnologiasProyecto =
      '/dashboard/mi-tecnologias/proyecto';
  static const String dashboardTecnologiasReporte =
      '/dashboard/mi-tecnologias/reporte';
  static const String dashboardCatalogos = '/dashboard/mi-catalogos';
  static const String dashboardActividad = '/dashboard/mi-actividad';
  static const String dashboardProyectos = '/dashboard/mis-proyectos';

  // Pagos endpoints
  static const String pagosMiSuscripcion = '/pagos/mi-suscripcion';
  static const String pagosHistorial = '/pagos/historial';
  static const String pagosCheckout = '/pagos/checkout';
  static const String pagosVerificarSesion = '/pagos/verificar-sesion';
  static const String pagosSincronizarPendientes =
      '/pagos/sincronizar-pendientes';

  // Logs (Download history) endpoints
  static const String logsMisLogs = '/logs/mis-logs';
  static const String logsMisLogsFilterOptions =
      '/logs/mis-logs/filter-options';
  static const String logs = '/logs/';
  static const String logsDetail = '/logs/:id';
  static const String logsPublicDetail = '/logs/public/:id';
  static const String logsRegenerarProyecto = '/logs/:id/regenerar-proyecto';
  static const String logsRegenerarReporte = '/logs/:id/regenerar-reporte';

  // Generación de artefactos (catálogos del modal de regeneración)
  static const String generacionOpciones = '/generacion/opciones';

  // Exportación SQL/XML (catálogos)
  static const String exportarOpciones = '/exportar/opciones';
}
