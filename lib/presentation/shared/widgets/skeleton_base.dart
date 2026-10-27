// Skeleton loader base components for KrakenDraw
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_theme.dart';

/// Base skeleton widget with configurable shimmer animation
class SkeletonBase extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;
  final double borderRadius;

  const SkeletonBase({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBaseColor = baseColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.grey[300]!);
    final effectiveHighlightColor = highlightColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.grey[100]!);

    return Shimmer.fromColors(
      baseColor: effectiveBaseColor,
      highlightColor: effectiveHighlightColor,
      period: period,
      direction: ShimmerDirection.ltr,
      child: child,
    );
  }
}

/// Skeleton box with rounded corners
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Skeleton circle (for avatars)
class SkeletonCircle extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? margin;

  const SkeletonCircle({
    super.key,
    this.size = 40,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Skeleton text line
class SkeletonText extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonText({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 4,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Skeleton card with multiple lines
class SkeletonCard extends StatelessWidget {
  final int lines;
  final double lineHeight;
  final double lineSpacing;
  final double? avatarSize;
  final bool hasAction;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const SkeletonCard({
    super.key,
    this.lines = 3,
    this.lineHeight = 14,
    this.lineSpacing = 8,
    this.avatarSize,
    this.hasAction = false,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (avatarSize != null) ...[
            Row(
              children: [
                SkeletonCircle(size: avatarSize!),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonText(width: 120, height: 18),
                      const SizedBox(height: 4),
                      SkeletonText(width: 80, height: 14),
                    ],
                  ),
                ),
                if (hasAction) SkeletonBox(width: 80, height: 32, borderRadius: 20),
              ],
            ),
            const SizedBox(height: 16),
          ],
          ...List.generate(lines, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: index == lines - 1 ? 0 : lineSpacing),
              child: SkeletonText(
                width: index == lines - 1 ? 200 : double.infinity,
                height: lineHeight,
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Skeleton for metric cards (dashboard overview)
class MetricsCardSkeleton extends StatelessWidget {
  const MetricsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonBase(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonText(width: 100, height: 14),
            const SizedBox(height: 12),
            SkeletonText(width: 80, height: 28),
            const SizedBox(height: 8),
            Row(
              children: [
                SkeletonText(width: 60, height: 12),
                const SizedBox(width: 8),
                SkeletonText(width: 60, height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for history list items (downloads, memberships)
class HistoryListSkeleton extends StatelessWidget {
  final int itemCount;

  const HistoryListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => SkeletonBase(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              SkeletonBox(width: 48, height: 48, borderRadius: 10),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonText(width: double.infinity, height: 16),
                    const SizedBox(height: 6),
                    SkeletonText(width: 150, height: 12),
                    const SizedBox(height: 4),
                    SkeletonText(width: 100, height: 11),
                  ],
                ),
              ),
              SkeletonBox(width: 80, height: 28, borderRadius: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton for membership/subscription card
class MembershipCardSkeleton extends StatelessWidget {
  const MembershipCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonBase(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SkeletonBox(width: 40, height: 40, borderRadius: 10),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonText(width: 140, height: 18),
                      const SizedBox(height: 4),
                      SkeletonText(width: 100, height: 13),
                    ],
                  ),
                ),
                SkeletonBox(width: 100, height: 32, borderRadius: 20),
              ],
            ),
            const SizedBox(height: 20),
            SkeletonText(width: 120, height: 14),
            const SizedBox(height: 8),
            SkeletonText(width: 200, height: 24),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: SkeletonText(height: 12)),
                const SizedBox(width: 12),
                Expanded(child: SkeletonText(height: 12)),
              ],
            ),
            const SizedBox(height: 20),
            SkeletonBox(width: double.infinity, height: 44, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for profile page
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonBase(
      child: Column(
        children: [
          // Avatar section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                SkeletonCircle(size: 100),
                const SizedBox(height: 16),
                SkeletonText(width: 180, height: 24),
                const SizedBox(height: 8),
                SkeletonText(width: 220, height: 16),
                const SizedBox(height: 4),
                SkeletonBox(width: 100, height: 24, borderRadius: 20),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Stats row
          Row(
            children: [
              Expanded(child: _statSkeleton(context)),
              const SizedBox(width: 12),
              Expanded(child: _statSkeleton(context)),
              const SizedBox(width: 12),
              Expanded(child: _statSkeleton(context)),
            ],
          ),
          const SizedBox(height: 16),
          // Action buttons
          Row(
            children: [
              Expanded(child: SkeletonBox(height: 48, borderRadius: 12)),
              const SizedBox(width: 12),
              Expanded(child: SkeletonBox(height: 48, borderRadius: 12)),
            ],
          ),
          const SizedBox(height: 24),
          // Sections
          ...List.generate(3, (index) => Column(
            children: [
              SkeletonBase(child: _sectionSkeleton(context)),
              const SizedBox(height: 16),
            ],
          )),
        ],
      ),
    );
  }

  Widget _statSkeleton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          SkeletonText(width: 60, height: 24),
          const SizedBox(height: 4),
          SkeletonText(width: 40, height: 12),
        ],
      ),
    );
  }

  Widget _sectionSkeleton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonText(width: 120, height: 18),
          const SizedBox(height: 12),
          SkeletonText(width: double.infinity, height: 14),
          const SizedBox(height: 8),
          SkeletonText(width: 200, height: 14),
        ],
      ),
    );
  }
}

/// Skeleton for login/register forms
class AuthFormSkeleton extends StatelessWidget {
  const AuthFormSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonBase(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SkeletonText(width: 150, height: 28),
            const SizedBox(height: 8),
            SkeletonText(width: 200, height: 14),
            const SizedBox(height: 24),
            SkeletonBox(height: 56, borderRadius: 12),
            const SizedBox(height: 16),
            SkeletonBox(height: 56, borderRadius: 12),
            const SizedBox(height: 16),
            SkeletonBox(height: 56, borderRadius: 12),
            const SizedBox(height: 24),
            SkeletonBox(height: 56, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}

/// Shimmer wrapper with customizable direction
class DirectionalShimmer extends StatelessWidget {
  final Widget child;
  final ShimmerDirection direction;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;

  const DirectionalShimmer({
    super.key,
    required this.child,
    this.direction = ShimmerDirection.ltr,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: baseColor ?? (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[300]!),
      highlightColor: highlightColor ?? (isDark ? Colors.white.withValues(alpha: 0.2) : Colors.grey[100]!),
      period: period,
      direction: direction,
      child: child,
    );
  }
}

/// Pulse animation for loading states
class PulseLoader extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minOpacity;
  final double maxOpacity;

  const PulseLoader({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minOpacity = 0.4,
    this.maxOpacity = 1.0,
  });

  @override
  State<PulseLoader> createState() => _PulseLoaderState();
}

class _PulseLoaderState extends State<PulseLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat(reverse: true);
    _animation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Opacity(
        opacity: _animation.value,
        child: widget.child,
      ),
    );
  }
}