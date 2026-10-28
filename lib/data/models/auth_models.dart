// Auth models for KrakenDraw - Manual JSON serialization
import 'package:mobile/data/models/profile_models.dart';

/// Auth response from login/register/me endpoints
class AuthResponse {
  final Perfil usuario;
  final String token;

  const AuthResponse({
    required this.usuario,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      usuario: Perfil.fromJson(json['usuario'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario.toJson(),
      'token': token,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthResponse &&
          runtimeType == other.runtimeType &&
          usuario == other.usuario &&
          token == other.token;

  @override
  int get hashCode => usuario.hashCode ^ token.hashCode;

  @override
  String toString() => 'AuthResponse(usuario: $usuario, token: $token)';
}

/// Login request payload
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginRequest &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password;

  @override
  int get hashCode => email.hashCode ^ password.hashCode;

  @override
  String toString() => 'LoginRequest(email: $email)';
}

/// Register request payload
class RegisterRequest {
  final String username;
  final String email;
  final String password;

  const RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisterRequest &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          email == other.email &&
          password == other.password;

  @override
  int get hashCode => username.hashCode ^ email.hashCode ^ password.hashCode;

  @override
  String toString() => 'RegisterRequest(username: $username, email: $email)';
}