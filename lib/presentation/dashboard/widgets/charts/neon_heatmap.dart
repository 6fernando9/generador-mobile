// Neon Heatmap for Actividad (Activity by Day × Hour)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/data/models/dashboard_actividad.dart';
import 'package:mobile/presentation/shared/widgets/neon_card.dart'
    show NeonBadge, NeonBadgeStyle;
import 'package:mobile/core/utils/responsive.dart';

/// Heatmap showing activity by day of week and hour
class NeonHeatmap extends StatefulWidget {
  final DashboardActividad data;
  final double cellSize;
  final double labelWidth;
  final double labelHeight;
  final ValueChanged<HeatmapCell>? onCellTap;

  const NeonHeatmap({
    super.key,
    required this.data,
    this.cellSize = 20,
    this.labelWidth = 40,
    this.labelHeight = 20,
    this.onCellTap,
  });

  @override
  State<NeonHeatmap> createState() => _NeonHeatmapState();
}

class _NeonHeatmapState extends State<NeonHeatmap> {
  HeatmapCell? _hoveredCell;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.data.heatmap.isEmpty) {
      return _buildEmptyState(context);
    }

    final days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    final hours = List.generate(24, (i) => i);

    // Calculate max value from heatmap for intensity calculation
    final maxValue = widget.data.heatmap.isNotEmpty
        ? widget.data.heatmap.map((p) => p.total).reduce((a, b) => a > b ? a : b)
        : 0;

    // Calculate responsive cell size based on screen width (not parent constraints)
    // to avoid infinite constraints when used inside ListView
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = Responsive.horizontalPadding(context).horizontal;
    final availableWidth = screenWidth - widget.labelWidth - horizontalPadding;
    final responsiveCellSize = (availableWidth / 24).clamp(14.0, 32.0);

    // Calculate total height to avoid infinite constraints
    // Title (22) + subtitle (22) + spacing (16) + hour labels (responsiveCellSize * 0.5 + 8) +
    // 7 rows * (responsiveCellSize + 8) + spacing (16) + legend (~50) + tooltip (~80 if visible)
    final titleHeight = 22.0 + 8.0 + 22.0 + 16.0; // Title + spacing + subtitle + spacing
    final hourLabelsHeight = (responsiveCellSize * 0.5).ceilToDouble() + 8.0;
    final rowsHeight = 7 * (responsiveCellSize + 8.0);
    final legendHeight = 50.0;
    final tooltipHeight = 80.0; // Max possible
    final totalHeight = titleHeight + hourLabelsHeight + rowsHeight + 16.0 + legendHeight + tooltipHeight;

    return SizedBox(
      height: totalHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Actividad por Día y Hora',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle with total and max
          Text(
            'Total: ${widget.data.total} generaciones  •  Máx: $maxValue',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          // Heatmap grid
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                // Hour labels (top)
                _buildHourLabels(hours, colorScheme, responsiveCellSize),
                // Rows for each day
                ...days.asMap().entries.map((dayEntry) {
                  final dayIndex = dayEntry.key;
                  final dayLabel = dayEntry.value;
                  return _buildDayRow(dayIndex, dayLabel, hours, maxValue, isDark, colorScheme, responsiveCellSize);
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Color legend
          _buildLegend(maxValue, isDark, colorScheme),
          // Tooltip for hovered cell
          if (_hoveredCell != null) ...[
            const SizedBox(height: 12),
            _buildTooltip(_hoveredCell!, maxValue, isDark, colorScheme),
          ],
        ],
      ),
    );
  }

  Widget _buildHourLabels(List<int> hours, ColorScheme colorScheme, double cellSize) {
    return Row(
      children: [
        SizedBox(width: widget.labelWidth),
        ...hours.map((hour) {
          return SizedBox(
            width: cellSize,
            child: Center(
              child: Text(
                '${hour.toString().padLeft(2, '0')}:00',
                style: GoogleFonts.inter(
                  fontSize: cellSize * 0.35,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDayRow(
    int dayIndex,
    String dayLabel,
    List<int> hours,
    int maxValue,
    bool isDark,
    ColorScheme colorScheme,
    double cellSize,
  ) {
    // Create a map for quick lookup of heatmap values
    final heatmapMap = {for (var p in widget.data.heatmap) '${p.dia}-${p.hora}': p.total};

    return Row(
      children: [
        // Day label
        SizedBox(
          width: widget.labelWidth,
          child: Center(
            child: Text(
              dayLabel,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
        // Cells for each hour
        ...hours.map((hour) {
          final value = heatmapMap['$dayIndex-$hour'] ?? 0;

          return _buildCell(dayIndex, hour, value, maxValue, isDark, colorScheme, cellSize);
        }),
      ],
    );
  }

  Widget _buildCell(
    int dayIndex,
    int hour,
    int value,
    int maxValue,
    bool isDark,
    ColorScheme colorScheme,
    double cellSize,
  ) {
    final intensity = maxValue > 0 ? value / maxValue : 0.0;
    final color = _getHeatmapColor(intensity, isDark);
    final isHovered = _hoveredCell != null &&
        _hoveredCell!.day == dayIndex &&
        _hoveredCell!.hour == hour;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredCell = HeatmapCell(day: dayIndex, hour: hour, value: value)),
      onExit: (_) => setState(() => _hoveredCell = null),
      child: GestureDetector(
        onTap: () {
          if (widget.onCellTap != null) {
            widget.onCellTap!(HeatmapCell(day: dayIndex, hour: hour, value: value));
          }
          setState(() => _hoveredCell = _hoveredCell?.day == dayIndex && _hoveredCell?.hour == hour
              ? null
              : HeatmapCell(day: dayIndex, hour: hour, value: value));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: cellSize,
          height: cellSize,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: value == 0
                ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                : color,
            borderRadius: BorderRadius.circular(3),
            border: isHovered
                ? Border.all(color: Colors.white.withValues(alpha: 0.8), width: 2)
                : null,
            boxShadow: isHovered && value > 0
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: value > 0 && cellSize >= 24
              ? Center(
                  child: Text(
                    value.toString(),
                    style: GoogleFonts.inter(
                      fontSize: cellSize * 0.35,
                      fontWeight: FontWeight.w600,
                      color: _getTextColorForBackground(color, isDark),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Color _getHeatmapColor(double intensity, bool isDark) {
    // Neon gradient: Cyan (low) → Magenta (mid) → Purple (high)
    if (intensity == 0) {
      return isDark
          ? Colors.grey.withValues(alpha: 0.1)
          : Colors.grey.withValues(alpha: 0.05);
    }

    if (intensity < 0.33) {
      // Low: Cyan
      final baseColor = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;
      return Color.lerp(
        baseColor.withValues(alpha: 0.15),
        baseColor.withValues(alpha: 0.5),
        intensity * 3,
      )!;
    } else if (intensity < 0.66) {
      // Medium: Magenta
      final baseColor = isDark ? NeonColors.magentaDark : NeonColors.magentaLight;
      return Color.lerp(
        baseColor.withValues(alpha: 0.5),
        baseColor.withValues(alpha: 0.8),
        (intensity - 0.33) * 3,
      )!;
    } else {
      // High: Purple
      final baseColor = isDark ? NeonColors.purpleDark : NeonColors.purpleLight;
      return Color.lerp(
        baseColor.withValues(alpha: 0.8),
        baseColor,
        (intensity - 0.66) * 3,
      )!;
    }
  }

  Color _getTextColorForBackground(Color background, bool isDark) {
    // Calculate luminance to determine text color
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? (isDark ? Colors.black : Colors.black) : Colors.white;
  }

  Widget _buildLegend(int maxValue, bool isDark, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Intensidad',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // No data
            _buildLegendItem(
              'Sin datos',
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              colorScheme,
            ),
            const SizedBox(width: 12),
            // Low
            _buildLegendItem(
              'Bajo',
              isDark ? NeonColors.cyanDark.withValues(alpha: 0.3) : NeonColors.cyanLight.withValues(alpha: 0.3),
              colorScheme,
            ),
            const SizedBox(width: 12),
            // Medium
            _buildLegendItem(
              'Medio',
              isDark ? NeonColors.magentaDark.withValues(alpha: 0.6) : NeonColors.magentaLight.withValues(alpha: 0.6),
              colorScheme,
            ),
            const SizedBox(width: 12),
            // High
            _buildLegendItem(
              'Alto',
              isDark ? NeonColors.purpleDark : NeonColors.purpleLight,
              colorScheme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildTooltip(HeatmapCell cell, int maxValue, bool isDark, ColorScheme colorScheme) {
    final days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    final dayName = cell.day < days.length ? days[cell.day] : 'Día ${cell.day + 1}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 18,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$dayName a las ${cell.hour.toString().padLeft(2, '0')}:00',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${cell.value} generaciones',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          if (maxValue > 0)
            NeonBadge(
              label: '${((cell.value / maxValue) * 100).toStringAsFixed(0)}% del máx',
              icon: Icons.trending_up_rounded,
              color: _getHeatmapColor(cell.value / maxValue, isDark),
              style: NeonBadgeStyle.soft,
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.grid_on_rounded,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin datos de actividad',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Genera proyectos para ver tu mapa de actividad',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cell data for heatmap interaction
class HeatmapCell {
  final int day; // 0-6 (Lun-Dom)
  final int hour; // 0-23
  final int value;

  const HeatmapCell({
    required this.day,
    required this.hour,
    required this.value,
  });
}

/// Compact heatmap for smaller spaces
class NeonMiniHeatmap extends StatelessWidget {
  final DashboardActividad data;
  final double cellSize;
  final bool showLabels;

  const NeonMiniHeatmap({
    super.key,
    required this.data,
    this.cellSize = 10,
    this.showLabels = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

    // Calculate max value
    final maxValue = data.heatmap.isNotEmpty
        ? data.heatmap.map((p) => p.total).reduce((a, b) => a > b ? a : b)
        : 0;

    // Create heatmap map for lookup
    final heatmapMap = {for (var p in data.heatmap) '${p.dia}-${p.hora}': p.total};

    return Column(
      children: [
        if (showLabels) ...[
          Row(
            children: [
              SizedBox(width: 16),
              ...List.generate(24, (h) => SizedBox(
                width: cellSize,
                child: Center(
                  child: Text(
                    h % 6 == 0 ? '${h.toString().padLeft(2, '0')}' : '',
                    style: GoogleFonts.inter(fontSize: 6, color: Colors.grey),
                  ),
                ),
              )),
            ],
          ),
          const SizedBox(height: 4),
        ],
        ...List.generate(7, (dayIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              children: [
                if (showLabels)
                  SizedBox(
                    width: 16,
                    child: Center(
                      child: Text(
                        days[dayIndex],
                        style: GoogleFonts.inter(fontSize: 8, color: Colors.grey),
                      ),
                    ),
                  ),
                ...List.generate(24, (hour) {
                  final value = heatmapMap['$dayIndex-$hour'] ?? 0;
                  final intensity = maxValue > 0 ? value / maxValue : 0.0;
                  return Container(
                    width: cellSize,
                    height: cellSize,
                    margin: const EdgeInsets.all(0.5),
                    decoration: BoxDecoration(
                      color: _getColor(intensity, isDark),
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }

  Color _getColor(double intensity, bool isDark) {
    if (intensity == 0) {
      return isDark ? Colors.grey.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.05);
    }
    if (intensity < 0.33) {
      return Color.lerp(
        (isDark ? NeonColors.cyanDark : NeonColors.cyanLight).withValues(alpha: 0.2),
        (isDark ? NeonColors.cyanDark : NeonColors.cyanLight).withValues(alpha: 0.6),
        intensity * 3,
      )!;
    } else if (intensity < 0.66) {
      return Color.lerp(
        (isDark ? NeonColors.magentaDark : NeonColors.magentaLight).withValues(alpha: 0.6),
        (isDark ? NeonColors.magentaDark : NeonColors.magentaLight).withValues(alpha: 0.9),
        (intensity - 0.33) * 3,
      )!;
    } else {
      return Color.lerp(
        (isDark ? NeonColors.purpleDark : NeonColors.purpleLight).withValues(alpha: 0.9),
        isDark ? NeonColors.purpleDark : NeonColors.purpleLight,
        (intensity - 0.66) * 3,
      )!;
    }
  }
}