// Dashboard Service for KrakenDraw - Handles personal dashboard endpoints
import 'package:dio/dio.dart';
import 'package:mobile/data/models/dashboard_actividad.dart';
import 'package:mobile/data/models/dashboard_catalogos.dart';
import 'package:mobile/data/models/dashboard_proyectos.dart';
import 'package:mobile/data/models/dashboard_resumen.dart';
import 'package:mobile/data/models/dashboard_tecnologias.dart';
import 'package:mobile/data/models/dashboard_tendencia.dart';

import '../api_client.dart';
import '../api_endpoints.dart';

/// Dashboard service handling the personal (BI) dashboard endpoints.
class DashboardService {
  final Dio _dio;

  DashboardService() : _dio = ApiClient.instance.dio;

  /// KPIs personales: hoy, semana, mes y total histórico.
  Future<DashboardResumen> getResumen({String? tz}) async {
    final response = await _dio.get(
      ApiEndpoints.dashboardResumen,
      queryParameters: _query({'tz': tz}),
    );
    return DashboardResumen.fromJson(_handleResponse(response));
  }

  /// Serie temporal personal con desglose por tipo de artefacto.
  Future<DashboardTendencia> getTendencia({
    String? tz,
    DateTime? desde,
    DateTime? hasta,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.dashboardTendencia,
      queryParameters: _query({
        'tz': tz,
        'desde': _fecha(desde),
        'hasta': _fecha(hasta),
      }),
    );
    return DashboardTendencia.fromJson(_handleResponse(response));
  }

  /// Distribuciones tecnológicas según la vista seleccionada.
  ///
  /// [filtros] usa como clave el `apiKey` de [TecnologiaCategoria] y como valor
  /// los IDs a los que se quiere restringir la respuesta.
  Future<DashboardTecnologias> getTecnologias({
    DashboardTecnologiaVista vista = DashboardTecnologiaVista.total,
    String? tz,
    DateTime? desde,
    DateTime? hasta,
    Map<String, Set<int>> filtros = const {},
  }) async {
    final path = switch (vista) {
      DashboardTecnologiaVista.total => ApiEndpoints.dashboardTecnologias,
      DashboardTecnologiaVista.proyecto =>
        ApiEndpoints.dashboardTecnologiasProyecto,
      DashboardTecnologiaVista.reporte =>
        ApiEndpoints.dashboardTecnologiasReporte,
    };

    final validKeys = vista.categorias.map((c) => c.apiKey).toSet();
    final filtrosValidos = <String, String>{
      for (final entry in filtros.entries)
        if (validKeys.contains(entry.key) && entry.value.isNotEmpty)
          entry.key: entry.value.join(','),
    };

    final response = await _dio.get(
      path,
      queryParameters: _query({
        'tz': tz,
        'desde': _fecha(desde),
        'hasta': _fecha(hasta),
        ...filtrosValidos,
      }),
    );
    return DashboardTecnologias.fromJson(_handleResponse(response));
  }

  /// Catálogo con solo los valores que el usuario ya utilizó.
  Future<DashboardCatalogos> getCatalogos() async {
    final response = await _dio.get(ApiEndpoints.dashboardCatalogos);
    return DashboardCatalogos.fromJson(_handleResponse(response));
  }

  /// Mapa de calor personal (día de la semana × hora).
  Future<DashboardActividad> getActividad({
    String? tz,
    DateTime? desde,
    DateTime? hasta,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.dashboardActividad,
      queryParameters: _query({
        'tz': tz,
        'desde': _fecha(desde),
        'hasta': _fecha(hasta),
      }),
    );
    return DashboardActividad.fromJson(_handleResponse(response));
  }

  /// Top de proyectos personales por generaciones.
  Future<DashboardProyectos> getMisProyectos({
    DateTime? desde,
    DateTime? hasta,
    int? limite,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.dashboardProyectos,
      queryParameters: _query({
        'desde': _fecha(desde),
        'hasta': _fecha(hasta),
        'limite': limite,
      }),
    );
    return DashboardProyectos.fromJson(_handleResponse(response));
  }

  Map<String, dynamic> _query(Map<String, Object?> params) {
    return <String, dynamic>{
      for (final entry in params.entries)
        if (entry.value != null && entry.value.toString().isNotEmpty)
          entry.key: entry.value,
    };
  }

  /// Serializa a ISO-8601 en UTC; el backend lo interpreta con `new Date(...)`.
  String? _fecha(DateTime? value) => value?.toUtc().toIso8601String();

  Map<String, dynamic> _handleResponse(Response<dynamic> response) {
    final status = response.statusCode;
    if (status == 200 || status == 201) {
      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      return <String, dynamic>{};
    }

    final errorMessage = response.data is Map
        ? (response.data['message']?.toString() ?? 'Error en la solicitud')
        : 'Error en la solicitud ($status)';
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data,
      message: errorMessage,
    );
  }
}
