// Change password page for KrakenDraw
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/core/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart'
    show GoogleFonts;
import 'package:mobile/presentation/shared/widgets/neon_background.dart';
import 'package:mobile/presentation/shared/widgets/neon_button.dart';
import 'package:mobile/presentation/shared/widgets/neon_input.dart';
import 'package:mobile/presentation/profile/profile_controller.dart';

/// Change password page
class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _currentFocus = FocusNode();
  final _newFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String? _errorMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentFocus.dispose();
    _newFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await ref.read(profileControllerProvider.notifier).changePassword(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Contraseña cambiada correctamente',
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
        title: const Text('Cambiar Contraseña'),
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
                    // Icon
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms),
                        SlideEffect(begin: const Offset(0, -0.2), end: Offset.zero, duration: 400.ms),
                      ],
                      child: _buildIcon(context),
                    ),

                    SizedBox(height: context.responsiveSectionSpacing),

                    // Title
                    Animate(
                      effects: [FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 100))],
                      child: Text(
                        'Cambiar Contraseña',
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
                        'Ingresa tu contraseña actual y la nueva',
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

                    // Current password field
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 300)),
                        SlideEffect(begin: const Offset(-0.2, 0), end: Offset.zero, duration: 400.ms, delay: Duration(milliseconds: 300)),
                      ],
                      child: NeonInput(
                        label: 'Contraseña Actual',
                        hint: '••••••••',
                        controller: _currentPasswordController,
                        focusNode: _currentFocus,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        obscureText: _obscureCurrent,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa tu contraseña actual';
                          }
                          return null;
                        },
                        onSubmitted: (_) => _newFocus.requestFocus(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureCurrent ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            size: 22,
                          ),
                          onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                          tooltip: _obscureCurrent ? 'Mostrar' : 'Ocultar',
                        ),
                      ),
                    ),

                    SizedBox(height: context.responsiveFieldSpacing),

                    // New password field
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 400)),
                        SlideEffect(begin: const Offset(-0.2, 0), end: Offset.zero, duration: 400.ms, delay: Duration(milliseconds: 400)),
                      ],
                      child: NeonInput(
                        label: 'Nueva Contraseña',
                        hint: '••••••••',
                        controller: _newPasswordController,
                        focusNode: _newFocus,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        obscureText: _obscureNew,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa una nueva contraseña';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          if (value == _currentPasswordController.text) {
                            return 'La nueva contraseña debe ser diferente a la actual';
                          }
                          return null;
                        },
                        onSubmitted: (_) => _confirmFocus.requestFocus(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNew ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            size: 22,
                          ),
                          onPressed: () => setState(() => _obscureNew = !_obscureNew),
                          tooltip: _obscureNew ? 'Mostrar' : 'Ocultar',
                        ),
                      ),
                    ),

                    SizedBox(height: context.responsiveFieldSpacing),

                    // Confirm new password field
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 500)),
                        SlideEffect(begin: const Offset(-0.2, 0), end: Offset.zero, duration: 400.ms, delay: Duration(milliseconds: 500)),
                      ],
                      child: NeonInput(
                        label: 'Confirmar Nueva Contraseña',
                        hint: '••••••••',
                        controller: _confirmPasswordController,
                        focusNode: _confirmFocus,
                        textInputAction: TextInputAction.done,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        obscureText: _obscureConfirm,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirma la nueva contraseña';
                          }
                          if (value != _newPasswordController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                        onSubmitted: (_) => _handleChangePassword(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            size: 22,
                          ),
                          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          tooltip: _obscureConfirm ? 'Mostrar' : 'Ocultar',
                        ),
                      ),
                    ),

                    SizedBox(height: context.responsiveFieldSpacing),

                    // Loading indicator from profile controller
                    if (profileState.isUpdating)
                      Animate(
                        effects: [FadeEffect(duration: 300.ms)],
                        child: const LinearProgressIndicator(),
                      ),

                    // Password requirements hint
                    Animate(
                      effects: [FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 600))],
                      child: _buildPasswordHint(context),
                    ),

                    SizedBox(height: context.responsiveSectionSpacing),

                    // Change password button
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 700)),
                        SlideEffect(begin: const Offset(0, 0.2), end: Offset.zero, duration: 400.ms, delay: Duration(milliseconds: 700)),
                      ],
                      child: NeonButton(
                        label: 'Cambiar Contraseña',
                        icon: Icons.lock_rounded,
                        style: NeonButtonStyle.primary,
                        isLoading: _isLoading || profileState.isUpdating,
                        isFullWidth: true,
                        onPressed: _handleChangePassword,
                      ),
                    ),

                    SizedBox(height: context.responsiveFieldSpacing),

                    // Cancel button
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 800)),
                        SlideEffect(begin: const Offset(0, 0.2), end: Offset.zero, duration: 400.ms, delay: Duration(milliseconds: 800)),
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

  Widget _buildIcon(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;
    final iconSize = context.responsiveAvatarRadius * 1.6; // proportional to avatar
    final containerSize = iconSize * 2;
    final borderRadius = containerSize * 0.25;

    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
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
      child: Icon(
        Icons.lock_outline_rounded,
        size: iconSize,
        color: primaryColor,
      ),
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

  Widget _buildPasswordHint(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Requisitos de contraseña',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRequirement(context, 'Mínimo 6 caracteres'),
          _buildRequirement(context, 'Diferente a la contraseña actual'),
          _buildRequirement(context, 'Se recomienda usar letras, números y símbolos'),
        ],
      ),
    );
  }

  Widget _buildRequirement(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}