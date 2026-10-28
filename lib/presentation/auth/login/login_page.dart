// Login page for KrakenDraw
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/core/utils/responsive.dart';
import 'package:mobile/presentation/shared/widgets/neon_background.dart';
import 'package:mobile/presentation/shared/widgets/neon_button.dart';
import 'package:mobile/presentation/shared/widgets/neon_input.dart';
import 'package:mobile/presentation/auth/auth_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';

/// Login page with email/username and password
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isLoading = false;
  bool _rememberMe = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(
            _emailController.text.trim(),
            _passwordController.text,
            _rememberMe,
          );

      if (mounted) {
        setState(() => _isLoading = false);

        // Navigate to dashboard on success
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

  void _navigateToRegister() {
    context.push('/auth/register');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: NeonBackground(
        showParticles: true,
        animationDuration: const Duration(seconds: 12),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: context.responsivePadding,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: context.responsiveMaxContentWidth,
                ),
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

                      SizedBox(height: 32 * context.responsiveFontScale),

                      // Title
                      Text(
                            'Iniciar Sesión',
                            style: GoogleFonts.orbitron(
                              fontSize: 32 * context.responsiveFontScale,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                              color: colorScheme.onSurface,
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 100.ms)
                          .slideY(begin: 0.2, end: 0),

                      SizedBox(height: 8 * context.responsiveFontScale),

                      Text(
                            'Accede a tu dashboard de KrakenDraw',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 15 * context.responsiveFontScale,
                              fontWeight: FontWeight.w400,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 200.ms)
                          .slideY(begin: 0.2, end: 0),

                      SizedBox(height: 32 * context.responsiveFontScale),

                      // Error message
                      if (_errorMessage != null)
                        _buildErrorMessage(context)
                            .animate()
                            .fadeIn(duration: 300.ms)
                            .shake(),

                      // Email/Username field
                      NeonInput(
                            label: 'Email o Usuario',
                            hint: 'tucorreo@ejemplo.com',
                            controller: _emailController,
                            focusNode: _emailFocus,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Ingresa tu email o usuario';
                              }
                              return null;
                            },
                            onSubmitted: (_) => _passwordFocus.requestFocus(),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 300.ms)
                          .slideX(begin: -0.2, end: 0),

                      SizedBox(height: 20 * context.responsiveFontScale),

                      // Password field
                      NeonPasswordInput(
                            label: 'Contraseña',
                            hint: '••••••••',
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tu contraseña';
                              }
                              return null;
                            },
                            onSubmitted: (_) => _handleLogin(),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 400.ms)
                          .slideX(begin: -0.2, end: 0),

                      const SizedBox(height: 16),

                      // Remember me & Forgot password
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          // Remember me checkbox
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) => setState(
                                    () => _rememberMe = value ?? true,
                                  ),
                                  activeColor: colorScheme.primary,
                                  checkColor: colorScheme.onPrimary,
                                  side: BorderSide(
                                    color: colorScheme.outlineVariant,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Recordarme',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Forgot password
                          TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Función en desarrollo',
                                    style: GoogleFonts.inter(),
                                  ),
                                  backgroundColor:
                                      colorScheme.surfaceContainerHighest,
                                ),
                              );
                            },
                            child: Text(
                              '¿Olvidaste tu contraseña?',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms, delay: 500.ms),

                      SizedBox(height: 24 * context.responsiveFontScale),

                      // Login button
                      NeonButton(
                            label: 'Iniciar Sesión',
                            icon: Icons.login_rounded,
                            style: NeonButtonStyle.primary,
                            isLoading: _isLoading,
                            isFullWidth: true,
                            onPressed: _handleLogin,
                          )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 600.ms)
                          .slideY(begin: 0.2, end: 0),

                      SizedBox(height: 24 * context.responsiveFontScale),

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
                            padding: EdgeInsets.symmetric(
                              horizontal: 16 * context.responsiveFontScale,
                            ),
                            child: Text(
                              'o',
                              style: GoogleFonts.inter(
                                fontSize: 13 * context.responsiveFontScale,
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
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
                      ).animate().fadeIn(duration: 400.ms, delay: 700.ms),

                      SizedBox(height: 24 * context.responsiveFontScale),

                      // Register link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿No tienes cuenta? ',
                            style: GoogleFonts.inter(
                              fontSize: 14 * context.responsiveFontScale,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _navigateToRegister,
                            child: Text(
                              'Regístrate',
                              style: GoogleFonts.inter(
                                fontSize: 14 * context.responsiveFontScale,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms, delay: 800.ms),

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
    final logoSize = 80 * context.responsiveFontScale;
    final iconSize = logoSize * 0.5;

    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(logoSize * 0.25),
        gradient: LinearGradient(
          colors: [
            primaryColor.withValues(alpha: 0.2),
            primaryColor.withValues(alpha: 0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 25 * context.responsiveFontScale,
            spreadRadius: 5 * context.responsiveFontScale,
          ),
        ],
      ),
      child: Icon(Icons.bolt_rounded, size: iconSize, color: primaryColor),
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16 * context.responsiveFontScale),
      margin: EdgeInsets.only(bottom: 20 * context.responsiveFontScale),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12 * context.responsiveFontScale),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 20 * context.responsiveFontScale,
          ),
          SizedBox(width: 12 * context.responsiveFontScale),
          Expanded(
            child: Text(
              _errorMessage!,
              style: GoogleFonts.inter(
                fontSize: 13 * context.responsiveFontScale,
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
