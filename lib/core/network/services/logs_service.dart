// Logs Service for KrakenDraw - Handles generation logs/history endpoints.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mobile/data/models/archivo_descarga.dart';
import 'package:mobile/data/models/generacion_models.dart'
    show DatabaseConfiguration;
import 'package:mobile/data/models/log_models.dart';

import '../api_client.dart';

/// Endpoints del historial de generaciones (`/api/logs`).
class _Endpoints {
  static const String misLogs = '/logs/mis-logs';
  static const String misLogsFilterOptions = '/logs/mis-logs/filter-options';
  static const String detalle = '/logs/:id';
  static const String detallePublico = '/logs/public/:id';
  static const String regenerarProyecto = '/logs/:id/regenerar-proyecto';
  static const String regenerarReporte = '/logs/:id/regenerar-reporte';
}

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
      _Endpoints.misLogs,
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
    final response = await _dio.get(_Endpoints.misLogsFilterOptions);
    return LogFilterOptions.fromJson(_handleResponse(response));
  }

  /// Get single log detail with diagram snapshot
  /// Detalle público de una generación (sin autenticación).
  ///
  /// Es el mismo dato que consume el visor web del diagrama.
  Future<LogDetalle> getLogDetallePublico(String id) async {
    final response = await _dio.get(
      _Endpoints.detallePublico.replaceAll(':id', id),
    );
    return LogDetalle.fromJson(_handleResponse(response));
  }

  /// Detalle autenticado de una generación.
  Future<LogDetalle> getLogDetalle(String id) async {
    final response = await _dio.get(
      _Endpoints.detalle.replaceAll(':id', id),
    );
    return LogDetalle.fromJson(_handleResponse(response));
  }

  /// Regenera el proyecto (backend/frontend/mobile) desde el snapshot del log
  /// y devuelve el ZIP como bytes.
  Future<ArchivoDescarga> regenerarProyecto(
    String id, {
    DatabaseConfiguration? databaseConfiguration,
    int? tipoArtefactoId,
    int? lenguajeId,
    int? frameworkId,
    int? ormId,
    int? arquitecturaId,
    int? baseDatosId,
  }) async {
    final body = <String, dynamic>{
      if (databaseConfiguration != null)
        'database_configuration': databaseConfiguration.toJson(),
      'tipo_artefacto_id': ?tipoArtefactoId,
      'lenguaje_id': ?lenguajeId,
      'framework_id': ?frameworkId,
      'orm_id': ?ormId,
      'arquitectura_id': ?arquitecturaId,
      'base_datos_id': ?baseDatosId,
    };

    final response = await _descargar(
      _Endpoints.regenerarProyecto.replaceAll(':id', id),
      body,
    );
    return ArchivoDescarga(
      bytes: response.data ?? const [],
      nombreSugerido: _nombreDesdeHeaders(response),
    );
  }

  /// Regenera una exportación (SQL/XML) desde el snapshot del log.
  Future<ArchivoDescarga> regenerarReporte(
    String id, {
    required int tipoReporteId,
    int? baseDatosDestinoId,
    int? tipoXmlId,
    String? dbName,
  }) async {
    final body = <String, dynamic>{
      'tipo_reporte_id': tipoReporteId,
      'base_datos_destino_id': ?baseDatosDestinoId,
      'tipo_xml_id': ?tipoXmlId,
      if (dbName != null && dbName.trim().isNotEmpty) 'db_name': dbName.trim(),
    };

    final response = await _descargar(
      _Endpoints.regenerarReporte.replaceAll(':id', id),
      body,
    );
    return ArchivoDescarga(
      bytes: response.data ?? const [],
      nombreSugerido: _nombreDesdeHeaders(response),
    );
  }

  /// POST que devuelve un archivo binario; traduce los errores JSON del
  /// backend a un mensaje legible.
  Future<Response<List<int>>> _descargar(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.post<List<int>>(
        endpoint,
        data: body,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 120),
          sendTimeout: const Duration(seconds: 120),
        ),
      );
      final status = response.statusCode ?? 0;
      final data = response.data;
      // `validateStatus` del cliente acepta < 500, así que un 4xx llega aquí
      // como respuesta exitosa; hay que tratarlo como error.
      if ((status == 200 || status == 201) && data != null) {
        return response;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: data,
        message: 'No se pudo generar el archivo',
      );
    } on DioException catch (error) {
      throw _traducirErrorBinario(error);
    }
  }

  DioException _traducirErrorBinario(DioException error) {
    final data = error.response?.data;
    if (data is! List<int>) return error;

    String mensaje = 'No se pudo generar el archivo';
    try {
      final texto = utf8.decode(data);
      final json = jsonDecode(texto);
      if (json is Map && json['message'] != null) {
        mensaje = json['message'].toString();
      }
    } catch (_) {
      // El cuerpo no era JSON: se conserva el mensaje genérico.
    }

    return DioException(
      requestOptions: error.requestOptions,
      response: error.response,
      type: error.type,
      error: {'message': mensaje},
      message: mensaje,
    );
  }

  /// Extrae `filename="..."` de `Content-Disposition`, si existe.
  String? _nombreDesdeHeaders(Response<List<int>> response) {
    final raw = response.headers.value('content-disposition');
    if (raw == null || raw.isEmpty) return null;
    final match = RegExp(
      r'filename="?([^";]+)"?',
      caseSensitive: false,
    ).firstMatch(raw);
    final nombre = match?.group(1)?.trim();
    if (nombre == null || nombre.isEmpty) return null;
    return nombre;
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
