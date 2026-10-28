// Chat page placeholder for KrakenDraw
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
import 'package:mobile/main.dart' show AppBottomNavBar;

/// Chat page - placeholder for future local AI integration
class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat en Línea'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/dashboard'),
        ),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated icon
                    Animate(
                      effects: [
                        FadeEffect(duration: 500.ms),
                        ScaleEffect(duration: 500.ms, curve: Curves.easeOutBack),
                      ],
                      child: Container(
                        width: 100 * context.responsiveFontScale,
                        height: 100 * context.responsiveFontScale,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25 * context.responsiveFontScale),
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
                          Icons.chat_bubble_outline_rounded,
                          size: 50 * context.responsiveFontScale,
                          color: primaryColor,
                        ),
                      ),
                    ),

                    SizedBox(height: 24 * context.responsiveFontScale),

                    // Title
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 100)),
                        SlideEffect(begin: const Offset(0, 0.2), end: Offset.zero, duration: 400.ms, delay: Duration(milliseconds: 100)),
                      ],
                      child: Text(
                        'Chat en Línea',
                        style: GoogleFonts.orbitron(
                          fontSize: 28 * context.responsiveFontScale,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),

                    SizedBox(height: 12 * context.responsiveFontScale),

                    // "En desarrollo" badge
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 200)),
                        SlideEffect(begin: const Offset(0, 0.2), end: Offset.zero, duration: 400.ms, delay: Duration(milliseconds: 200)),
                      ],
                      child: NeonBadge(
                        label: 'En desarrollo',
                        icon: Icons.construction_rounded,
                        color: NeonColors.getNeon('orange', isDark),
                        style: NeonBadgeStyle.filled,
                        glowColor: NeonColors.getGlow('orange', isDark),
                      ),
                    ),

                    SizedBox(height: 16 * context.responsiveFontScale),

                    // Description
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 300)),
                      ],
                      child: Text(
                        'Próximamente: Integración con IA local\npara consultas sobre el proyecto sin conexión a internet.',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 15 * context.responsiveFontScale,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: 32 * context.responsiveFontScale),

                    // Feature preview card
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 400)),
                        SlideEffect(begin: const Offset(0, 0.3), end: Offset.zero, duration: 400.ms, delay: Duration(milliseconds: 400)),
                      ],
                      child: GlowCard(
                        glowColor: primaryColor,
                        padding: EdgeInsets.all(20 * context.responsiveFontScale),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.psychology_rounded, color: primaryColor, size: 22),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'IA Local Offline',
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Modelo embebido para consultas técnicas\nsobre KrakenDraw sin necesidad de internet',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: NeonColors.getNeon('green', isDark).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.privacy_tip_rounded, color: NeonColors.getNeon('green', isDark), size: 22),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Privacidad Total',
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Tus datos y consultas nunca salen del dispositivo',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: NeonColors.getNeon('magenta', isDark).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.code_rounded, color: NeonColors.getNeon('magenta', isDark), size: 22),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Contexto del Proyecto',
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Conoce tu dashboard, métricas y configuración',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 32 * context.responsiveFontScale),

                    // Back button
                    Animate(
                      effects: [
                        FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 500)),
                        SlideEffect(begin: const Offset(0, 0.2), end: Offset.zero, duration: 400.ms, delay: Duration(milliseconds: 500)),
                      ],
                      child: NeonButton(
                        label: 'Volver al Dashboard',
                        icon: Icons.arrow_back_rounded,
                        style: NeonButtonStyle.primary,
                        isFullWidth: true,
                        onPressed: () => context.go('/dashboard'),
                      ),
                    ),

                    SizedBox(height: 24 * context.responsiveFontScale),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}