// Profile Controller for KrakenDraw
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/services/usuario_service.dart';
import 'package:mobile/data/models/profile_models.dart';
import 'package:dio/dio.dart';

/// Profile state
class ProfileState {
  final AsyncValue<Perfil> profile;
  final bool isUpdating;
  final String? errorMessage;

  const ProfileState({
    this.profile = const AsyncValue.loading(),
    this.isUpdating = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    AsyncValue<Perfil>? profile,
    bool? isUpdating,
    String? errorMessage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Profile controller managing profile operations
class ProfileController extends StateNotifier<ProfileState> {
  final UsuarioService _usuarioService = UsuarioService();

  ProfileController() : super(const ProfileState()) {
    // Don't auto-load - wait for explicit loadProfile() call after authentication
  }

  /// Load user profile from API
  Future<void> loadProfile() async {
    state = state.copyWith(profile: const AsyncValue.loading());

    try {
      final response = await _usuarioService.getProfile();
      final perfil = Perfil.fromJson(response);
      state = state.copyWith(profile: AsyncValue.data(perfil));
    } on DioException catch (e) {
      String message = 'Error al cargar el perfil';
      if (e.response?.data != null) {
        message = e.response?.data['message'] ?? message;
      } else if (e.message != null) {
        message = e.message!;
      }
      state = state.copyWith(
        profile: AsyncValue.error(message, StackTrace.current),
        errorMessage: message,
      );
    } catch (e) {
      state = state.copyWith(
        profile: AsyncValue.error(e.toString(), StackTrace.current),
        errorMessage: e.toString(),
      );
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    required String username,
    required String email,
  }) async {
    state = state.copyWith(isUpdating: true, errorMessage: null);

    try {
      final response = await _usuarioService.updateProfile(
        username: username,
        email: email,
      );
      final perfil = Perfil.fromJson(response);
      state = state.copyWith(
        profile: AsyncValue.data(perfil),
        isUpdating: false,
      );
      return true;
    } on DioException catch (e) {
      String message = 'Error al actualizar el perfil';
      if (e.response?.data != null) {
        message = e.response?.data['message'] ?? message;
      } else if (e.message != null) {
        message = e.message!;
      }
      state = state.copyWith(
        isUpdating: false,
        errorMessage: message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Change user password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isUpdating: true, errorMessage: null);

    try {
      await _usuarioService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      state = state.copyWith(isUpdating: false);
      return true;
    } on DioException catch (e) {
      String message = 'Error al cambiar la contraseña';
      if (e.response?.data != null) {
        message = e.response?.data['message'] ?? message;
      } else if (e.message != null) {
        message = e.message!;
      }
      state = state.copyWith(
        isUpdating: false,
        errorMessage: message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Upload avatar
  Future<bool> uploadAvatar(String filePath) async {
    state = state.copyWith(isUpdating: true, errorMessage: null);

    try {
      final response = await _usuarioService.uploadAvatar(filePath);
      final perfil = Perfil.fromJson(response);
      state = state.copyWith(
        profile: AsyncValue.data(perfil),
        isUpdating: false,
      );
      return true;
    } on DioException catch (e) {
      String message = 'Error al subir el avatar';
      if (e.response?.data != null) {
        message = e.response?.data['message'] ?? message;
      } else if (e.message != null) {
        message = e.message!;
      }
      state = state.copyWith(
        isUpdating: false,
        errorMessage: message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Remove avatar
  Future<bool> removeAvatar() async {
    state = state.copyWith(isUpdating: true, errorMessage: null);

    try {
      final response = await _usuarioService.removeAvatar();
      final perfil = Perfil.fromJson(response);
      state = state.copyWith(
        profile: AsyncValue.data(perfil),
        isUpdating: false,
      );
      return true;
    } on DioException catch (e) {
      String message = 'Error al eliminar el avatar';
      if (e.response?.data != null) {
        message = e.response?.data['message'] ?? message;
      } else if (e.message != null) {
        message = e.message!;
      }
      state = state.copyWith(
        isUpdating: false,
        errorMessage: message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Profile controller provider
final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  return ProfileController();
});