// Register page for KrakenDraw
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/presentation/shared/widgets/neon_background.dart';
import 'package:mobile/presentation/shared/widgets/neon_button.dart';
import 'package:mobile/presentation/shared/widgets/neon_input.dart';
import 'package:mobile/presentation/auth/auth_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';

/// Register page with username, email, password, confirm password
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authControllerProvider.notifier).register(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        setState(() => _isLoading = false);

        // Navigate to dashboard on success (auto-login after register)
        final authState = ref.read(authControllerProvider);
        if (authState.isAuthenticated) {
          context.go('/dashboard');
        } else if (authState.errorMessage != null) {
          setState(() => _errorMessage = authState.errorMessage);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _navigateToLogin() {
    context.pop(); // Go back to login
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: NeonBackground(
        showParticles: true,
        animationDuration: const Duration(seconds: 12),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      _buildLogo(context)
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: -0.2, end: 0),

                      const SizedBox(height: 32),

                      // Title
                      Text(
                        'Crear Cuenta',
                        style: GoogleFonts.orbitron(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: colorScheme.onSurface,
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 100.ms)
                        .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 8),

                      Text(
                        'Únete a KrakenDraw y genera diagramas',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(duration: 400.ms, delay: 200.ms)
                        .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 32),

                      // Error message
                      if (_errorMessage != null)
                        _buildErrorMessage(context)
                            .animate()
                            .fadeIn(duration: 300.ms)
                            .shake(),

                      // Username field
                      NeonInput(
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
                      ).animate().fadeIn(duration: 400.ms, delay: 300.ms)
                        .slideX(begin: -0.2, end: 0),

                      const SizedBox(height: 20),

                      // Email field
                      NeonInput(
                        label: 'Email',
                        hint: 'tucorreo@ejemplo.com',
                        controller: _emailController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
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
                        onSubmitted: (_) => _passwordFocus.requestFocus(),
                      ).animate().fadeIn(duration: 400.ms, delay: 400.ms)
                        .slideX(begin: -0.2, end: 0),

                      const SizedBox(height: 20),

                      // Password field
                      NeonInput(
                        label: 'Contraseña',
                        hint: '••••••••',
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa una contraseña';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                        onSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            size: 22,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          tooltip: _obscurePassword ? 'Mostrar' : 'Ocultar',
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 500.ms)
                        .slideX(begin: -0.2, end: 0),

                      const SizedBox(height: 20),

                      // Confirm password field
                      NeonInput(
                        label: 'Confirmar Contraseña',
                        hint: '••••••••',
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        textInputAction: TextInputAction.done,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        obscureText: _obscureConfirmPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirma tu contraseña';
                          }
                          if (value != _passwordController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                        onSubmitted: (_) => _handleRegister(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            size: 22,
                          ),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          tooltip: _obscureConfirmPassword ? 'Mostrar' : 'Ocultar',
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 600.ms)
                        .slideX(begin: -0.2, end: 0),

                      const SizedBox(height: 24),

                      // Register button
                      NeonButton(
                        label: 'Crear Cuenta',
                        icon: Icons.person_add_rounded,
                        style: NeonButtonStyle.primary,
                        isLoading: _isLoading,
                        isFullWidth: true,
                        onPressed: _handleRegister,
                      ).animate().fadeIn(duration: 400.ms, delay: 700.ms)
                        .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 24),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: colorScheme.outlineVariant,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'o',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: colorScheme.outlineVariant,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms, delay: 800.ms),

                      const SizedBox(height: 24),

                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿Ya tienes cuenta? ',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          TextButton(
                            onPressed: _navigateToLogin,
                            child: Text(
                              'Inicia Sesión',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms, delay: 900.ms),

                      const SizedBox(height: 32),

                      // Version info
                      Text(
                        'KrakenDraw v1.0.0',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                      ),
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

  Widget _buildLogo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;

    return Container(
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
      child: Icon(
        Icons.bolt_rounded,
        size: 40,
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
}