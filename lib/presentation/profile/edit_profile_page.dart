// Edit profile page for KrakenDraw
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/core/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/presentation/shared/widgets/neon_background.dart';
import 'package:mobile/presentation/shared/widgets/neon_button.dart';
import 'package:mobile/presentation/shared/widgets/neon_card.dart';
import 'package:mobile/presentation/shared/widgets/neon_input.dart';
import 'package:mobile/presentation/profile/profile_controller.dart';
import 'package:mobile/data/models/profile_models.dart';

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

  bool _isLoading = false;
  String? _errorMessage;
  Perfil? _currentProfile;

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

    final success = await ref.read(profileControllerProvider.notifier).updateProfile(
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
                    // Avatar section
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms),
                        SlideEffect(begin: const Offset(0, -0.2), end: Offset.zero, duration: 400.ms),
                      ],
                      child: _buildAvatarSection(context),
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

  Widget _buildAvatarSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;
    final avatarRadius = context.responsiveAvatarRadius;
    final cameraButtonSize = avatarRadius * 0.64; // proportional to avatar
    final cameraIconSize = cameraButtonSize * 0.5;

    String initials = 'K';
    if (_currentProfile != null) {
      initials = _currentProfile!.username.substring(0, 1).toUpperCase();
    }

    return Stack(
      children: [
        NeonAvatar(
          initials: initials,
          radius: avatarRadius,
          glowColor: primaryColor,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: cameraButtonSize,
            height: cameraButtonSize,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.surface,
                width: 3,
              ),
            ),
            child: Icon(
              Icons.camera_alt_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
              size: cameraIconSize,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: GoogleFonts.inter(
                fontSize: 13,
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