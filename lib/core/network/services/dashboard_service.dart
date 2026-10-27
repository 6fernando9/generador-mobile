// Dashboard Service for KrakenDraw - Handles dashboard endpoints
import 'package:dio/dio.dart';
import '../api_client.dart';
import '../api_endpoints.dart';

/// Dashboard service handling dashboard-related endpoints
class DashboardService {
  final Dio _dio;

  DashboardService() : _dio = ApiClient.instance.dio;

  /// Get dashboard summary/resumen (KPIs)
  Future<Map<String, dynamic>> getResumen({String? tz}) async {
    final queryParams = <String, dynamic>{};
    if (tz != null) queryParams['tz'] = tz;

    final response = await _dio.get(
      ApiEndpoints.dashboardResumen,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return _handleResponse(response);
  }

  /// Get memberships/metrics data
  Future<Map<String, dynamic>> getMembresias({String? tz}) async {
    final queryParams = <String, dynamic>{};
    if (tz != null) queryParams['tz'] = tz;

    final response = await _dio.get(
      ApiEndpoints.dashboardMembresias,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return _handleResponse(response);
  }

  /// Get trend data (time series)
  Future<Map<String, dynamic>> getTendencia({String? tz}) async {
    final queryParams = <String, dynamic>{};
    if (tz != null) queryParams['tz'] = tz;

    final response = await _dio.get(
      ApiEndpoints.dashboardTendencia,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return _handleResponse(response);
  }

  /// Get activity heatmap
  Future<Map<String, dynamic>> getActividad({String? tz}) async {
    final queryParams = <String, dynamic>{};
    if (tz != null) queryParams['tz'] = tz;

    final response = await _dio.get(
      ApiEndpoints.dashboardActividad,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return _handleResponse(response);
  }

  /// Get technologies distribution
  Future<Map<String, dynamic>> getTecnologias() async {
    final response = await _dio.get(ApiEndpoints.dashboardTecnologias);
    return _handleResponse(response);
  }

  /// Get projects & users data
  Future<Map<String, dynamic>> getProyectosUsuarios() async {
    final response = await _dio.get(ApiEndpoints.dashboardProyectosUsuarios);
    return _handleResponse(response);
  }

  /// Get contacts metrics
  Future<Map<String, dynamic>> getContactos() async {
    final response = await _dio.get(ApiEndpoints.dashboardContactos);
    return _handleResponse(response);
  }

  /// Get all dashboard data at once (for initial load)
  Future<Map<String, dynamic>> getAll({String? tz}) async {
    final results = await Future.wait([
      getResumen(tz: tz),
      getMembresias(tz: tz),
      getTendencia(tz: tz),
      getActividad(tz: tz),
      getTecnologias(),
      getProyectosUsuarios(),
      getContactos(),
    ]);

    return {
      'resumen': results[0],
      'membresias': results[1],
      'tendencia': results[2],
      'actividad': results[3],
      'tecnologias': results[4],
      'proyectosUsuarios': results[5],
      'contactos': results[6],
    };
  }

  /// Handle API response
  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data as Map<String, dynamic>;
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data,
      message: response.data['message'] ?? 'Error en la solicitud',
    );
  }
}