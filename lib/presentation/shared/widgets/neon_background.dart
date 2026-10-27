// Animated neon background widget for KrakenDraw
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Full-screen animated neon background with gradient and particle effects
class NeonBackground extends StatefulWidget {
  final Widget child;
  final bool showParticles;
  final Duration animationDuration;
  final List<Color>? customColors;

  const NeonBackground({
    super.key,
    required this.child,
    this.showParticles = true,
    this.animationDuration = const Duration(seconds: 8),
    this.customColors,
  });

  @override
  State<NeonBackground> createState() => _NeonBackgroundState();
}

class _NeonBackgroundState extends State<NeonBackground>
    with TickerProviderStateMixin {
  late final AnimationController _gradientController;
  late final AnimationController _particleController;
  late final Animation<double> _gradientAnimation;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat(reverse: true);

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _particles = List.generate(
      widget.showParticles ? 30 : 0,
      (_) => _Particle.random(),
    );
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final neonTheme = context.neonTheme;
    final colors = widget.customColors ??
        (Theme.of(context).brightness == Brightness.dark
            ? NeonColors.darkGradient
            : NeonColors.lightGradient);

    return Stack(
      children: [
        // Base gradient background
        AnimatedBuilder(
          animation: _gradientAnimation,
          builder: (context, _) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.lerp(
                    Alignment.topLeft,
                    Alignment.bottomRight,
                    _gradientAnimation.value,
                  )!,
                  end: Alignment.lerp(
                    Alignment.bottomRight,
                    Alignment.topLeft,
                    _gradientAnimation.value,
                  )!,
                ),
              ),
            );
          },
        ),

        // Animated glow orbs
        ..._buildGlowOrbs(context, neonTheme),

        // Floating particles
        if (widget.showParticles) ..._buildParticles(context),

        // Subtle grid pattern overlay
        _buildGridOverlay(context),

        // Content
        widget.child,
      ],
    );
  }

  List<Widget> _buildGlowOrbs(BuildContext context, NeonThemeExtension neonTheme) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      // Top-left cyan glow
      Positioned(
        top: -100,
        left: -100,
        child: _GlowOrb(
          color: NeonColors.getNeon('cyan', isDark),
          glowColor: neonTheme.glowPrimary,
          size: 300,
        ).animate().scale(duration: 3.seconds, curve: Curves.easeInOut).then().shake(),
      ),
      // Top-right magenta glow
      Positioned(
        top: -150,
        right: -150,
        child: _GlowOrb(
          color: NeonColors.getNeon('magenta', isDark),
          glowColor: neonTheme.glowSecondary,
          size: 350,
        ).animate(delay: 1.seconds).scale(duration: 4.seconds, curve: Curves.easeInOut).then().shake(),
      ),
      // Bottom-center purple glow
      Positioned(
        bottom: -120,
        left: MediaQuery.of(context).size.width * 0.3,
        child: _GlowOrb(
          color: NeonColors.getNeon('purple', isDark),
          glowColor: NeonColors.getGlow('purple', isDark),
          size: 250,
        ).animate(delay: 2.seconds).scale(duration: 3.5.seconds, curve: Curves.easeInOut).then().shake(),
      ),
    ];
  }

  List<Widget> _buildParticles(BuildContext context) {
    return _particles.asMap().entries.map((entry) {
      final index = entry.key;
      final particle = entry.value;
      return AnimatedBuilder(
        animation: _particleController,
        builder: (context, _) {
          final progress = (_particleController.value + particle.offset) % 1.0;
          final size = MediaQuery.of(context).size;
          final x = (particle.startX + progress * particle.directionX * size.width) % size.width;
          final y = (particle.startY + progress * particle.directionY * size.height) % size.height;
          return Positioned(
            left: x,
            top: y,
            child: Opacity(
              opacity: particle.opacity * (0.5 + 0.5 * (1 - (progress - 0.5).abs() * 2)),
              child: Container(
                width: particle.size,
                height: particle.size,
                decoration: BoxDecoration(
                  color: particle.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: particle.color.withValues(alpha: 0.5),
                      blurRadius: particle.size * 2,
                      spreadRadius: particle.size * 0.5,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildGridOverlay(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomPaint(
      size: Size.infinite,
      painter: _GridPainter(
        color: isDark
            ? NeonColors.cyanDark.withValues(alpha: 0.03)
            : NeonColors.cyanLight.withValues(alpha: 0.05),
        spacing: 40,
      ),
    );
  }
}

/// Individual glow orb widget
class _GlowOrb extends StatelessWidget {
  final Color color;
  final Color glowColor;
  final double size;

  const _GlowOrb({
    required this.color,
    required this.glowColor,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor,
            blurRadius: size * 0.6,
            spreadRadius: size * 0.2,
          ),
        ],
      ),
    );
  }
}

/// Particle for floating animation
class _Particle {
  final double startX;
  final double startY;
  final double directionX;
  final double directionY;
  final double size;
  final Color color;
  final double opacity;
  final double offset;

  _Particle({
    required this.startX,
    required this.startY,
    required this.directionX,
    required this.directionY,
    required this.size,
    required this.color,
    required this.opacity,
    required this.offset,
  });

  static _Particle random() {
    final random = DateTime.now().millisecondsSinceEpoch.toDouble();
    final isDark = true; // Will be determined by context
    final colors = [
      NeonColors.cyanDark,
      NeonColors.magentaDark,
      NeonColors.purpleDark,
      NeonColors.greenDark,
    ];
    return _Particle(
      startX: (random * 12345) % 1.0,
      startY: (random * 67890) % 1.0,
      directionX: ((random * 11111) % 1.0) * 2 - 1,
      directionY: ((random * 22222) % 1.0) * 2 - 1,
      size: 2 + ((random * 33333) % 1.0) * 4,
      color: colors[((random * 44444) % colors.length).floor()],
      opacity: 0.1 + ((random * 55555) % 1.0) * 0.3,
      offset: (random * 66666) % 1.0,
    );
  }
}

/// Grid pattern painter
class _GridPainter extends CustomPainter {
  final Color color;
  final double spacing;

  _GridPainter({required this.color, required this.spacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Vertical lines
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Simplified neon background for smaller areas (cards, buttons, etc.)
class NeonContainer extends StatelessWidget {
  final Widget child;
  final Color? glowColor;
  final double borderRadius;
  final double blurRadius;
  final double spreadRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const NeonContainer({
    super.key,
    required this.child,
    this.glowColor,
    this.borderRadius = 16,
    this.blurRadius = 20,
    this.spreadRadius = 2,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGlowColor = glowColor ?? context.glowPrimary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isDark
              ? NeonColors.cyanDark.withValues(alpha: 0.3)
              : NeonColors.cyanLight.withValues(alpha: 0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: effectiveGlowColor.withValues(alpha: 0.3),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          colors: isDark
              ? [
                  NeonColors.cyanDark.withValues(alpha: 0.05),
                  NeonColors.magentaDark.withValues(alpha: 0.03),
                ]
              : [
                  NeonColors.cyanLight.withValues(alpha: 0.03),
                  NeonColors.magentaLight.withValues(alpha: 0.02),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}

/// Neon glow border wrapper
class NeonGlowBorder extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double borderRadius;
  final double borderWidth;
  final double glowRadius;

  const NeonGlowBorder({
    super.key,
    required this.child,
    required this.glowColor,
    this.borderRadius = 12,
    this.borderWidth = 1.5,
    this.glowRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.5),
            blurRadius: glowRadius,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: glowColor, width: borderWidth),
        ),
        child: child,
      ),
    );
  }
}