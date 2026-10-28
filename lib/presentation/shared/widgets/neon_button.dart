// Neon-styled button components for KrakenDraw
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/core/theme/app_theme.dart';

/// Neon glow button with animated press effects
class NeonButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final NeonButtonStyle style;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const NeonButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.style = NeonButtonStyle.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius = 12,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _pressController.forward();
    }
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onPressed != null && !widget.isLoading) {
      _pressController.reverse();
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      _pressController.reverse();
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    Color foregroundColor;
    Color glowColor;
    BorderSide? borderSide;

    switch (widget.style) {
      case NeonButtonStyle.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        glowColor = context.glowPrimary;
        break;
      case NeonButtonStyle.secondary:
        backgroundColor = colorScheme.secondary;
        foregroundColor = colorScheme.onSecondary;
        glowColor = context.glowSecondary;
        break;
      case NeonButtonStyle.accent:
        backgroundColor = colorScheme.tertiary;
        foregroundColor = colorScheme.onTertiary;
        glowColor = NeonColors.getGlow('purple', isDark);
        break;
      case NeonButtonStyle.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        glowColor = context.glowPrimary;
        borderSide = BorderSide(color: colorScheme.primary, width: 1.5);
        break;
      case NeonButtonStyle.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        glowColor = Colors.transparent;
        break;
      case NeonButtonStyle.danger:
        backgroundColor = Colors.redAccent;
        foregroundColor = Colors.white;
        glowColor = Colors.redAccent.withValues(alpha: 0.4);
        break;
    }

    Widget buttonChild = AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: Container(
        padding: widget.padding ??
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: widget.style == NeonButtonStyle.ghost
              ? null
              : LinearGradient(
                  colors: [
                    backgroundColor,
                    backgroundColor.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          boxShadow: glowColor != Colors.transparent
              ? [
                  BoxShadow(
                    color: glowColor.withValues(alpha: _isPressed ? 0.6 : 0.4),
                    blurRadius: _isPressed ? 8 : 16,
                    spreadRadius: _isPressed ? 1 : 3,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
          border: borderSide != null
              ? Border.all(color: borderSide!.color, width: borderSide!.width)
              : null,
        ),
        child: widget.isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Row(
                mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: foregroundColor, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      widget.label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: foregroundColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
      ),
    );

    if (widget.onPressed == null || widget.isLoading) {
      return Opacity(
        opacity: 0.5,
        child: AbsorbPointer(child: buttonChild),
      );
    }

    return Animate(
      target: widget.onPressed != null ? 1 : 0,
      effects: [
        FadeEffect(duration: 300.ms),
        SlideEffect(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
          duration: 300.ms,
          curve: Curves.easeOutCubic,
        ),
      ],
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onPressed,
        child: buttonChild,
      ),
    );
  }
}

enum NeonButtonStyle {
  primary,
  secondary,
  accent,
  outline,
  ghost,
  danger,
}

/// Neon icon button
class NeonIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final NeonButtonStyle style;
  final double size;
  final Color? customColor;
  final String? tooltip;

  const NeonIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.style = NeonButtonStyle.ghost,
    this.size = 44,
    this.customColor,
    this.tooltip,
  });

  @override
  State<NeonIconButton> createState() => _NeonIconButtonState();
}

class _NeonIconButtonState extends State<NeonIconButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    Color iconColor;
    Color glowColor;
    Color backgroundColor;

    switch (widget.style) {
      case NeonButtonStyle.primary:
        iconColor = colorScheme.onPrimary;
        backgroundColor = colorScheme.primary;
        glowColor = context.glowPrimary;
        break;
      case NeonButtonStyle.secondary:
        iconColor = colorScheme.onSecondary;
        backgroundColor = colorScheme.secondary;
        glowColor = context.glowSecondary;
        break;
      case NeonButtonStyle.accent:
        iconColor = colorScheme.onTertiary;
        backgroundColor = colorScheme.tertiary;
        glowColor = NeonColors.getGlow('purple', isDark);
        break;
      case NeonButtonStyle.outline:
        iconColor = colorScheme.primary;
        backgroundColor = Colors.transparent;
        glowColor = context.glowPrimary;
        break;
      case NeonButtonStyle.ghost:
        iconColor = widget.customColor ?? colorScheme.primary;
        backgroundColor = Colors.transparent;
        glowColor = Colors.transparent;
        break;
      case NeonButtonStyle.danger:
        iconColor = Colors.white;
        backgroundColor = Colors.redAccent;
        glowColor = Colors.redAccent.withValues(alpha: 0.4);
        break;
    }

    Widget button = MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedScale(
        scale: _isHovered ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: glowColor != Colors.transparent
                ? [
                    BoxShadow(
                      color: glowColor.withValues(alpha: _isHovered ? 0.5 : 0.3),
                      blurRadius: _isHovered ? 12 : 8,
                      spreadRadius: _isHovered ? 2 : 1,
                    ),
                  ]
                : null,
            border: widget.style == NeonButtonStyle.outline
                ? Border.all(color: colorScheme.primary, width: 1.5)
                : null,
          ),
          child: Icon(
            widget.icon,
            color: iconColor,
            size: widget.size * 0.5,
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      button = Tooltip(message: widget.tooltip!, child: button);
    }

    if (widget.onPressed == null) {
      return Opacity(opacity: 0.5, child: AbsorbPointer(child: button));
    }

    return Animate(
      effects: [
        FadeEffect(duration: 300.ms),
        ScaleEffect(delay: Duration(milliseconds: 100), begin: const Offset(0, 0), end: const Offset(1, 1)),
      ],
      child: GestureDetector(
        onTap: widget.onPressed,
        child: button,
      ),
    );
  }
}

/// Neon toggle button (for theme switcher, etc.)
class NeonToggleButton extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData iconOn;
  final IconData iconOff;
  final String labelOn;
  final String labelOff;
  final NeonButtonStyle style;

  const NeonToggleButton({
    super.key,
    required this.value,
    required this.onChanged,
    required this.iconOn,
    required this.iconOff,
    required this.labelOn,
    required this.labelOff,
    this.style = NeonButtonStyle.primary,
  });

  @override
  State<NeonToggleButton> createState() => _NeonToggleButtonState();
}

class _NeonToggleButtonState extends State<NeonToggleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    if (widget.value) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant NeonToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      widget.value ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final isOn = _animation.value > 0.5;
        final progress = _animation.value;

        return GestureDetector(
          onTap: () => widget.onChanged(!widget.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Color.lerp(
                    colorScheme.surfaceContainerHighest,
                    colorScheme.primary,
                    progress,
                  )!,
                  Color.lerp(
                    colorScheme.surfaceContainerHighest,
                    colorScheme.primary.withValues(alpha: 0.7),
                    progress,
                  )!,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: context.glowPrimary.withValues(alpha: 0.3 * progress),
                  blurRadius: 8 + 8 * progress,
                  spreadRadius: 1 * progress,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Off state
                Opacity(
                  opacity: 1 - progress,
                  child: _ToggleSide(
                    icon: widget.iconOff,
                    label: widget.labelOff,
                    isActive: false,
                    colorScheme: colorScheme,
                  ),
                ),
                // On state
                Opacity(
                  opacity: progress,
                  child: _ToggleSide(
                    icon: widget.iconOn,
                    label: widget.labelOn,
                    isActive: true,
                    colorScheme: colorScheme,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ToggleSide extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final ColorScheme colorScheme;

  const _ToggleSide({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isActive ? colorScheme.primary : Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isActive ? colorScheme.onPrimary : colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isActive ? colorScheme.onPrimary : colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

/// Neon floating action button
class NeonFloatingActionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final NeonButtonStyle style;
  final bool mini;
  final bool isExtended;
  final String? extendedLabel;

  const NeonFloatingActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.style = NeonButtonStyle.primary,
    this.mini = false,
    this.isExtended = false,
    this.extendedLabel,
  });

  @override
  State<NeonFloatingActionButton> createState() => _NeonFloatingActionButtonState();
}

class _NeonFloatingActionButtonState extends State<NeonFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    Color foregroundColor;
    Color glowColor;

    switch (widget.style) {
      case NeonButtonStyle.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        glowColor = context.glowPrimary;
        break;
      case NeonButtonStyle.secondary:
        backgroundColor = colorScheme.secondary;
        foregroundColor = colorScheme.onSecondary;
        glowColor = context.glowSecondary;
        break;
      case NeonButtonStyle.accent:
        backgroundColor = colorScheme.tertiary;
        foregroundColor = colorScheme.onTertiary;
        glowColor = NeonColors.getGlow('purple', isDark);
        break;
      case NeonButtonStyle.danger:
        backgroundColor = Colors.redAccent;
        foregroundColor = Colors.white;
        glowColor = Colors.redAccent.withValues(alpha: 0.4);
        break;
      default:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        glowColor = context.glowPrimary;
    }

    final size = widget.mini ? 48.0 : 56.0;
    final iconSize = widget.mini ? 22.0 : 26.0;

    Widget fab = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: Container(
        width: widget.isExtended ? null : size,
        height: size,
        padding: widget.isExtended
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
            : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.mini ? 12 : 16),
          gradient: LinearGradient(
            colors: [backgroundColor, backgroundColor.withValues(alpha: 0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor.withValues(alpha: 0.4),
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: widget.isExtended && widget.extendedLabel != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, color: foregroundColor, size: iconSize),
                  const SizedBox(width: 8),
                  Text(
                    widget.extendedLabel!,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: foregroundColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              )
            : Icon(widget.icon, color: foregroundColor, size: iconSize),
      ),
    );

    if (widget.tooltip != null) {
      fab = Tooltip(message: widget.tooltip!, child: fab);
    }

    if (widget.onPressed == null) {
      return Opacity(opacity: 0.5, child: AbsorbPointer(child: fab));
    }

    return Animate(
      effects: [
        FadeEffect(duration: 300.ms, delay: Duration(milliseconds: 200)),
        ScaleEffect(delay: Duration(milliseconds: 300), begin: const Offset(0, 0), end: const Offset(1, 1)),
        ShakeEffect(),
      ],
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onPressed,
        child: fab,
      ),
    );
  }
}