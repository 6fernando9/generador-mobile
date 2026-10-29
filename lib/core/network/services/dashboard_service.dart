// Dashboard Service for KrakenDraw - Handles dashboard endpoints
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mobile/data/models/dashboard_actividad.dart';
import 'package:mobile/data/models/dashboard_proyectos.dart';
import 'package:mobile/data/models/dashboard_resumen.dart';
import 'package:mobile/data/models/dashboard_tecnologias.dart';
import 'package:mobile/data/models/dashboard_tendencia.dart';
import '../api_client.dart';
import '../api_endpoints.dart';

/// Dashboard service handling dashboard-related endpoints
class DashboardService {
  final Dio _dio;

  DashboardService() : _dio = ApiClient.instance.dio;

  /// Get dashboard summary/resumen (KPIs)
  Future<DashboardResumen> getResumen({String? tz}) async {
    final queryParams = <String, dynamic>{};
    if (tz != null) queryParams['tz'] = tz;

    try {
      final response = await _dio.get(
        ApiEndpoints.dashboardResumen,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final data = _handleResponse(response);
      print('✅ Dashboard Resumen loaded: ${data.keys.toList()}');
      return DashboardResumen.fromJson(data);
    } catch (e, stackTrace) {
      print('❌ Error loading Dashboard Resumen: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get memberships/metrics data
  Future<Map<String, dynamic>> getMembresias({String? tz}) async {
    final queryParams = <String, dynamic>{};
    if (tz != null) queryParams['tz'] = tz;

    try {
      final response = await _dio.get(
        ApiEndpoints.dashboardMembresias,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final data = _handleResponse(response);
      print('✅ Dashboard Membresias loaded');
      return data;
    } catch (e, stackTrace) {
      print('❌ Error loading Dashboard Membresias: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get trend data (time series)
  Future<DashboardTendencia> getTendencia({String? tz}) async {
    final queryParams = <String, dynamic>{};
    if (tz != null) queryParams['tz'] = tz;

    try {
      final response = await _dio.get(
        ApiEndpoints.dashboardTendencia,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final data = _handleResponse(response);
      print('✅ Dashboard Tendencia loaded: ${data['total']} total, ${data['serie']?.length ?? 0} points');
      return DashboardTendencia.fromJson(data);
    } catch (e, stackTrace) {
      print('❌ Error loading Dashboard Tendencia: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get activity heatmap
  Future<DashboardActividad> getActividad({String? tz}) async {
    final queryParams = <String, dynamic>{};
    if (tz != null) queryParams['tz'] = tz;

    try {
      final response = await _dio.get(
        ApiEndpoints.dashboardActividad,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final data = _handleResponse(response);
      print('✅ Dashboard Actividad loaded: total=${data['total']}, heatmap=${data['heatmap']?.length ?? 0} points');
      return DashboardActividad.fromJson(data);
    } catch (e, stackTrace) {
      print('❌ Error loading Dashboard Actividad: $e');
      print('Stack trace: $stackTrace');
      // Print the raw response for debugging
      rethrow;
    }
  }

  /// Get technologies distribution
  Future<DashboardTecnologias> getTecnologias() async {
    try {
      final response = await _dio.get(ApiEndpoints.dashboardTecnologias);
      final data = _handleResponse(response);
      print('✅ Dashboard Tecnologías loaded: ${data['lenguajes']?.length ?? 0} languages, ${data['frameworks']?.length ?? 0} frameworks');
      return DashboardTecnologias.fromJson(data);
    } catch (e, stackTrace) {
      print('❌ Error loading Dashboard Tecnologías: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get projects & users data
  Future<DashboardProyectos> getProyectosUsuarios() async {
    try {
      final response = await _dio.get(ApiEndpoints.dashboardProyectosUsuarios);
      final data = _handleResponse(response);
      print('✅ Dashboard Proyectos loaded: ${data['proyectos']?.length ?? 0} projects, ${data['usuarios']?.length ?? 0} users');
      return DashboardProyectos.fromJson(data);
    } catch (e, stackTrace) {
      print('❌ Error loading Dashboard Proyectos: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get contacts metrics
  Future<Map<String, dynamic>> getContactos() async {
    try {
      final response = await _dio.get(ApiEndpoints.dashboardContactos);
      final data = _handleResponse(response);
      print('✅ Dashboard Contactos loaded');
      return data;
    } catch (e, stackTrace) {
      print('❌ Error loading Dashboard Contactos: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get all dashboard data at once (for initial load)
  Future<Map<String, dynamic>> getAll({String? tz}) async {
    try {
      final results = await Future.wait([
        getResumen(tz: tz),
        getMembresias(tz: tz),
        getTendencia(tz: tz),
        getActividad(tz: tz),
        getTecnologias(),
        getProyectosUsuarios(),
        getContactos(),
      ]);

      print('✅ All dashboard data loaded successfully');
      return {
        'resumen': results[0],
        'membresias': results[1],
        'tendencia': results[2],
        'actividad': results[3],
        'tecnologias': results[4],
        'proyectosUsuarios': results[5],
        'contactos': results[6],
      };
    } catch (e, stackTrace) {
      print('❌ Error loading all dashboard data: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Handle API response
  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data;
      }
      print('⚠️ Unexpected response type: ${data.runtimeType}');
      return <String, dynamic>{};
    }
    final errorMessage = response.data?['message'] ?? 'Error en la solicitud (${response.statusCode})';
    print('❌ API Error (${response.statusCode}): $errorMessage');
    print('❌ Response data: ${jsonEncode(response.data)}');
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data,
      message: errorMessage,
    );
  }
}