// Neon Donut Chart for Tecnologías (Distributions)
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/data/models/dashboard_tecnologias.dart';
import 'package:mobile/core/utils/responsive.dart';

/// Donut chart for technology distributions
class NeonDonutChart extends StatefulWidget {
  final List<TechItem> data;
  final String title;
  final Color glowColor;
  final int maxItems;
  final double size;
  final bool showLegend;
  final ValueChanged<TechItem?>? onSectionTap;

  const NeonDonutChart({
    super.key,
    required this.data,
    required this.title,
    required this.glowColor,
    this.maxItems = 5,
    this.size = 200,
    this.showLegend = true,
    this.onSectionTap,
  });

  @override
  State<NeonDonutChart> createState() => _NeonDonutChartState();
}

class _NeonDonutChartState extends State<NeonDonutChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    // Process data: take top N, group rest as "Otros"
    final processedData = _processData(widget.data, widget.maxItems);

    if (processedData.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        if (widget.title.isNotEmpty) ...[
          Text(
            widget.title,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
        ],
        // Chart
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    enabled: true,
                    touchCallback: (event, response) {
                      setState(() {
                        if (response != null && response.touchedSection != null) {
                          _touchedIndex = response.touchedSection!.touchedSectionIndex;
                        } else {
                          _touchedIndex = -1;
                        }
                      });
                      if (widget.onSectionTap != null) {
                        final index = _touchedIndex;
                        widget.onSectionTap!(index >= 0 && index < processedData.length
                            ? processedData[index]
                            : null);
                      }
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: widget.size * 0.45,
                  sections: _buildSections(processedData, isDark),
                  startDegreeOffset: -90,
                ),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
              ),
              // Center label
              _buildCenterLabel(processedData, isDark, colorScheme),
            ],
          ),
        ),
        // Legend
        if (widget.showLegend && processedData.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildLegend(processedData, isDark, colorScheme),
        ],
      ],
    );
  }

  List<TechItem> _processData(List<TechItem> data, int maxItems) {
    if (data.isEmpty) return [];
    if (data.length <= maxItems) return data;

    final sorted = List<TechItem>.from(data)
      ..sort((a, b) => b.total.compareTo(a.total));

    final topItems = sorted.take(maxItems - 1).toList();
    final othersCount = sorted.skip(maxItems - 1).fold(0, (sum, item) => sum + item.total);
    final othersPercentage = sorted.skip(maxItems - 1).fold(0.0, (sum, item) => sum + item.porcentaje);

    if (othersCount > 0) {
      topItems.add(TechItem(
        id: -1,
        nombre: 'Otros',
        nombreCode: 'otros',
        icono: '',
        iconoTipo: 'none',
        total: othersCount,
        porcentaje: othersPercentage,
      ));
    }

    return topItems;
  }

  List<PieChartSectionData> _buildSections(List<TechItem> data, bool isDark) {
    final colors = _getChartColors(isDark);

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isTouched = index == _touchedIndex;
      final color = colors[index % colors.length];

      return PieChartSectionData(
        color: color,
        value: item.porcentaje,
        title: '',
        radius: widget.size * 0.5 * (isTouched ? 1.08 : 1.0),
        badgeWidget: isTouched
            ? _buildBadge(item, color, isDark)
            : null,
        badgePositionPercentageOffset: 1.15,
        showTitle: false,
      );
    }).toList();
  }

  List<Color> _getChartColors(bool isDark) {
    // Neon color palette for distributions
    if (isDark) {
      return [
        NeonColors.cyanDark,
        NeonColors.magentaDark,
        NeonColors.purpleDark,
        NeonColors.greenDark,
        NeonColors.blueDark,
        NeonColors.orangeDark,
        NeonColors.pinkDark,
        NeonColors.yellowDark,
        NeonColors.getNeon('red', isDark),
        NeonColors.getNeon('teal', isDark),
      ];
    } else {
      return [
        NeonColors.cyanLight,
        NeonColors.magentaLight,
        NeonColors.purpleLight,
        NeonColors.greenLight,
        NeonColors.blueLight,
        NeonColors.orangeLight,
        NeonColors.pinkLight,
        NeonColors.yellowLight,
        NeonColors.getNeon('red', isDark),
        NeonColors.getNeon('teal', isDark),
      ];
    }
  }

  Widget _buildBadge(TechItem item, Color color, bool isDark) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 200),
      scale: 1.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.nombre,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            Text(
              '${item.porcentaje.toStringAsFixed(1)}%',
              style: GoogleFonts.inter(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              '${item.total} gen',
              style: GoogleFonts.inter(
                fontSize: 9,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterLabel(List<TechItem> data, bool isDark, ColorScheme colorScheme) {
    final total = data.fold(0, (sum, item) => sum + item.total);
    final selected = _touchedIndex >= 0 && _touchedIndex < data.length ? data[_touchedIndex] : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selected != null) ...[
          Text(
            selected.nombre,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${selected.porcentaje.toStringAsFixed(1)}%',
            style: GoogleFonts.orbitron(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: widget.glowColor,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            '${selected.total} de $total',
            style: GoogleFonts.inter(
              fontSize: 10,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ] else ...[
          Text(
            'Total',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          Text(
            '$total',
            style: GoogleFonts.orbitron(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            'generaciones',
            style: GoogleFonts.inter(
              fontSize: 10,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLegend(List<TechItem> data, bool isDark, ColorScheme colorScheme) {
    final colors = _getChartColors(isDark);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final color = colors[index % colors.length];
        final isSelected = index == _touchedIndex;

        return InkWell(
          onTap: () => setState(() => _touchedIndex = _touchedIndex == index ? -1 : index),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: isDark ? 0.2 : 0.1)
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? color.withValues(alpha: 0.5)
                    : colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  item.nombre,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? color : colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${item.porcentaje.toStringAsFixed(1)}%',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_rounded,
              size: 48,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'Sin datos',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grid of donut charts for all technology categories
class NeonDonutGrid extends StatelessWidget {
  final DashboardTecnologias data;
  final int crossAxisCount;
  final double chartSize;

  const NeonDonutGrid({
    super.key,
    required this.data,
    this.crossAxisCount = 2,
    this.chartSize = 180,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = [
      ('Lenguajes', data.lenguajes, NeonColors.cyanDark),
      ('Frameworks', data.frameworks, NeonColors.magentaDark),
      ('Arquitecturas', data.arquitecturas, NeonColors.purpleDark),
      ('ORMs', data.orms, NeonColors.blueDark),
      ('Bases de Datos', data.basesDatos, NeonColors.greenDark),
      ('Artefactos', data.tiposArtefacto, NeonColors.orangeDark),
    ];

    // Use Responsive utilities instead of LayoutBuilder to avoid infinite constraints
    final responsiveCrossAxisCount = Responsive.gridColumns(context, maxColumns: 4);
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveChartSize = _calculateChartSize(screenWidth, responsiveCrossAxisCount);

    // Calculate grid height to avoid infinite constraints when used inside ListView
    const spacing = 12.0;
    const horizontalPadding = 32.0;
    final availableWidth = screenWidth - horizontalPadding;
    final totalSpacing = spacing * (responsiveCrossAxisCount - 1);
    final availablePerItem = (availableWidth - totalSpacing) / responsiveCrossAxisCount;
    // Each cell has title (~20) + chart (responsiveChartSize) + small padding
    final cellHeight = responsiveChartSize + 28.0;
    final rows = (categories.length / responsiveCrossAxisCount).ceil();
    final gridHeight = cellHeight * rows + spacing * (rows - 1);

    return SizedBox(
      height: gridHeight,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: responsiveCrossAxisCount,
          childAspectRatio: 1.0,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final (title, items, glowColor) = categories[index];
          final color = isDark ? glowColor : _getLightVariant(glowColor);

          return NeonDonutChart(
            data: items,
            title: title,
            glowColor: color,
            maxItems: 5,
            size: responsiveChartSize,
            showLegend: false,
          );
        },
      ),
    );
  }

  double _calculateChartSize(double screenWidth, int crossAxisCount) {
    // Account for padding and spacing
    const horizontalPadding = 32.0; // Responsive.padding horizontal
    const spacing = 12.0;
    final availableWidth = screenWidth - horizontalPadding;
    final totalSpacing = spacing * (crossAxisCount - 1);
    final availablePerItem = (availableWidth - totalSpacing) / crossAxisCount;
    // Return size that fits within the grid cell, with some margin
    return (availablePerItem * 0.9).clamp(120.0, 200.0);
  }

  Color _getLightVariant(Color darkColor) {
    // Map dark neon colors to light variants
    if (darkColor == NeonColors.cyanDark) return NeonColors.cyanLight;
    if (darkColor == NeonColors.magentaDark) return NeonColors.magentaLight;
    if (darkColor == NeonColors.purpleDark) return NeonColors.purpleLight;
    if (darkColor == NeonColors.blueDark) return NeonColors.blueLight;
    if (darkColor == NeonColors.greenDark) return NeonColors.greenLight;
    if (darkColor == NeonColors.orangeDark) return NeonColors.orangeLight;
    if (darkColor == NeonColors.pinkDark) return NeonColors.pinkLight;
    if (darkColor == NeonColors.yellowDark) return NeonColors.yellowLight;
    return NeonColors.cyanLight;
  }
}

/// Compact donut chart for cards/lists
class NeonMiniDonutChart extends StatelessWidget {
  final List<TechItem> data;
  final Color color;
  final double size;
  final int maxItems;

  const NeonMiniDonutChart({
    super.key,
    required this.data,
    required this.color,
    this.size = 80,
    this.maxItems = 4,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final processedData = _processData(data);

    if (processedData.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Icon(
            Icons.pie_chart_rounded,
            size: size * 0.4,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(enabled: false),
              borderData: FlBorderData(show: false),
              sectionsSpace: 1,
              centerSpaceRadius: size * 0.5,
              sections: _buildSections(processedData, isDark),
              startDegreeOffset: -90,
            ),
          ),
          // Center total
          Text(
            '${data.fold(0, (sum, item) => sum + item.total)}',
            style: GoogleFonts.orbitron(
              fontSize: size * 0.15,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  List<TechItem> _processData(List<TechItem> data) {
    if (data.isEmpty) return [];
    if (data.length <= maxItems) return data;

    final sorted = List<TechItem>.from(data)
      ..sort((a, b) => b.total.compareTo(a.total));

    final topItems = sorted.take(maxItems - 1).toList();
    final othersCount = sorted.skip(maxItems - 1).fold(0, (sum, item) => sum + item.total);

    if (othersCount > 0) {
      topItems.add(TechItem(
        id: -1,
        nombre: 'Otros',
        nombreCode: 'otros',
        icono: '',
        iconoTipo: 'none',
        total: othersCount,
        porcentaje: 0,
      ));
    }

    return topItems;
  }

  List<PieChartSectionData> _buildSections(List<TechItem> data, bool isDark) {
    final colors = _getMiniColors(isDark);

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final color = colors[index % colors.length];

      return PieChartSectionData(
        color: color,
        value: item.porcentaje > 0 ? item.porcentaje : (item.total / data.fold(0, (s, i) => s + i.total) * 100),
        title: '',
        radius: size * 0.5,
        showTitle: false,
      );
    }).toList();
  }

  List<Color> _getMiniColors(bool isDark) {
    if (isDark) {
      return [
        NeonColors.cyanDark,
        NeonColors.magentaDark,
        NeonColors.purpleDark,
        NeonColors.greenDark,
        NeonColors.blueDark,
        NeonColors.orangeDark,
      ];
    } else {
      return [
        NeonColors.cyanLight,
        NeonColors.magentaLight,
        NeonColors.purpleLight,
        NeonColors.greenLight,
        NeonColors.blueLight,
        NeonColors.orangeLight,
      ];
    }
  }
}