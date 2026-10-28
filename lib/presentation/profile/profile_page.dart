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
import 'package:mobile/presentation/profile/widgets/avatar_preview_modal.dart';
import 'package:mobile/presentation/profile/widgets/avatar_action_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/main.dart' show AppBottomNavBar;

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
        title: const Text('Perfil'),
        centerTitle: true,
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
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    Perfil perfil,
    WidgetRef ref,
  ) {
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
                duration: 400.ms,
              ),
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
                delay: Duration(milliseconds: 100),
              ),
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
                delay: Duration(milliseconds: 200),
              ),
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
                delay: Duration(milliseconds: 300),
              ),
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
                delay: Duration(milliseconds: 400),
              ),
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
                delay: Duration(milliseconds: 500),
              ),
            ],
            child: _buildInfoSection(
              context,
              'Seguridad',
              Icons.security_outlined,
              [
                _InfoRow('Autenticación', 'Email/Contraseña'),
                _InfoRow('Sesión actual', 'Activa en este dispositivo'),
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
                delay: Duration(milliseconds: 600),
              ),
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
    final heroTag = 'profile-avatar-${perfil.id ?? perfil.username}';

    return GlowCard(
      glowColor: primaryColor,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              GestureDetector(
                onTap: () => _showAvatarPreview(context, perfil, heroTag),
                child: Hero(
                  tag: heroTag,
                  child: NeonAvatar(
                    imageUrl: perfil.profileIcon,
                    initials: perfil.username.substring(0, 1).toUpperCase(),
                    radius: 50,
                    glowColor: primaryColor,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () =>
                        _showAvatarActionSheet(context, perfil, heroTag),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 3,
                        ),
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
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 8),
          // Role & Plan badges - responsive with Wrap for small screens
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              NeonBadge(
                label: perfil.primaryRoleName,
                icon: Icons.badge_rounded,
                color: colorScheme.primary,
                style: NeonBadgeStyle.soft,
              ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    if (isSmallScreen) {
      // Small screens: vertical stack
      return Column(
        children: [
          _buildStatCard(
            context,
            'Hoy',
            perfil.generacionesHoy.toString(),
            Icons.today_rounded,
            'cyan',
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            context,
            'Total',
            perfil.generacionesTotal.toString(),
            Icons.insights_rounded,
            'magenta',
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            context,
            'Días activo',
            perfil.createdAt != null
                ? '${DateTime.now().difference(perfil.createdAt!).inDays}'
                : '0',
            Icons.calendar_today_rounded,
            'green',
          ),
        ],
      );
    } else {
      // Large screens: horizontal row
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final scale = isSmallScreen
        ? 1.1
        : 1.0; // Slightly larger on small screens for better touch targets

    return GlowCard(
      padding: EdgeInsets.all(16 * scale),
      glowColor: NeonColors.getGlow(neonColor, isDark),
      child: Column(
        children: [
          Container(
            width: 40 * scale,
            height: 40 * scale,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10 * scale),
            ),
            child: Icon(icon, color: color, size: 20 * scale),
          ),
          SizedBox(height: 8 * scale),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              fontFamily: 'Orbitron',
              fontSize:
                  (Theme.of(context).textTheme.headlineSmall?.fontSize ?? 24) *
                  scale,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize:
                  (Theme.of(context).textTheme.labelSmall?.fontSize ?? 12) *
                  scale,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Breakpoint for small screens

    if (isSmallScreen) {
      // Small screens: vertical stack (Column)
      return Column(
        children: [
          NeonButton(
            label: 'Editar Perfil',
            icon: Icons.edit_rounded,
            style: NeonButtonStyle.primary,
            isFullWidth: true,
            onPressed: () => context.push('/profile/edit'),
          ),
          const SizedBox(height: 12),
          NeonButton(
            label: 'Cambiar Contraseña',
            icon: Icons.lock_rounded,
            style: NeonButtonStyle.outline,
            isFullWidth: true,
            onPressed: () => context.push('/profile/change-password'),
          ),
        ],
      );
    } else {
      // Large screens: horizontal (Row)
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
              label: 'Cambiar Contraseña',
              icon: Icons.lock_rounded,
              style: NeonButtonStyle.outline,
              isFullWidth: true,
              onPressed: () => context.push('/profile/change-password'),
            ),
          ),
        ],
      );
    }
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
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 12),
              if (actions != null) ...actions,
            ],
          ),
          const SizedBox(height: 16),
          ...rows.map(
            (row) => Padding(
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: GlowCard(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar perfil',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(color: colorScheme.onSurface),
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

  void _showAvatarPreview(BuildContext context, Perfil perfil, String heroTag) {
    AvatarPreviewModal.show(
      context,
      imageUrl: perfil.profileIcon,
      initials: perfil.username.substring(0, 1).toUpperCase(),
      glowColor: Theme.of(context).brightness == Brightness.dark
          ? NeonColors.cyanDark
          : NeonColors.cyanLight,
      heroTag: heroTag,
      onChangeAvatar: () => _showAvatarActionSheet(context, perfil, heroTag),
      onRemoveAvatar: perfil.profileIcon != null
          ? () => _confirmRemoveAvatar(context, ref)
          : null,
    );
  }

  void _showAvatarActionSheet(
    BuildContext context,
    Perfil perfil,
    String heroTag,
  ) {
    AvatarActionSheet.show(
      context,
      imageUrl: perfil.profileIcon,
      initials: perfil.username.substring(0, 1).toUpperCase(),
      glowColor: Theme.of(context).brightness == Brightness.dark
          ? NeonColors.cyanDark
          : NeonColors.cyanLight,
      heroTag: heroTag,
      onPickImage: () => _pickAndUploadAvatar(context, ref),
      onRemoveAvatar: () => _confirmRemoveAvatar(context, ref),
      canRemove: perfil.profileIcon != null,
    );
  }

  Future<void> _pickAndUploadAvatar(BuildContext context, WidgetRef ref) async {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Show source selection dialog
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildImageSourceSheet(context),
    );

    if (source == null) return;

    // Show loading indicator
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
                  ? 'Tomando foto...'
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
      final success = await ref
          .read(profileControllerProvider.notifier)
          .pickAndUploadAvatarWithSource(source);

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Avatar actualizado correctamente',
                style: GoogleFonts.inter(),
              ),
              backgroundColor: colorScheme.surfaceContainerHighest,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          final error = ref.read(profileControllerProvider).errorMessage;
          // Only show error if there's an actual error message (not user cancellation)
          if (error != null && error.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error, style: GoogleFonts.inter()),
                backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          // If error is null, it was a user cancellation - do nothing
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e', style: GoogleFonts.inter()),
            backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _confirmRemoveAvatar(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Avatar', style: GoogleFonts.spaceGrotesk()),
        content: Text(
          '¿Estás seguro de que quieres eliminar tu avatar? Volverás a usar tus iniciales.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: GoogleFonts.inter()),
          ),
          NeonButton(
            label: 'Eliminar',
            icon: Icons.delete_outline_rounded,
            style: NeonButtonStyle.danger,
            onPressed: () async {
              Navigator.pop(context);
              await _removeAvatar(context, ref);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _removeAvatar(BuildContext context, WidgetRef ref) async {
    final colorScheme = Theme.of(context).colorScheme;

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
              'Eliminando avatar...',
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
      final success = await ref
          .read(profileControllerProvider.notifier)
          .removeAvatar();

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Avatar eliminado correctamente',
                style: GoogleFonts.inter(),
              ),
              backgroundColor: colorScheme.surfaceContainerHighest,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          final error = ref.read(profileControllerProvider).errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error ?? 'Error al eliminar el avatar',
                style: GoogleFonts.inter(),
              ),
              backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e', style: GoogleFonts.inter()),
            backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

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
}

class _InfoRow {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow(this.label, this.value, {this.valueColor});
}
