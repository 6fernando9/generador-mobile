import 'package:dio/dio.dart';
import 'package:mobile/data/models/report_models.dart';

import '../api_client.dart';

/// Consulta de reportes personales (`/api/reportes/consultar`).
///
/// El backend vuelve a validar el plan (Pro o administrador) y responde 403
/// cuando no corresponde. El móvil no envía ni espera `puedeReportes`.
class ReportesService {
  ReportesService() : _dio = ApiClient.instance.dio;

  final Dio _dio;

  static const String _endpoint = '/reportes/consultar';

  Future<ReporteConsulta> consultar({
    required String metrica,
    String? categoria,
    required ReportRange rango,
    int? limite,
  }) async {
    final query = <String, dynamic>{
      'metrica': metrica,
      if (categoria != null && categoria.isNotEmpty) 'categoria': categoria,
      'desde': rango.desdeIso,
      'hasta': rango.hastaIso,
      'tz': rango.tz,
    };
    if (limite != null) query['limite'] = limite;

    final response = await _dio.get(_endpoint, queryParameters: query);

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ReporteConsulta.fromJson(data);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      message: 'Respuesta inesperada del servidor de reportes',
    );
  }
}
