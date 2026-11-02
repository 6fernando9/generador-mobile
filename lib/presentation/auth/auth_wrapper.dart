// Auth wrapper for KrakenDraw - handles auth state routing
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/neon_colors.dart'
    show NeonColors;
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/network/services/auth_service.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import 'package:mobile/data/models/auth_models.dart';
import 'package:mobile/data/models/profile_models.dart';
import 'package:mobile/presentation/auth/login/login_page.dart';
import 'package:mobile/main.dart' show navigatorKey;
import 'package:mobile/presentation/dashboard/dashboard_page.dart'
    show DashboardPage;
import 'package:mobile/presentation/shared/widgets/neon_background.dart';
import 'package:mobile/presentation/shared/widgets/skeleton_base.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Auth state enum
enum AuthStatus {
  unknown,
  unauthenticated,
  authenticating,
  authenticated,
  error,
}

/// Auth state
class AuthState {
  final AuthStatus status;
  final Perfil? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    Perfil? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.authenticating || status == AuthStatus.unknown;
}

/// Auth controller provider (Riverpod 3.x - NotifierProvider)
final authControllerProvider = NotifierProvider<AuthController, AuthState>(() => AuthController());

/// Auth controller managing authentication state (Riverpod 3.x - Notifier)
class AuthController extends Notifier<AuthState> {
  final AuthService _authService = AuthService();

  @override
  AuthState build() {
    // Initialize auth state asynchronously
    _initialize();
    return const AuthState();
  }

  Future<void> _initialize() async {
    // La sesión vive en la cookie httpOnly `jwt`, persistida por el
    // CookieJar de Dio en documents/cookies. Validamos contra /auth/me.
    try {
      final response = await _authService.me();
      final authResponse = AuthResponse.fromJson(response);
      await SecureStorage.saveUserData(
        jsonEncode(authResponse.usuario.toJson()),
      );
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: authResponse.usuario,
      );
      // Load profile after successful auth restoration
      _loadProfile();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await SecureStorage.clearAuthData();
        await ApiClient.instance.clearCookies();
      }
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } catch (_) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  void _loadProfile() {
    // Trigger profile loading after auth is established
    // This will be handled by the profile page when it's shown
  }

  Future<void> login(String email, String password, bool rememberMe) async {
    state = state.copyWith(status: AuthStatus.authenticating);

    try {
      final response = await _authService.login(email: email, password: password);
      final authResponse = AuthResponse.fromJson(response);

      // La cookie `jwt` ya quedó guardada por el CookieJar de Dio
      await SecureStorage.saveUserData(jsonEncode(authResponse.usuario.toJson()));

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: authResponse.usuario,
      );
    } on DioException catch (e) {
      String message = 'Error de autenticación';
      if (e.response?.data != null) {
        message = e.response?.data['message'] ?? message;
      } else if (e.message != null) {
        message = e.message!;
      }
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: message,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> register(String username, String email, String password) async {
    state = state.copyWith(status: AuthStatus.authenticating);

    try {
      final response = await _authService.register(
        username: username,
        email: email,
        password: password,
      );
      final authResponse = AuthResponse.fromJson(response);

      // La cookie `jwt` ya quedó guardada por el CookieJar de Dio
      await SecureStorage.saveUserData(jsonEncode(authResponse.usuario.toJson()));

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: authResponse.usuario,
      );
    } on DioException catch (e) {
      String message = 'Error de registro';
      if (e.response?.data != null) {
        message = e.response?.data['message'] ?? message;
      } else if (e.message != null) {
        message = e.message!;
      }
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: message,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      await SecureStorage.clearAuthData();
      await ApiClient.instance.clearCookies();
    } catch (_) {
      // Ignore errors, still clear local state
    } finally {
      state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
      // Navigate to login using global navigator key
      navigatorKey.currentContext?.go('/auth/login');
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Auth wrapper - decides whether to show auth pages or dashboard
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    // Show loading skeleton while checking auth
    if (authState.isLoading) {
      return _buildLoadingScreen(context);
    }

    // Route based on auth status
    if (authState.isAuthenticated) {
      return const DashboardPage();
    }

    // Show login page for unauthenticated users
    return const LoginPage();
  }

  Widget _buildLoadingScreen(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;

    return Scaffold(
      body: NeonBackground(
        showParticles: true,
        animationDuration: const Duration(seconds: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withValues(alpha: 0.2),
                      primaryColor.withValues(alpha: 0.05),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(Icons.bolt_rounded, size: 40, color: primaryColor),
              ).animate().fadeIn(duration: 500.ms).scale(delay: 200.ms),
              const SizedBox(height: 24),
              Text(
                'KrakenDraw',
                style: GoogleFonts.orbitron(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: colorScheme.onSurface,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
              const SizedBox(height: 32),
              const AuthFormSkeleton(),
            ],
          ),
        ),
      ),
    );
  }
}