// Avatar Preview Modal for KrakenDraw
// Full-screen overlay with zoom/pan (Hero animation from profile avatar)
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/presentation/shared/widgets/neon_button.dart';
import 'package:google_fonts/google_fonts.dart';

/// Full-screen avatar preview with zoom/pan gestures
/// Opens via Hero animation from the profile avatar
class AvatarPreviewModal extends StatefulWidget {
  final String? imageUrl;
  final String initials;
  final Color glowColor;
  final String heroTag;
  final VoidCallback? onChangeAvatar;
  final VoidCallback? onRemoveAvatar;

  const AvatarPreviewModal({
    super.key,
    required this.imageUrl,
    required this.initials,
    required this.glowColor,
    required this.heroTag,
    this.onChangeAvatar,
    this.onRemoveAvatar,
  });

  static Future<void> show(
    BuildContext context, {
    required String? imageUrl,
    required String initials,
    required Color glowColor,
    required String heroTag,
    VoidCallback? onChangeAvatar,
    VoidCallback? onRemoveAvatar,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.9),
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => AvatarPreviewModal(
          imageUrl: imageUrl,
          initials: initials,
          glowColor: glowColor,
          heroTag: heroTag,
          onChangeAvatar: onChangeAvatar,
          onRemoveAvatar: onRemoveAvatar,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  State<AvatarPreviewModal> createState() => _AvatarPreviewModalState();
}

class _AvatarPreviewModalState extends State<AvatarPreviewModal>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _resetAnimation;
  bool _showUI = true;
  double _lastScale = 1.0;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.addListener(() {
      if (_resetAnimation != null) {
        _transformationController.value = _resetAnimation!.value;
      }
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap(TapDownDetails details) {
    final currentScale = _getCurrentScale();
    if (currentScale > 1.2) {
      _animateToIdentity();
    } else {
      _animateToZoom(details.localPosition);
    }
  }

  double _getCurrentScale() {
    final matrix = _transformationController.value;
    return matrix.getMaxScaleOnAxis();
  }

  void _animateToIdentity() {
    _resetAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurveTween(curve: Curves.easeOutCubic).animate(_animationController));
    _animationController.forward(from: 0);
  }

  void _animateToZoom(Offset focalPoint) {
    final screenCenter = Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 2,
    );

    final targetMatrix = Matrix4.identity()
      ..translate(screenCenter.dx, screenCenter.dy)
      ..scale(3.0)
      ..translate(-focalPoint.dx, -focalPoint.dy);

    _resetAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: targetMatrix,
    ).animate(CurveTween(curve: Curves.easeOutCubic).animate(_animationController));
    _animationController.forward(from: 0);
  }

  void _onScaleStart(ScaleStartDetails details) {
    _lastScale = _getCurrentScale();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.scale != 1.0) {
      // Let InteractiveViewer handle pinch zoom
    }
  }

  void _onScaleEnd(ScaleEndDetails details) {
    final currentScale = _getCurrentScale();
    if (currentScale < 1.0) {
      _animateToIdentity();
    } else if (currentScale > 4.0) {
      // Clamp max zoom
      _clampZoom(4.0);
    }
  }

  void _clampZoom(double maxScale) {
    final matrix = _transformationController.value;
    final currentScale = matrix.getMaxScaleOnAxis();
    if (currentScale > maxScale) {
      final factor = maxScale / currentScale;
      final center = Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
      );
      final clampedMatrix = matrix.clone()
        ..translate(center.dx, center.dy)
        ..scale(factor)
        ..translate(-center.dx, -center.dy);

      _resetAnimation = Matrix4Tween(
        begin: matrix,
        end: clampedMatrix,
      ).animate(CurveTween(curve: Curves.easeOutCubic).animate(_animationController));
      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Animate(
      effects: [
        FadeEffect(duration: 200.ms),
      ],
      child: GestureDetector(
        onTap: () => setState(() => _showUI = !_showUI),
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Avatar with zoom/pan
              Center(
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 1.0,
                  maxScale: 5.0,
                  panEnabled: true,
                  scaleEnabled: true,
                  onInteractionStart: _onScaleStart,
                  onInteractionUpdate: _onScaleUpdate,
                  onInteractionEnd: _onScaleEnd,
                  child: GestureDetector(
                    onDoubleTapDown: _handleDoubleTap,
                    child: Hero(
                      tag: widget.heroTag,
                      child: _buildAvatar(),
                    ),
                  ),
                ),
              ),

              // Top bar with close button
              if (_showUI)
                SafeArea(
                  child: Animate(
                    effects: [
                      FadeEffect(duration: 200.ms),
                      SlideEffect(begin: const Offset(0, -1), end: Offset.zero),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title
                          Text(
                            'Avatar',
                            style: GoogleFonts.spaceGrotesk(
                              color: colorScheme.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // Close button
                          _NeonIconButton(
                            icon: Icons.close_rounded,
                            color: colorScheme.onSurface,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Bottom actions
              if (_showUI)
                SafeArea(
                  child: Animate(
                    effects: [
                      FadeEffect(duration: 200.ms, delay: 100.ms),
                      SlideEffect(begin: const Offset(0, 1), end: Offset.zero, delay: 100.ms),
                    ],
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 32, left: 24, right: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Change avatar button
                            if (widget.onChangeAvatar != null)
                              _NeonActionButton(
                                label: 'Cambiar',
                                icon: Icons.camera_alt_rounded,
                                color: widget.glowColor,
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget.onChangeAvatar?.call();
                                },
                              ),
                            if (widget.onChangeAvatar != null && widget.onRemoveAvatar != null)
                              const SizedBox(width: 16),
                            // Remove avatar button
                            if (widget.onRemoveAvatar != null && widget.imageUrl != null)
                              _NeonActionButton(
                                label: 'Eliminar',
                                icon: Icons.delete_outline_rounded,
                                color: Colors.redAccent,
                                style: NeonButtonStyle.outline,
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget.onRemoveAvatar?.call();
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // Zoom indicator
              if (_showUI && _getCurrentScale() > 1.05)
                SafeArea(
                  child: Animate(
                    effects: [FadeEffect(duration: 150.ms)],
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: widget.glowColor.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${(_getCurrentScale() * 100).toInt()}%',
                            style: GoogleFonts.orbitron(
                              color: widget.glowColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Hint text
              if (_showUI && _getCurrentScale() <= 1.05)
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Animate(
                        effects: [
                          FadeEffect(duration: 300.ms, delay: 500.ms),
                          SlideEffect(begin: const Offset(0, 0.5), end: Offset.zero, delay: 500.ms),
                        ],
                        child: Text(
                          'Doble tap para zoom • Arrastra para mover • Desliza abajo para cerrar',
                          style: GoogleFonts.inter(
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final radius = 120.0;

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            widget.glowColor,
            widget.glowColor.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.glowColor.withValues(alpha: 0.5),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
        image: widget.imageUrl != null
            ? DecorationImage(
                image: NetworkImage(widget.imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: widget.imageUrl == null
          ? Center(
              child: Text(
                widget.initials,
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
}

/// Neon-styled icon button for modal
class _NeonIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _NeonIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}

/// Neon-styled action button for modal bottom actions
class _NeonActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final NeonButtonStyle style;
  final VoidCallback onPressed;

  const _NeonActionButton({
    required this.label,
    required this.icon,
    required this.color,
    this.style = NeonButtonStyle.primary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    Color textColor;
    BoxBorder? border;

    switch (style) {
      case NeonButtonStyle.primary:
      case NeonButtonStyle.secondary:
      case NeonButtonStyle.accent:
      case NeonButtonStyle.danger:
        backgroundColor = color;
        textColor = colorScheme.onPrimary;
        break;
      case NeonButtonStyle.outline:
        backgroundColor = Colors.transparent;
        textColor = color;
        border = Border.all(color: color, width: 1.5);
        break;
      case NeonButtonStyle.ghost:
        backgroundColor = Colors.transparent;
        textColor = color;
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: border,
            boxShadow: (style == NeonButtonStyle.primary ||
                      style == NeonButtonStyle.secondary ||
                      style == NeonButtonStyle.accent ||
                      style == NeonButtonStyle.danger)
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}