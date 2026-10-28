// Neon-styled card components for KrakenDraw
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import '../../../core/theme/app_theme.dart';
import '../../../core/network/api_client.dart';

/// Base neon card with glow effects
class GlowCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? glowColor;
  final bool animate;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Gradient? gradient;

  const GlowCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.glowColor,
    this.animate = true,
    this.onTap,
    this.borderColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveGlowColor = glowColor ?? context.glowPrimary;
    final effectiveBorderColor = borderColor ?? colorScheme.outlineVariant;

    Widget card = Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient ??
            LinearGradient(
              colors: isDark
                  ? [
                      colorScheme.surface.withValues(alpha: 0.9),
                      colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
                    ]
                  : [
                      colorScheme.surface,
                      colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        border: Border.all(color: effectiveBorderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: effectiveGlowColor.withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    if (animate) {
      return Animate(
        effects: [
          FadeEffect(duration: 300.ms),
          SlideEffect(begin: const Offset(0, 0.1), end: Offset.zero, duration: 300.ms),
        ],
        child: card,
      );
    }

    return card;
  }
}

/// Neon metric card for dashboard KPIs
class NeonMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? glowColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  const NeonMetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.glowColor,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveGlowColor = glowColor ?? context.glowPrimary;
    final effectiveIconColor = iconColor ?? colorScheme.primary;

    return Animate(
      effects: [
        FadeEffect(duration: 400.ms),
        SlideEffect(begin: const Offset(-0.2, 0), end: Offset.zero),
      ],
      child: GlowCard(
        glowColor: effectiveGlowColor,
        onTap: onTap,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Icon with glow
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [
                    effectiveIconColor.withValues(alpha: 0.2),
                    effectiveIconColor.withValues(alpha: 0.1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: effectiveIconColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(icon, color: effectiveIconColor, size: 28),
            ),
            const SizedBox(width: 16),
            // Title and value
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Orbitron',
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (onTap != null && trailing == null)
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

/// Neon stat card with trend indicator
class NeonStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? trend;
  final bool trendPositive;
  final IconData? trendIcon;
  final Color? glowColor;
  final VoidCallback? onTap;

  const NeonStatCard({
    super.key,
    required this.label,
    required this.value,
    this.trend,
    this.trendPositive = true,
    this.trendIcon,
    this.glowColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveGlowColor = glowColor ?? context.glowPrimary;
    final trendColor = trendPositive ? Colors.greenAccent : Colors.redAccent;

    return GlowCard(
      glowColor: effectiveGlowColor,
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Orbitron',
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trend != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: trendColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: trendColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendIcon ?? (trendPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded),
                        color: trendColor,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trend!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: trendColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Neon info card with icon, title, description and action
class NeonInfoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color? iconColor;
  final Color? glowColor;
  final Widget? action;
  final VoidCallback? onTap;
  final List<Widget>? children;

  const NeonInfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor,
    this.glowColor,
    this.action,
    this.onTap,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveGlowColor = glowColor ?? context.glowPrimary;
    final effectiveIconColor = iconColor ?? colorScheme.primary;

    return GlowCard(
      glowColor: effectiveGlowColor,
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      effectiveIconColor.withValues(alpha: 0.2),
                      effectiveIconColor.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Icon(icon, color: effectiveIconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (action != null) action!,
            ],
          ),
          if (children != null && children!.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...children!,
          ],
        ],
      ),
    );
  }
}

/// Neon list item card
class NeonListTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? glowColor;
  final bool showDivider;
  final EdgeInsetsGeometry? contentPadding;

  const NeonListTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.glowColor,
    this.showDivider = false,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveGlowColor = glowColor ?? context.glowPrimary;

    return GlowCard(
      glowColor: effectiveGlowColor,
      onTap: onTap,
      padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.zero,
      borderRadius: 0,
      child: Row(
        children: [
          leading,
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
          if (onTap != null && trailing == null)
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              size: 24,
            ),
        ],
      ),
    );
  }
}

/// Neon avatar with glow
class NeonAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double radius;
  final Color? glowColor;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const NeonAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.radius = 28,
    this.glowColor,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveGlowColor = glowColor ?? context.glowPrimary;
    final effectiveBgColor = backgroundColor ?? colorScheme.primary;
    final effectiveTextColor = textColor ?? colorScheme.onPrimary;

    // Build full image URL using ApiClient (handles relative paths and fixes localhost storage URLs)
    final fullImageUrl = ApiClient.instance.buildImageUrl(imageUrl);

    Widget avatar = Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            effectiveBgColor,
            effectiveBgColor.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: effectiveGlowColor.withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
        image: fullImageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(fullImageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: fullImageUrl.isEmpty
          ? Center(
              child: Text(
                initials ?? '?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: effectiveTextColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            )
          : null,
    );

    if (onTap != null) {
      avatar = GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return Animate(
      effects: [
        FadeEffect(duration: 300.ms),
        ScaleEffect(delay: Duration(milliseconds: 100), begin: const Offset(0, 0), end: const Offset(1, 1)),
      ],
      child: avatar,
    );
  }
}

/// Neon badge/chip
class NeonBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final Color? glowColor;
  final NeonBadgeStyle style;
  final VoidCallback? onTap;

  const NeonBadge({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.glowColor,
    this.style = NeonBadgeStyle.filled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? colorScheme.primary;
    final effectiveGlowColor = glowColor ?? context.glowPrimary;

    Color backgroundColor;
    Color textColor;
    BoxBorder? border;

    switch (style) {
      case NeonBadgeStyle.filled:
        backgroundColor = effectiveColor;
        textColor = colorScheme.onPrimary;
        break;
      case NeonBadgeStyle.outline:
        backgroundColor = Colors.transparent;
        textColor = effectiveColor;
        border = Border.all(color: effectiveColor, width: 1.5);
        break;
      case NeonBadgeStyle.soft:
        backgroundColor = effectiveColor.withValues(alpha: 0.15);
        textColor = effectiveColor;
        break;
    }

    Widget badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: border,
        boxShadow: style == NeonBadgeStyle.filled
            ? [
                BoxShadow(
                  color: effectiveGlowColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: 14),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      badge = GestureDetector(onTap: onTap, child: badge);
    }

    return Animate(
      effects: [
        FadeEffect(duration: 300.ms),
        ScaleEffect(delay: Duration(milliseconds: 100), begin: const Offset(0, 0), end: const Offset(1, 1)),
      ],
      child: badge,
    );
  }
}

enum NeonBadgeStyle {
  filled,
  outline,
  soft,
}

/// Neon progress indicator card
class NeonProgressCard extends StatelessWidget {
  final String title;
  final double progress; // 0.0 to 1.0
  final String? label;
  final Color? progressColor;
  final Color? glowColor;
  final bool showPercentage;

  const NeonProgressCard({
    super.key,
    required this.title,
    required this.progress,
    this.label,
    this.progressColor,
    this.glowColor,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveProgressColor = progressColor ?? colorScheme.primary;
    final effectiveGlowColor = glowColor ?? context.glowPrimary;
    final clampedProgress = progress.clamp(0.0, 1.0);

    return GlowCard(
      glowColor: effectiveGlowColor,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              if (showPercentage)
                Text(
                  '${(clampedProgress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: effectiveProgressColor,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Orbitron',
                      ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    colors: [
                      effectiveProgressColor,
                      effectiveProgressColor.withValues(alpha: 0.7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: effectiveGlowColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                transform: Matrix4.identity()
                  ..scaleByVector3(Vector3(clampedProgress, 1.0, 1.0))
                  ..translateByVector3(Vector3.zero()),
                alignment: Alignment.centerLeft,
              ),
            ],
          ),
          if (label != null) ...[
            const SizedBox(height: 8),
            Text(
              label!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
            ),
          ],
        ],
      ),
    );
  }
}