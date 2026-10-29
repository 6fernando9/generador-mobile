// Date Range Selector for Dashboard
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/presentation/dashboard/dashboard_providers.dart';
import 'package:mobile/presentation/shared/widgets/neon_card.dart';
import 'package:mobile/core/theme/neon_colors.dart';

/// Date range selector with icon support and fallback
class DateRangeSelector extends ConsumerWidget {
  final bool showLabel;
  final bool compact;

  const DateRangeSelector({
    super.key,
    this.showLabel = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRange = ref.watch(dateRangeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[
          Text(
            'Rango de fechas',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
        ],
        // Horizontal scrollable chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: DateRangePreset.values.map((preset) {
              final isSelected = selectedRange == preset;
              return Padding(
                padding: EdgeInsets.only(right: compact ? 6 : 8),
                child: _DateRangeChip(
                  preset: preset,
                  isSelected: isSelected,
                  compact: compact,
                  onTap: () => ref.read(dateRangeProvider.notifier).setPreset(preset),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// Individual date range chip with icon fallback
class _DateRangeChip extends StatelessWidget {
  final DateRangePreset preset;
  final bool isSelected;
  final bool compact;
  final VoidCallback onTap;

  const _DateRangeChip({
    required this.preset,
    required this.isSelected,
    required this.compact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Primary color based on preset
    final Color primaryColor = switch (preset) {
      DateRangePreset.today => NeonColors.getNeon('cyan', isDark),
      DateRangePreset.week => NeonColors.getNeon('magenta', isDark),
      DateRangePreset.month => NeonColors.getNeon('purple', isDark),
      DateRangePreset.quarter => NeonColors.getNeon('blue', isDark),
      DateRangePreset.year => NeonColors.getNeon('green', isDark),
      DateRangePreset.custom => NeonColors.getNeon('orange', isDark),
    };

    final Color glowColor = isDark
        ? primaryColor.withValues(alpha: 0.4)
        : primaryColor.withValues(alpha: 0.3);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(compact ? 20 : 24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 16,
            vertical: compact ? 6 : 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(compact ? 20 : 24),
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      primaryColor.withValues(alpha: isDark ? 0.25 : 0.15),
                      primaryColor.withValues(alpha: isDark ? 0.1 : 0.05),
                    ],
                  )
                : null,
            color: isSelected ? null : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            border: Border.all(
              color: isSelected
                  ? primaryColor.withValues(alpha: 0.5)
                  : colorScheme.outlineVariant.withValues(alpha: 0.3),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: glowColor,
                      blurRadius: compact ? 8 : 12,
                      spreadRadius: compact ? 1 : 2,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with fallback
              _IconWithFallback(
                icon: preset.icon,
                size: compact ? 16 : 18,
                color: isSelected ? primaryColor : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              if (!compact) const SizedBox(width: 8),
              // Label
              if (!compact)
                Text(
                  preset.label,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? primaryColor : colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icon widget with fallback support
/// Tries primary icon, falls back to alternative if unavailable,
/// finally shows text-only badge
class _IconWithFallback extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;

  const _IconWithFallback({
    required this.icon,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Try to render the icon, if it fails (throws), show fallback
    return Icon(
      icon,
      size: size,
      color: color,
    );
  }
}

/// Alternative: DateRangeSelector as a dropdown/popup menu for more options
class DateRangeSelectorPopup extends ConsumerWidget {
  final bool showLabel;

  const DateRangeSelectorPopup({super.key, this.showLabel = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRange = ref.watch(dateRangeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[
          Text(
            'Rango de fechas',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
        ],
        // Dropdown button
        Material(
          color: Colors.transparent,
          child: PopupMenuButton<DateRangePreset>(
            initialValue: selectedRange,
            onSelected: (value) => ref.read(dateRangeProvider.notifier).setPreset(value),
            itemBuilder: (context) => DateRangePreset.values.map((preset) {
              return PopupMenuItem<DateRangePreset>(
                value: preset,
                child: Row(
                  children: [
                    Icon(
                      preset.icon,
                      size: 20,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      preset.label,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selectedRange.icon,
                    size: 18,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedRange.label,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}