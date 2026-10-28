// Edit profile page for KrakenDraw
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/core/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/presentation/shared/widgets/neon_background.dart';
import 'package:mobile/presentation/shared/widgets/neon_button.dart';
import 'package:mobile/presentation/shared/widgets/neon_input.dart';
import 'package:mobile/presentation/profile/profile_controller.dart';
import 'package:mobile/presentation/profile/widgets/avatar_edit_section.dart';
import 'package:mobile/data/models/profile_models.dart';
import 'package:image_picker/image_picker.dart';

/// Edit profile page
class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _emailFocus = FocusNode();

  // Avatar section key for accessing setSelectedImage
  final _avatarEditKey = GlobalKey<AvatarEditSectionState>();

  bool _isLoading = false;
  String? _errorMessage;
  Perfil? _currentProfile;

  // Avatar state
  String? _avatarErrorMessage;
  final String _avatarHeroTag = 'profile-avatar-edit';

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }

  Future<void> _loadCurrentProfile() async {
    final profileState = ref.read(profileControllerProvider);
    profileState.profile.whenData((perfil) {
      if (mounted) {
        setState(() {
          _currentProfile = perfil;
          _usernameController.text = perfil.username;
          _emailController.text = perfil.email;
        });
      }
    });
  }

  /// Remove selected avatar (revert to current)
  void _removeSelectedAvatar() {
    setState(() {
      _avatarErrorMessage = null;
      _selectedAvatarFile = null;
    });
    _avatarEditKey.currentState?.setSelectedImage(null);
  }

  // Store the selected avatar file for later upload on save
  File? _selectedAvatarFile;

  /// Pick avatar with source selection (camera with preview / gallery)
  /// Only updates the preview; upload happens when user presses "Guardar Cambios"
  Future<void> _pickAvatar() async {
    final colorScheme = Theme.of(context).colorScheme;

    // Show source selection bottom sheet
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildImageSourceSheet(context),
    );

    if (source == null) return;

    // Show loading indicator
    if (!context.mounted) return;
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              source == ImageSource.camera
                  ? 'Abriendo cámara...'
                  : 'Seleccionando imagen...',
              style: GoogleFonts.inter(color: colorScheme.onSurface),
            ),
          ],
        ),
        backgroundColor: colorScheme.surfaceContainerHighest,
        duration: const Duration(seconds: 30),
        behavior: SnackBarBehavior.floating,
      ),
    );

    try {
      final controller = ref.read(profileControllerProvider.notifier);
      File? processedFile;

      if (source == ImageSource.camera) {
        // Use camera with preview flow
        processedFile = await controller.pickImageFromCameraWithPreview(context);
      } else {
        // Gallery: use existing flow (pick -> crop -> compress)
        processedFile = await controller.pickImageWithSource(source);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (processedFile != null) {
          // Store for later upload on save
          _selectedAvatarFile = processedFile;

          // Update preview in AvatarEditSection
          _avatarEditKey.currentState?.setSelectedImage(processedFile);
          setState(() {
            _avatarErrorMessage = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Imagen seleccionada. Presiona "Guardar Cambios" para aplicar.',
                style: GoogleFonts.inter(),
              ),
              backgroundColor: colorScheme.surfaceContainerHighest,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          // User cancelled at any step (camera, preview, crop, or gallery)
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        setState(() => _avatarErrorMessage = 'Error inesperado: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error inesperado: $e',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Build image source selection bottom sheet (camera/gallery)
  Widget _buildImageSourceSheet(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Seleccionar imagen',
                style: GoogleFonts.spaceGrotesk(
                  color: colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Elige de dónde tomar la foto',
                style: GoogleFonts.inter(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              _buildSourceOption(
                context,
                icon: Icons.camera_alt_rounded,
                label: 'Cámara',
                subtitle: 'Tomar una foto ahora',
                color: NeonColors.getNeon('cyan', isDark),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              const SizedBox(height: 12),
              _buildSourceOption(
                context,
                icon: Icons.photo_library_rounded,
                label: 'Galería',
                subtitle: 'Elegir de tus fotos',
                color: NeonColors.getNeon('magenta', isDark),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.spaceGrotesk(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.spaceGrotesk(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurface.withValues(alpha: 0.3),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _usernameFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final controller = ref.read(profileControllerProvider.notifier);

    // Upload avatar first if a new one was selected
    bool avatarUploadSuccess = true;
    if (_selectedAvatarFile != null) {
      avatarUploadSuccess = await controller.uploadAvatar(_selectedAvatarFile!.path);
      if (!avatarUploadSuccess && mounted) {
        final error = ref.read(profileControllerProvider).errorMessage;
        setState(() {
          _isLoading = false;
          _avatarErrorMessage = error ?? 'Error al subir el avatar';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _avatarErrorMessage!,
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }

    // Then update profile info (username, email)
    final success = await controller.updateProfile(
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
        );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Perfil actualizado correctamente',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final profileState = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        centerTitle: true,
      ),
      body: NeonBackground(
        showParticles: false,
        animationDuration: const Duration(seconds: 8),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: context.responsivePadding,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: context.responsiveMaxContentWidth),
                child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Avatar section with edit capabilities
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms),
                        SlideEffect(begin: const Offset(0, -0.2), end: Offset.zero, duration: 400.ms),
                      ],
                      child: AvatarEditSection(
                        key: _avatarEditKey,
                        currentImageUrl: _currentProfile?.profileIcon,
                        initials: _currentProfile?.username.substring(0, 1).toUpperCase() ?? 'K',
                        glowColor: Theme.of(context).brightness == Brightness.dark
                            ? NeonColors.cyanDark
                            : NeonColors.cyanLight,
                        heroTag: _avatarHeroTag,
                        onImageChanged: (_) {
                          // Preview is handled internally by AvatarEditSection
                          // This callback can be used for additional logic if needed
                        },
                        onRemoveAvatar: _removeSelectedAvatar,
                        isLoading: profileState.isUpdating,
                        errorMessage: _avatarErrorMessage,
                        onPickImage: _pickAvatar,
                      ),
                    ),

                    SizedBox(height: context.responsiveSectionSpacing),

                    // Title
                    Animate(
                      effects: [FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 100))],
                      child: Text(
                        'Actualizar Información',
                        style: GoogleFonts.orbitron(
                          fontSize: 24 * context.responsiveFontScale,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Animate(
                      effects: [FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 200))],
                      child: Text(
                        'Modifica tus datos de cuenta',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14 * context.responsiveFontScale,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),

                    SizedBox(height: context.responsiveSectionSpacing),

                    // Error message
                    if (_errorMessage != null)
                      Animate(
                        effects: [
                          FadeEffect(duration: 300.ms),
                          ShakeEffect(duration: 300.ms),
                        ],
                        child: _buildErrorMessage(context),
                      ),

                    // Username field
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 300)),
                        SlideEffect(begin: const Offset(-0.2, 0), end: Offset.zero, duration: 400.ms, delay: Duration(milliseconds: 300)),
                      ],
                      child: NeonInput(
                        label: 'Usuario',
                        hint: 'tu_usuario',
                        controller: _usernameController,
                        focusNode: _usernameFocus,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa un nombre de usuario';
                          }
                          if (value.trim().length < 3) {
                            return 'El usuario debe tener al menos 3 caracteres';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
                            return 'Solo letras, números y guión bajo';
                          }
                          return null;
                        },
                        onSubmitted: (_) => _emailFocus.requestFocus(),
                      ),
                    ),

                    SizedBox(height: context.responsiveFieldSpacing),

                    // Email field
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 400)),
                        SlideEffect(begin: const Offset(-0.2, 0), end: Offset.zero, duration: 400.ms, delay: Duration(milliseconds: 400)),
                      ],
                      child: NeonInput(
                        label: 'Email',
                        hint: 'tucorreo@ejemplo.com',
                        controller: _emailController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa tu email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                            return 'Ingresa un email válido';
                          }
                          return null;
                        },
                        onSubmitted: (_) => _handleSave(),
                      ),
                    ),

                    SizedBox(height: context.responsiveSectionSpacing),

                    // Loading indicator from profile controller
                    if (profileState.isUpdating)
                      Animate(
                        effects: [FadeEffect(duration: 300.ms)],
                        child: const LinearProgressIndicator(),
                      ),

                    // Save button
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 500)),
                        SlideEffect(begin: const Offset(0, 0.2), end: Offset.zero, duration: 400.ms, delay: Duration(milliseconds: 500)),
                      ],
                      child: NeonButton(
                        label: 'Guardar Cambios',
                        icon: Icons.save_rounded,
                        style: NeonButtonStyle.primary,
                        isLoading: _isLoading || profileState.isUpdating,
                        isFullWidth: true,
                        onPressed: _handleSave,
                      ),
                    ),

                    SizedBox(height: context.responsiveFieldSpacing),

                    // Cancel button
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 600)),
                        SlideEffect(begin: const Offset(0, 0.2), end: Offset.zero, duration: 400.ms, delay: Duration(milliseconds: 600)),
                      ],
                      child: NeonButton(
                        label: 'Cancelar',
                        icon: Icons.close_rounded,
                        style: NeonButtonStyle.ghost,
                        isFullWidth: true,
                        onPressed: () => context.pop(),
                      ),
                    ),

                    SizedBox(height: context.responsiveSectionSpacing),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    final scale = context.responsiveFontScale;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16 * scale),
      margin: EdgeInsets.only(bottom: 20 * scale),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12 * scale),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 20 * scale),
          SizedBox(width: 12 * scale),
          Expanded(
            child: Text(
              _errorMessage!,
              style: GoogleFonts.inter(
                fontSize: 13 * scale,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}