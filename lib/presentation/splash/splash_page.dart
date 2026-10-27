// Splash screen for KrakenDraw mobile app
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../shared/widgets/neon_background.dart';

/// Splash screen with animated "KrakenDraw" title and neon background
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _subtitleController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoRotation;
  late final Animation<double> _textFade;
  late final Animation<double> _textSlide;
  late final Animation<double> _subtitleFade;

  static const Duration _splashDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _subtitleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _textSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _subtitleController, curve: Curves.easeOut),
    );

    _startAnimations();
    _navigateAfterDelay();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) _textController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) _subtitleController.forward();
  }

  void _navigateAfterDelay() {
    Future.delayed(_splashDuration, () {
      if (mounted) {
        context.go('/auth');
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: NeonBackground(
        showParticles: true,
        animationDuration: const Duration(seconds: 10),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with animated scale and rotation
                AnimatedBuilder(
                  animation: Listenable.merge([_logoScale, _logoRotation]),
                  builder: (context, _) {
                    return Transform.scale(
                      scale: _logoScale.value,
                      child: Transform.rotate(
                        angle: _logoRotation.value,
                        child: _buildLogo(context),
                      ),
                    );
                  },
                ).animate().fadeIn(duration: 600.ms),

                const SizedBox(height: 32),

                // App title "KrakenDraw"
                AnimatedBuilder(
                  animation: Listenable.merge([_textFade, _textSlide]),
                  builder: (context, _) {
                    return Transform.translate(
                      offset: Offset(0, _textSlide.value),
                      child: Opacity(
                        opacity: _textFade.value,
                        child: _buildTitle(context),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // Subtitle
                AnimatedBuilder(
                  animation: _subtitleFade,
                  builder: (context, _) {
                    return Opacity(
                      opacity: _subtitleFade.value,
                      child: _buildSubtitle(context),
                    );
                  },
                ),

                const SizedBox(height: 60),

                // Loading indicator
                _buildLoadingIndicator(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;
    final glowColor = isDark ? NeonColors.glowDark['cyan']! : NeonColors.glowLight['cyan']!;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            primaryColor.withValues(alpha: 0.3),
            primaryColor.withValues(alpha: 0.1),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor,
            blurRadius: 40,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background pattern
          CustomPaint(
            size: const Size(120, 120),
            painter: _LogoPatternPainter(
              color: primaryColor,
              isDark: isDark,
            ),
          ),
          // Kraken icon
          Icon(
            Icons.bolt_rounded,
            size: 56,
            color: primaryColor,
          ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(
              duration: 2.seconds,
              color: primaryColor.withValues(alpha: 0.5),
            ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;

    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          primaryColor,
          NeonColors.getNeon('magenta', isDark),
          NeonColors.getNeon('purple', isDark),
        ],
      ).createShader(bounds),
      child: Text(
        'KrakenDraw',
        style: GoogleFonts.orbitron(
          fontSize: 42,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.0,
          color: Colors.white,
          height: 1.1,
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildSubtitle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      'Generador de Diagramas & Código',
      style: GoogleFonts.spaceGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: colorScheme.onSurface.withValues(alpha: 0.7),
        height: 1.4,
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;

    return Column(
      children: [
        // Neon progress bar
        SizedBox(
          width: 200,
          child: Stack(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, _) {
                  return FractionallySizedBox(
                    widthFactor: (_logoController.value * 0.8 + 0.2).clamp(0.0, 1.0),
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            NeonColors.getNeon('magenta', isDark),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 500.ms),

        const SizedBox(height: 16),

        // Loading text
        Text(
          'Cargando...',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 700.ms),
      ],
    );
  }
}

/// Custom painter for logo background pattern
class _LogoPatternPainter extends CustomPainter {
  final Color color;
  final bool isDark;

  _LogoPatternPainter({required this.color, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw concentric circles
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * i / 4, paint);
    }

    // Draw cross lines
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Alternative minimal splash for faster startup
class MinimalSplashPage extends StatelessWidget {
  const MinimalSplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;

    return Scaffold(
      body: NeonBackground(
        showParticles: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withValues(alpha: 0.2),
                      primaryColor.withValues(alpha: 0.05),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.bolt_rounded,
                  size: 48,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    primaryColor,
                    NeonColors.getNeon('magenta', isDark),
                  ],
                ).createShader(bounds),
                child: Text(
                  'KrakenDraw',
                  style: GoogleFonts.orbitron(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Generador de Diagramas',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 160,
                child: LinearProgressIndicator(
                  minHeight: 3,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}