// Profile Controller for KrakenDraw
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/services/usuario_service.dart';
import 'package:mobile/data/models/profile_models.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

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

  /// Pick, crop, compress and upload avatar in one flow
  Future<bool> pickAndUploadAvatar() async {
    state = state.copyWith(isUpdating: true, errorMessage: null);

    try {
      // 1. Pick image from gallery or camera
      final pickedFile = await _pickImage();
      if (pickedFile == null) {
        state = state.copyWith(isUpdating: false);
        return false; // User cancelled
      }

      // 2. Crop to square 1:1
      final croppedFile = await _cropImage(pickedFile.path);
      if (croppedFile == null) {
        state = state.copyWith(isUpdating: false);
        return false; // User cancelled crop
      }

      // 3. Compress and resize to 512x512 JPEG 80%
      final compressedFile = await _compressImage(croppedFile.path);
      if (compressedFile == null) {
        state = state.copyWith(
          isUpdating: false,
          errorMessage: 'Error al procesar la imagen',
        );
        return false;
      }

      // 4. Validate file size (< 5MB)
      final fileSize = await compressedFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        state = state.copyWith(
          isUpdating: false,
          errorMessage: 'La imagen es demasiado grande (máx 5MB)',
        );
        return false;
      }

      // 5. Upload to backend
      final response = await _usuarioService.uploadAvatar(compressedFile.path);
      final perfil = Perfil.fromJson(response);
      state = state.copyWith(
        profile: AsyncValue.data(perfil),
        isUpdating: false,
      );

      // Clean up temp files
      await _cleanupTempFiles([pickedFile.path, croppedFile.path, compressedFile.path]);

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
        errorMessage: 'Error inesperado: ${e.toString()}',
      );
      return false;
    }
  }

  /// Pick image from gallery or camera with specified source
  Future<XFile?> _pickImageWithSource(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 90,
    );

    return pickedFile;
  }

  /// Pick, crop, compress and upload avatar in one flow with specified source
  Future<bool> pickAndUploadAvatarWithSource(ImageSource source) async {
    state = state.copyWith(isUpdating: true, errorMessage: null);

    try {
      // 1. Pick image from gallery or camera using provided source
      final pickedFile = await _pickImageWithSource(source);
      if (pickedFile == null) {
        state = state.copyWith(isUpdating: false);
        return false; // User cancelled
      }

      // 2. Crop to square 1:1
      final croppedFile = await _cropImage(pickedFile.path);
      if (croppedFile == null) {
        state = state.copyWith(isUpdating: false);
        return false; // User cancelled crop
      }

      // 3. Compress and resize to 512x512 JPEG 80%
      final compressedFile = await _compressImage(croppedFile.path);
      if (compressedFile == null) {
        state = state.copyWith(
          isUpdating: false,
          errorMessage: 'Error al procesar la imagen',
        );
        return false;
      }

      // 4. Validate file size (< 5MB)
      final fileSize = await compressedFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        state = state.copyWith(
          isUpdating: false,
          errorMessage: 'La imagen es demasiado grande (máx 5MB)',
        );
        return false;
      }

      // 5. Upload to backend
      final response = await _usuarioService.uploadAvatar(compressedFile.path);
      final perfil = Perfil.fromJson(response);
      state = state.copyWith(
        profile: AsyncValue.data(perfil),
        isUpdating: false,
      );

      // Clean up temp files
      await _cleanupTempFiles([pickedFile.path, croppedFile.path, compressedFile.path]);

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
        errorMessage: 'Error inesperado: ${e.toString()}',
      );
      return false;
    }
  }

  /// Pick image from gallery or camera (legacy method - shows dialog)
  Future<XFile?> _pickImage() async {
    // Default to gallery for backward compatibility
    return _pickImageWithSource(ImageSource.gallery);
  }

  /// Crop image to square 1:1 aspect ratio
  Future<File?> _cropImage(String filePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Recortar Avatar',
          toolbarColor: NeonColors.cyanDark,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: 'Recortar Avatar',
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  /// Compress and resize image to 512x512 JPEG 80%
  Future<File?> _compressImage(String filePath) async {
    try {
      final originalBytes = await File(filePath).readAsBytes();
      final originalImage = img.decodeImage(originalBytes);

      if (originalImage == null) return null;

      // Resize to 512x512 maintaining aspect ratio (crop already made it square)
      final resizedImage = img.copyResize(
        originalImage,
        width: 512,
        height: 512,
        interpolation: img.Interpolation.cubic,
      );

      // Compress to JPEG 80%
      final compressedBytes = img.encodeJpg(resizedImage, quality: 80);

      // Save to temp file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await tempFile.writeAsBytes(compressedBytes);

      return tempFile;
    } catch (e) {
      return null;
    }
  }

  /// Process image for preview (without uploading)
  Future<Uint8List?> processImageForPreview(XFile file) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return null;

      // Crop to square if needed
      img.Image processedImage;
      if (image.width != image.height) {
        final size = image.width < image.height ? image.width : image.height;
        final x = (image.width - size) ~/ 2;
        final y = (image.height - size) ~/ 2;
        processedImage = img.copyCrop(image, x: x, y: y, width: size, height: size);
      } else {
        processedImage = image;
      }

      // Resize for preview (256x256)
      final previewImage = img.copyResize(
        processedImage,
        width: 256,
        height: 256,
        interpolation: img.Interpolation.cubic,
      );

      return Uint8List.fromList(img.encodeJpg(previewImage, quality: 85));
    } catch (e) {
      return null;
    }
  }

  /// Pick image with source selection (camera/gallery)
  Future<File?> pickImageWithSource(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 90,
    );

    if (pickedFile == null) return null;

    // Crop to square
    final croppedFile = await _cropImage(pickedFile.path);
    if (croppedFile == null) return null;

    // Compress
    return await _compressImage(croppedFile.path);
  }

  /// Clean up temporary files
  Future<void> _cleanupTempFiles(List<String> paths) async {
    for (final path in paths) {
      try {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {
        // Ignore cleanup errors
      }
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