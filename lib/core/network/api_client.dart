// API Client for KrakenDraw - Dio with CookieJar and interceptors
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage.dart';

/// API Client singleton with Dio, CookieJar, and interceptors
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  static ApiClient get instance => _instance;

  late final Dio dio;
  late final CookieJar _cookieJar;

  ApiClient._internal();

  static Future<void> init({String? baseUrl}) async {
    await _instance._initialize(baseUrl);
  }

  Future<void> _initialize(String? baseUrl) async {
    _cookieJar = PersistCookieJar(
      storage: FileStorage('${SecureStorage.documentsDirectory}/cookies'),
      ignoreExpires: true,
    );

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://localhost:4000/api',
        ),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    // Add cookie manager for JWT cookie persistence
    dio.interceptors.add(CookieManager(_cookieJar));

    // Add auth interceptor
    dio.interceptors.add(_AuthInterceptor());

    // Add error handling interceptor
    dio.interceptors.add(_ErrorInterceptor());

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }
  }

  /// Set auth token manually (if needed)
  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear auth token
  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }

  /// Get stored cookies for debugging
  Future<List<Cookie>> getCookies() async {
    final uri = Uri.parse(dio.options.baseUrl);
    return await _cookieJar.loadForRequest(uri);
  }

  /// Clear all cookies (logout)
  Future<void> clearCookies() async {
    await _cookieJar.deleteAll();
  }
}

/// Auth interceptor - handles 401 responses and token refresh
class _AuthInterceptor extends Interceptor {
  static const int _maxRetries = 1;
  int _retryCount = 0;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add withCredentials for cookie support
    options.extra['withCredentials'] = true;
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401 && _retryCount < _maxRetries) {
      _retryCount++;

      // Try to sync pending payments or refresh session
      try {
        await ApiClient.instance.dio.post('/pagos/sincronizar-pendientes');
        _retryCount = 0;

        // Retry the original request
        final response = await ApiClient.instance.dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (_) {
        // If sync fails, clear auth
        await _clearAuth();
      }
    } else if (err.response?.statusCode == 401) {
      await _clearAuth();
    }

    _retryCount = 0;
    handler.next(err);
  }

  Future<void> _clearAuth() async {
    await ApiClient.instance.clearCookies();
    await SecureStorage.clearAuthData();
    // Navigation will be handled by the auth controller/router
  }
}

/// Error interceptor - normalizes error responses
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Normalize error response
    final normalizedError = _normalizeError(err);
    handler.next(normalizedError);
  }

  DioException _normalizeError(DioException err) {
    String message = 'Error desconocido';
    int statusCode = err.response?.statusCode ?? 0;
    DateTime fecha = DateTime.now();

    if (err.response?.data != null) {
      final data = err.response!.data;
      if (data is Map<String, dynamic>) {
        message = data['message']?.toString() ?? message;
        fecha = DateTime.tryParse(data['fecha']?.toString() ?? '') ?? fecha;
      }
    } else {
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          message = 'Tiempo de conexión agotado';
          break;
        case DioExceptionType.connectionError:
          message = 'Error de conexión. Verifique su internet.';
          break;
        case DioExceptionType.badResponse:
          message = 'Error del servidor: $statusCode';
          break;
        case DioExceptionType.cancel:
          message = 'Solicitud cancelada';
          break;
        case DioExceptionType.unknown:
          message = 'Error desconocido: ${err.message}';
          break;
        default:
          message = 'Error: ${err.message}';
      }
    }

    return DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: {
        'message': message,
        'statusCode': statusCode,
        'fecha': fecha.toIso8601String(),
      },
      message: message,
    );
  }
}