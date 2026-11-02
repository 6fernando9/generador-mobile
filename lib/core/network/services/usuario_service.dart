// Usuario Service for KrakenDraw - Handles user profile endpoints
import 'package:dio/dio.dart';
import '../api_client.dart';

/// Endpoints del perfil del usuario (`/api/perfil`).
class _Endpoints {
  static const String perfil = '/perfil/';
  static const String password = '/perfil/password';
  static const String icono = '/perfil/icono';
}

/// Usuario service handling profile-related endpoints
class UsuarioService {
  final Dio _dio;

  UsuarioService() : _dio = ApiClient.instance.dio;

  /// Get current user profile
  Future<Map<String, dynamic>> getProfile() async {
    final response = await _dio.get(_Endpoints.perfil);
    return _handleResponse(response);
  }

  /// Update user profile (username, email, profile_icon)
  Future<Map<String, dynamic>> updateProfile({
    String? username,
    String? email,
    String? profileIcon,
  }) async {
    final data = <String, dynamic>{};
    if (username != null) data['username'] = username;
    if (email != null) data['email'] = email;
    if (profileIcon != null) data['profile_icon'] = profileIcon;

    final response = await _dio.put(
      _Endpoints.perfil,
      data: data,
    );
    return _handleResponse(response);
  }

  /// Change user password
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _dio.put(
      _Endpoints.password,
      data: {
        'password_actual': currentPassword,
        'password': newPassword,
      },
    );
    return _handleResponse(response);
  }

  /// Upload/replace user avatar
  Future<Map<String, dynamic>> uploadAvatar(String filePath) async {
    final formData = FormData.fromMap({
      'icono': await MultipartFile.fromFile(filePath, filename: 'avatar.jpg'),
    });

    final response = await _dio.post(
      _Endpoints.icono,
      data: formData,
      options: Options(
        headers: {'Content-Type': 'multipart/form-data'},
      ),
    );
    return _handleResponse(response);
  }

  /// Remove user avatar
  Future<Map<String, dynamic>> removeAvatar() async {
    final response = await _dio.delete(_Endpoints.icono);
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