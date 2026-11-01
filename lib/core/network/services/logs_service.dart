// Logs Service for KrakenDraw - Handles generation logs/history endpoints.
import 'package:dio/dio.dart';
import 'package:mobile/data/models/log_models.dart';

import '../api_client.dart';
import '../api_endpoints.dart';

/// Logs service handling the personal generation history.
class LogsService {
  final Dio _dio;

  LogsService({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  /// Historial personal paginado con filtros.
  Future<PaginatedLogs> getMisLogs({
    int page = 1,
    int perPage = 10,
    String? search,
    int? tipoArtefactoId,
    int? lenguajeId,
    int? frameworkId,
    int? arquitecturaId,
    int? ormId,
    int? baseDatosId,
    int? tipoReporteId,
    int? tipoXmlId,
    String? versionGenerador,
    DateTime? desde,
    DateTime? hasta,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.logsMisLogs,
      queryParameters: _query({
        'page': page,
        'perPage': perPage,
        'search': search,
        'tipo_artefacto_id': tipoArtefactoId,
        'lenguaje_id': lenguajeId,
        'framework_id': frameworkId,
        'arquitectura_id': arquitecturaId,
        'orm_id': ormId,
        'base_datos_id': baseDatosId,
        'tipo_reporte_id': tipoReporteId,
        'tipo_xml_id': tipoXmlId,
        'version_generador': versionGenerador,
        'created_desde': _fecha(desde),
        'created_hasta': _fecha(hasta),
      }),
    );
    return PaginatedLogs.fromJson(_handleResponse(response));
  }

  /// Catálogos disponibles para los filtros avanzados.
  Future<LogFilterOptions> getFilterOptions() async {
    final response = await _dio.get(ApiEndpoints.logsMisLogsFilterOptions);
    return LogFilterOptions.fromJson(_handleResponse(response));
  }

  /// Get single log detail with diagram snapshot
  Future<Map<String, dynamic>> getLogDetail(String id) async {
    final response = await _dio.get(
      ApiEndpoints.logsDetail.replaceAll(':id', id),
    );
    return _handleResponse(response);
  }

  /// Regenerate and download ZIP artifact
  Future<Map<String, dynamic>> regenerar(String id) async {
    final response = await _dio.post(
      ApiEndpoints.logsRegenerar.replaceAll(':id', id),
    );
    return _handleResponse(response);
  }

  Map<String, dynamic> _query(Map<String, Object?> params) {
    return <String, dynamic>{
      for (final entry in params.entries)
        if (entry.value != null && entry.value.toString().isNotEmpty)
          entry.key: entry.value,
    };
  }

  /// ISO-8601 en UTC; el backend lo interpreta con `new Date(...)`.
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
