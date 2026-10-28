// Profile page for KrakenDraw
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/presentation/shared/widgets/neon_background.dart';
import 'package:mobile/presentation/shared/widgets/neon_button.dart';
import 'package:mobile/presentation/shared/widgets/neon_card.dart';
import 'package:mobile/presentation/shared/widgets/neon_input.dart';
import 'package:mobile/presentation/profile/skeleton/profile_skeleton.dart';
import 'package:mobile/presentation/profile/profile_controller.dart';
import 'package:mobile/presentation/auth/auth_wrapper.dart';
import 'package:mobile/data/models/profile_models.dart';
import 'package:intl/intl.dart';

/// Profile page with avatar, info, and actions
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load profile when page is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileControllerProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: NeonBackground(
        showParticles: false,
        animationDuration: const Duration(seconds: 8),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(profileControllerProvider.notifier).loadProfile();
            },
            child: Consumer(
              builder: (context, ref, _) {
                final profileState = ref.watch(profileControllerProvider);

                return profileState.profile.when(
                  data: (perfil) => _buildProfileContent(context, perfil, ref),
                  loading: () => const ProfileSkeleton(),
                  error: (error, _) =>
                      _buildErrorState(context, error.toString(), ref),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(
      BuildContext context, Perfil perfil, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Avatar section
          Animate(
            effects: [
              FadeEffect(duration: 400.ms),
              SlideEffect(
                  begin: const Offset(0, -0.2),
                  end: Offset.zero,
                  duration: 400.ms),
            ],
            child: _buildAvatarSection(context, perfil),
          ),

          const SizedBox(height: 24),

          // Stats row
          Animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 100)),
              SlideEffect(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                  duration: 400.ms,
                  delay: Duration(milliseconds: 100)),
            ],
            child: _buildStatsRow(context, perfil),
          ),

          const SizedBox(height: 24),

          // Action buttons
          Animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 200)),
              SlideEffect(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                  duration: 400.ms,
                  delay: Duration(milliseconds: 200)),
            ],
            child: _buildActionButtons(context),
          ),

          const SizedBox(height: 24),

          // Info sections
          Animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 300)),
              SlideEffect(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                  duration: 400.ms,
                  delay: Duration(milliseconds: 300)),
            ],
            child: _buildInfoSection(
              context,
              'Información de la Cuenta',
              Icons.info_outline_rounded,
              [
                _InfoRow('Usuario', perfil.username),
                _InfoRow('Email', perfil.email),
                _InfoRow('Rol', perfil.primaryRoleName),
                _InfoRow('Plan', perfil.planName, valueColor: primaryColor),
                _InfoRow(
                  'Miembro desde',
                  perfil.createdAt != null
                      ? DateFormat('dd/MM/yyyy').format(perfil.createdAt!)
                      : 'Desconocido',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 400)),
              SlideEffect(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                  duration: 400.ms,
                  delay: Duration(milliseconds: 400)),
            ],
            child: _buildInfoSection(
              context,
              'Estadísticas',
              Icons.analytics_outlined,
              [
                _InfoRow('Generaciones hoy', '${perfil.generacionesHoy}'),
                _InfoRow('Generaciones totales', '${perfil.generacionesTotal}'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 500)),
              SlideEffect(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                  duration: 400.ms,
                  delay: Duration(milliseconds: 500)),
            ],
            child: _buildInfoSection(
              context,
              'Seguridad',
              Icons.security_outlined,
              [
                _InfoRow('Autenticación', 'Email/Contraseña'),
                _InfoRow('Sesión actual', 'Activa en este dispositivo'),
              ],
              actions: [
                TextButton.icon(
                  onPressed: () => context.push('/profile/change-password'),
                  icon: const Icon(Icons.lock_outline_rounded, size: 18),
                  label: Text(
                    'Cambiar contraseña',
                    style: GoogleFonts.inter(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Logout button
          Animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 600)),
              SlideEffect(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                  duration: 400.ms,
                  delay: Duration(milliseconds: 600)),
            ],
            child: NeonButton(
              label: 'Cerrar Sesión',
              icon: Icons.logout_rounded,
              style: NeonButtonStyle.danger,
              isFullWidth: true,
              onPressed: () => _showLogoutDialog(context, ref),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context, Perfil perfil) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;

    return GlowCard(
      glowColor: primaryColor,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              NeonAvatar(
                imageUrl: perfil.profileIcon,
                initials: perfil.username.substring(0, 1).toUpperCase(),
                radius: 50,
                glowColor: primaryColor,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.surface, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Username
          Text(
            perfil.username,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          // Email
          Text(
            perfil.email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: 8),
          // Role & Plan badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeonBadge(
                label: perfil.primaryRoleName,
                icon: Icons.badge_rounded,
                color: colorScheme.primary,
                style: NeonBadgeStyle.soft,
              ),
              const SizedBox(width: 8),
              NeonBadge(
                label: perfil.planName,
                icon: Icons.star_rounded,
                color: NeonColors.getNeon('orange', isDark),
                style: NeonBadgeStyle.filled,
                glowColor: NeonColors.getGlow('orange', isDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, Perfil perfil) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Hoy',
            perfil.generacionesHoy.toString(),
            Icons.today_rounded,
            'cyan',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Total',
            perfil.generacionesTotal.toString(),
            Icons.insights_rounded,
            'magenta',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Días activo',
            perfil.createdAt != null
                ? '${DateTime.now().difference(perfil.createdAt!).inDays}'
                : '0',
            Icons.calendar_today_rounded,
            'green',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    String neonColor,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = NeonColors.getNeon(neonColor, isDark);

    return GlowCard(
      padding: const EdgeInsets.all(16),
      glowColor: NeonColors.getGlow(neonColor, isDark),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Orbitron',
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: NeonButton(
            label: 'Editar Perfil',
            icon: Icons.edit_rounded,
            style: NeonButtonStyle.primary,
            isFullWidth: true,
            onPressed: () => context.push('/profile/edit'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: NeonButton(
            label: 'Contraseña',
            icon: Icons.lock_rounded,
            style: NeonButtonStyle.outline,
            isFullWidth: true,
            onPressed: () => context.push('/profile/change-password'),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    IconData icon,
    List<_InfoRow> rows, {
    List<Widget>? actions,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GlowCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: colorScheme.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              if (actions != null) ...actions,
            ],
          ),
          const SizedBox(height: 16),
          ...rows.map((row) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        row.label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        row.value,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: row.valueColor ?? colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      BuildContext context, String error, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: GlowCard(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              'Error al cargar perfil',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            NeonButton(
              label: 'Reintentar',
              icon: Icons.refresh_rounded,
              style: NeonButtonStyle.primary,
              onPressed: () =>
                  ref.read(profileControllerProvider.notifier).loadProfile(),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cerrar Sesión', style: GoogleFonts.spaceGrotesk()),
        content: Text(
          '¿Estás seguro de que quieres cerrar sesión?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: GoogleFonts.inter()),
          ),
          NeonButton(
            label: 'Cerrar Sesión',
            icon: Icons.logout_rounded,
            style: NeonButtonStyle.danger,
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authControllerProvider.notifier).logout();
              // AuthWrapper will automatically redirect to LoginPage
            },
          ),
        ],
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow(this.label, this.value, {this.valueColor});
}