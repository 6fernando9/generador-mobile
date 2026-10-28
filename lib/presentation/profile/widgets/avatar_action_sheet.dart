// Avatar Action Sheet for KrakenDraw
// Bottom sheet with options: View, Change, Remove avatar
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'avatar_preview_modal.dart';

/// Bottom sheet for avatar actions: View, Change, Remove
class AvatarActionSheet extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final Color glowColor;
  final String heroTag;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveAvatar;
  final bool isRemoving;
  final bool canRemove;

  const AvatarActionSheet({
    super.key,
    required this.imageUrl,
    required this.initials,
    required this.glowColor,
    required this.heroTag,
    required this.onPickImage,
    required this.onRemoveAvatar,
    this.isRemoving = false,
    this.canRemove = true,
  });

  static Future<void> show(
    BuildContext context, {
    required String? imageUrl,
    required String initials,
    required Color glowColor,
    required String heroTag,
    required VoidCallback onPickImage,
    required VoidCallback onRemoveAvatar,
    bool isRemoving = false,
    bool canRemove = true,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AvatarActionSheet(
        imageUrl: imageUrl,
        initials: initials,
        glowColor: glowColor,
        heroTag: heroTag,
        onPickImage: onPickImage,
        onRemoveAvatar: onRemoveAvatar,
        isRemoving: isRemoving,
        canRemove: canRemove,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Animate(
      effects: [
        FadeEffect(duration: 200.ms),
      ],
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.2),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Animate(
                  effects: [
                    FadeEffect(duration: 200.ms),
                    SlideEffect(begin: const Offset(0, -0.3), end: Offset.zero),
                  ],
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Avatar preview (small)
                Animate(
                  effects: [
                    FadeEffect(duration: 250.ms, delay: 50.ms),
                    ScaleEffect(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0), delay: 50.ms),
                  ],
                  child: _buildAvatarPreview(),
                ),

                const SizedBox(height: 20),

                // Title
                Animate(
                  effects: [
                    FadeEffect(duration: 250.ms, delay: 100.ms),
                    SlideEffect(begin: const Offset(0, 0.2), end: Offset.zero, delay: 100.ms),
                  ],
                  child: Text(
                    'Avatar del Perfil',
                    style: GoogleFonts.spaceGrotesk(
                      color: colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle
                Animate(
                  effects: [
                    FadeEffect(duration: 250.ms, delay: 150.ms),
                    SlideEffect(begin: const Offset(0, 0.2), end: Offset.zero, delay: 150.ms),
                  ],
                  child: Text(
                    imageUrl != null
                        ? 'Tienes un avatar personalizado'
                        : 'Usando iniciales como avatar',
                    style: GoogleFonts.inter(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Action buttons
                Animate(
                  effects: [
                    FadeEffect(duration: 300.ms, delay: 200.ms),
                    SlideEffect(begin: const Offset(0, 0.3), end: Offset.zero, delay: 200.ms),
                  ],
                  child: _buildActionButton(
                    context,
                    icon: Icons.visibility_rounded,
                    label: 'Ver en pantalla completa',
                    subtitle: 'Zoom, mover y examinar detalle',
                    color: glowColor,
                    onTap: () {
                      Navigator.pop(context);
                      AvatarPreviewModal.show(
                        context,
                        imageUrl: imageUrl,
                        initials: initials,
                        glowColor: glowColor,
                        heroTag: heroTag,
                        onChangeAvatar: onPickImage,
                        onRemoveAvatar: onRemoveAvatar,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                Animate(
                  effects: [
                    FadeEffect(duration: 300.ms, delay: 250.ms),
                    SlideEffect(begin: const Offset(0, 0.3), end: Offset.zero, delay: 250.ms),
                  ],
                  child: _buildActionButton(
                    context,
                    icon: Icons.camera_alt_rounded,
                    label: 'Cambiar avatar',
                    subtitle: 'Tomar foto o elegir de galería',
                    color: NeonColors.getNeon('green', isDark),
                    onTap: () {
                      Navigator.pop(context);
                      onPickImage();
                    },
                  ),
                ),

                if (canRemove && imageUrl != null) ...[
                  const SizedBox(height: 12),
                  Animate(
                    effects: [
                      FadeEffect(duration: 300.ms, delay: 300.ms),
                      SlideEffect(begin: const Offset(0, 0.3), end: Offset.zero, delay: 300.ms),
                    ],
                    child: _buildActionButton(
                      context,
                      icon: Icons.delete_outline_rounded,
                      label: 'Eliminar avatar',
                      subtitle: 'Volver a usar iniciales',
                      color: Colors.redAccent,
                      isDestructive: true,
                      isLoading: isRemoving,
                      onTap: isRemoving ? null : _showRemoveConfirmation,
                    ),
                  ),
                ],

                const SizedBox(height: 8),

                // Cancel button
                Animate(
                  effects: [
                    FadeEffect(duration: 300.ms, delay: 350.ms),
                    SlideEffect(begin: const Offset(0, 0.3), end: Offset.zero, delay: 350.ms),
                  ],
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPreview() {
    final radius = 50.0;

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            glowColor,
            glowColor.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 3,
          ),
        ],
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null
          ? Center(
              child: Text(
                initials,
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: radius * 0.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback? onTap,
    bool isDestructive = false,
    bool isLoading = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.redAccent.withValues(alpha: 0.1)
                : color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDestructive
                  ? Colors.redAccent.withValues(alpha: 0.3)
                  : color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? Colors.redAccent.withValues(alpha: 0.15)
                      : color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isLoading
                    ? Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: color,
                          ),
                        ),
                      )
                    : Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.spaceGrotesk(
                        color: isDestructive ? Colors.redAccent : colorScheme.onSurface,
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

  void _showRemoveConfirmation() {
    // This will be handled by the parent widget passing a callback that shows confirmation
    onRemoveAvatar();
  }
}