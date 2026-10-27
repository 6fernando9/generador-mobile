// Auth wrapper for KrakenDraw - handles auth state routing
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import 'package:mobile/presentation/auth/login/login_page.dart';
import 'package:mobile/presentation/dashboard/dashboard_page.dart';
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
  final String? userData;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.userData,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? userData,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      userData: userData ?? this.userData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.authenticating || status == AuthStatus.unknown;
}

/// Auth controller provider
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});

/// Auth controller managing authentication state
class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(const AuthState()) {
    initialize();
  }

  Future<void> initialize() async {
    // Check for stored session
    // final token = await SecureStorage.getUserToken();
    // final userData = await SecureStorage.getUserData();
    //
    // if (token != null && userData != null) {
    //   state = state.copyWith(status: AuthStatus.authenticated, userData: userData);
    // } else {
    //   state = state.copyWith(status: AuthStatus.unauthenticated);
    // }

    // For now, simulate unauthenticated state
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }

  Future<void> login(String email, String password, bool rememberMe) async {
    state = state.copyWith(status: AuthStatus.authenticating);

    try {
      // TODO: Implement actual API call
      // final response = await ApiClient.instance.dio.post(ApiEndpoints.authLogin, data: {
      //   'email': email,
      //   'password': password,
      // });
      //
      // if (response.statusCode == 200) {
      //   final userData = response.data['usuario'];
      //   final token = response.data['token'];
      //
      //   await SecureStorage.saveUserToken(token);
      //   await SecureStorage.saveUserData(jsonEncode(userData));
      //
      //   state = state.copyWith(status: AuthStatus.authenticated, userData: jsonEncode(userData));
      // } else {
      //   throw Exception(response.data['message'] ?? 'Error de autenticación');
      // }

      // Simulate success for now
      await Future.delayed(const Duration(milliseconds: 800));
      state = state.copyWith(
        status: AuthStatus.authenticated,
        userData: '{"username": "demo", "email": "demo@krakendraw.com"}',
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
      // TODO: Implement actual API call
      // final response = await ApiClient.instance.dio.post(ApiEndpoints.authRegister, data: {
      //   'username': username,
      //   'email': email,
      //   'password': password,
      // });
      //
      // if (response.statusCode == 200) {
      //   final userData = response.data['usuario'];
      //   final token = response.data['token'];
      //
      //   await SecureStorage.saveUserToken(token);
      //   await SecureStorage.saveUserData(jsonEncode(userData));
      //
      //   state = state.copyWith(status: AuthStatus.authenticated, userData: jsonEncode(userData));
      // } else {
      //   throw Exception(response.data['message'] ?? 'Error de registro');
      // }

      // Simulate success for now
      await Future.delayed(const Duration(milliseconds: 800));
      state = state.copyWith(
        status: AuthStatus.authenticated,
        userData: '{"username": "$username", "email": "$email"}',
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
      // TODO: Implement actual API call
      // await ApiClient.instance.dio.post(ApiEndpoints.authLogout);
      await SecureStorage.clearAuthData();
      await ApiClient.instance.clearCookies();
    } catch (_) {
      // Ignore errors
    } finally {
      state = state.copyWith(status: AuthStatus.unauthenticated);
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