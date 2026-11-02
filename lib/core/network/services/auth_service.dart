// Auth Service for KrakenDraw - Handles authentication endpoints
import 'package:dio/dio.dart';
import '../api_client.dart';

/// Endpoints del dominio de autenticación (`/api/auth`).
class _Endpoints {
  static const String register = '/auth/register/';
  static const String login = '/auth/login/';
  static const String logout = '/auth/logout/';
  static const String me = '/auth/me/';
}

/// Auth service handling login, register, logout, and me endpoints
class AuthService {
  final Dio _dio;

  AuthService() : _dio = ApiClient.instance.dio;

  /// Register a new user
  /// Returns user data on success
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      _Endpoints.register,
      data: {
        'username': username,
        'email': email,
        'password': password,
      },
    );
    return _handleResponse(response);
  }

  /// Login user
  /// Returns user data and sets JWT cookie
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      _Endpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    return _handleResponse(response);
  }

  /// Logout user
  /// Clears JWT cookie
  Future<void> logout() async {
    await _dio.post(_Endpoints.logout);
  }

  /// Get current authenticated user
  /// Returns user data
  Future<Map<String, dynamic>> me() async {
    final response = await _dio.get(_Endpoints.me);
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