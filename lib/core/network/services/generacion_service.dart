// Catálogos del motor de generación (`GET /generacion/opciones`).
import 'package:dio/dio.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/data/models/generacion_models.dart';

/// Endpoints del motor de generación (`/api/generacion`).
class _Endpoints {
  static const String opciones = '/generacion/opciones';
}

class GeneracionService {
  final Dio _dio;

  GeneracionService({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  /// Tipos de artefacto generables con sus lenguajes, frameworks y ORMs.
  Future<OpcionesGeneracion> opciones() async {
    final response = await _dio.get(_Endpoints.opciones);
    final data = _data(response);
    return OpcionesGeneracion.fromJson(data);
  }

  Map<String, dynamic> _data(Response<dynamic> response) {
    final status = response.statusCode;
    if ((status == 200 || status == 201) && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data,
      message: 'No se pudieron cargar las opciones de generación',
    );
  }
}
