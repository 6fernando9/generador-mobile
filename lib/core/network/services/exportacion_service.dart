// Catálogos de exportación SQL/XML (`GET /exportar/opciones`).
import 'package:dio/dio.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/network/api_endpoints.dart';
import 'package:mobile/data/models/exportacion_models.dart';

class ExportacionService {
  final Dio _dio;

  ExportacionService({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  /// Tipos de reporte (SQL/XML) con sus bases de datos destino o tipos XML.
  Future<OpcionesExportacion> opciones() async {
    final response = await _dio.get(ApiEndpoints.exportarOpciones);
    final status = response.statusCode;
    if ((status == 200 || status == 201) && response.data is Map) {
      return OpcionesExportacion.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data,
      message: 'No se pudieron cargar las opciones de exportación',
    );
  }
}
