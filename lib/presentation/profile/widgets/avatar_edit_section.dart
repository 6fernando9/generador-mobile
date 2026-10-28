// Avatar Edit Section for KrakenDraw
// Reusable widget for editing avatar in EditProfilePage with live preview
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/presentation/profile/widgets/avatar_action_sheet.dart';

/// Avatar edit section with live preview for EditProfilePage
class AvatarEditSection extends StatefulWidget {
  final String? currentImageUrl;
  final String initials;
  final Color glowColor;
  final String heroTag;
  final Function(File?) onImageChanged;
  final VoidCallback onRemoveAvatar;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onPickImage; // Callback to parent for image picking

  const AvatarEditSection({
    super.key,
    required this.currentImageUrl,
    required this.initials,
    required this.glowColor,
    required this.heroTag,
    required this.onImageChanged,
    required this.onRemoveAvatar,
    this.isLoading = false,
    this.errorMessage,
    this.onPickImage,
  });

  @override
  State<AvatarEditSection> createState() => AvatarEditSectionState();
}

class AvatarEditSectionState extends State<AvatarEditSection> {
  File? _selectedImage;
  bool _showPreview = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasNewImage = _selectedImage != null;
    final displayImageUrl = hasNewImage ? null : widget.currentImageUrl;
    final displayInitials = hasNewImage ? '' : widget.initials;

    return Column(
      children: [
        // Avatar with camera button
        Animate(
          effects: [
            FadeEffect(duration: 400.ms),
            ScaleEffect(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0)),
          ],
          child: Stack(
            children: [
              // Avatar preview (shows selected image or current)
              Hero(
                tag: widget.heroTag,
                child: _buildAvatar(displayImageUrl, displayInitials, hasNewImage),
              ),
              // Camera button overlay
              Positioned(
                bottom: 0,
                right: 0,
                child: _buildCameraButton(context),
              ),
              // Loading overlay
              if (widget.isLoading)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: widget.glowColor,
                      strokeWidth: 3,
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Preview badge when new image selected
        if (hasNewImage)
          Animate(
            effects: [
              FadeEffect(duration: 300.ms),
              SlideEffect(begin: const Offset(0, -0.2), end: Offset.zero),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: NeonColors.getNeon('green', isDark).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: NeonColors.getNeon('green', isDark).withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: NeonColors.getNeon('green', isDark),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Nueva imagen seleccionada',
                    style: GoogleFonts.spaceGrotesk(
                      color: NeonColors.getNeon('green', isDark),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _clearSelection,
                    child: Icon(
                      Icons.close_rounded,
                      color: NeonColors.getNeon('green', isDark),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Error message
        if (widget.errorMessage != null)
          Animate(
            effects: [
              FadeEffect(duration: 300.ms),
              ShakeEffect(duration: 300.ms),
            ],
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.errorMessage!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 8),

        // Hint text
        Animate(
          effects: [
            FadeEffect(duration: 400.ms, delay: 300.ms),
          ],
          child: Text(
            hasNewImage
                ? 'Toca el avatar para cambiar la imagen • Guarda para aplicar'
                : 'Toca el avatar para cambiar • Se recortará a cuadrado 1:1',
            style: GoogleFonts.inter(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String? imageUrl, String initials, bool isNewImage) {
    final radius = 50.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget avatar;

    if (_selectedImage != null) {
      // Show selected image from file
      avatar = Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: FileImage(_selectedImage!),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.glowColor.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 3,
            ),
          ],
        ),
      );
    } else if (imageUrl != null) {
      // Show current avatar from network
      avatar = Container(
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
              color: widget.glowColor.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 3,
            ),
          ],
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      // Show initials
      avatar = Container(
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
              color: widget.glowColor.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Center(
          child: Text(
            initials,
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: radius * 0.6,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _showActionSheet,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: avatar,
      ),
    );
  }

  Widget _buildCameraButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final buttonSize = 36.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _showActionSheet,
        borderRadius: BorderRadius.circular(buttonSize / 2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: widget.glowColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.surface,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: 0.5),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(
            Icons.camera_alt_rounded,
            color: colorScheme.onPrimary,
            size: 18,
          ),
        ),
      ),
    );
  }

  void _showActionSheet() {
    AvatarActionSheet.show(
      context,
      imageUrl: _selectedImage != null ? null : widget.currentImageUrl,
      initials: _selectedImage != null ? '' : widget.initials,
      glowColor: widget.glowColor,
      heroTag: widget.heroTag,
      onPickImage: widget.onPickImage ?? _pickImage,
      onRemoveAvatar: _handleRemoveAvatar,
      canRemove: widget.currentImageUrl != null || _selectedImage != null,
    );
  }

  Future<void> _pickImage() async {
    // Fallback empty implementation - parent should provide onPickImage callback
  }

  void _handleRemoveAvatar() {
    setState(() {
      _selectedImage = null;
    });
    widget.onImageChanged(null); // null means remove
    widget.onRemoveAvatar();
  }

  void _clearSelection() {
    setState(() {
      _selectedImage = null;
    });
    widget.onImageChanged(widget.currentImageUrl != null ? null : null);
  }

  /// Call this from parent when image is picked
  void setSelectedImage(File? image) {
    setState(() {
      _selectedImage = image;
    });
    if (image != null) {
      widget.onImageChanged(image);
    }
  }
}