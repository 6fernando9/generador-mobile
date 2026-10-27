// Pagos Service for KrakenDraw - Handles payment endpoints
import 'package:dio/dio.dart';
import '../api_client.dart';
import '../api_endpoints.dart';

/// Pagos service handling payment-related endpoints
class PagosService {
  final Dio _dio;

  PagosService() : _dio = ApiClient.instance.dio;

  /// Get current user subscription
  Future<Map<String, dynamic>> getMiSuscripcion() async {
    final response = await _dio.get(ApiEndpoints.pagosMiSuscripcion);
    return _handleResponse(response);
  }

  /// Get payment history (paginated)
  Future<Map<String, dynamic>> getHistorial({
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await _dio.get(
      ApiEndpoints.pagosHistorial,
      queryParameters: queryParams,
    );
    return _handleResponse(response);
  }

  /// Create Stripe checkout session
  Future<Map<String, dynamic>> checkout({
    required String planId,
    String? successUrl,
    String? cancelUrl,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.pagosCheckout,
      data: {
        'plan_id': planId,
        if (successUrl != null) 'success_url': successUrl,
        if (cancelUrl != null) 'cancel_url': cancelUrl,
      },
    );
    return _handleResponse(response);
  }

  /// Verify Stripe checkout session
  Future<Map<String, dynamic>> verificarSesion(String sessionId) async {
    final response = await _dio.post(
      ApiEndpoints.pagosVerificarSesion,
      data: {'session_id': sessionId},
    );
    return _handleResponse(response);
  }

  /// Sync pending payments (for cases where webhook didn't fire)
  Future<Map<String, dynamic>> sincronizarPendientes() async {
    final response = await _dio.post(ApiEndpoints.pagosSincronizarPendientes);
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