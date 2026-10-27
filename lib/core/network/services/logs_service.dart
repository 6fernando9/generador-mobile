// Logs Service for KrakenDraw - Handles generation logs/download history endpoints
import 'package:dio/dio.dart';
import '../api_client.dart';
import '../api_endpoints.dart';

/// Logs service handling download history endpoints
class LogsService {
  final Dio _dio;

  LogsService() : _dio = ApiClient.instance.dio;

  /// Get paginated generation logs (download history)
  Future<Map<String, dynamic>> getLogs({
    int page = 1,
    int perPage = 20,
    String? search,
    String? tipo,
    String? estado,
    String? fechaInicio,
    String? fechaFin,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (tipo != null && tipo.isNotEmpty) queryParams['tipo'] = tipo;
    if (estado != null && estado.isNotEmpty) queryParams['estado'] = estado;
    if (fechaInicio != null && fechaInicio.isNotEmpty) queryParams['fecha_inicio'] = fechaInicio;
    if (fechaFin != null && fechaFin.isNotEmpty) queryParams['fecha_fin'] = fechaFin;

    final response = await _dio.get(
      ApiEndpoints.logs,
      queryParameters: queryParams,
    );
    return _handleResponse(response);
  }

  /// Get single log detail with diagram snapshot
  Future<Map<String, dynamic>> getLogDetail(String id) async {
    final response = await _dio.get(ApiEndpoints.logsDetail.replaceAll(':id', id));
    return _handleResponse(response);
  }

  /// Regenerate and download ZIP artifact
  Future<Map<String, dynamic>> regenerar(String id) async {
    final response = await _dio.post(ApiEndpoints.logsRegenerar.replaceAll(':id', id));
    return _handleResponse(response);
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