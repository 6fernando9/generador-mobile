// Neon Donut Chart for Tecnologías (Distributions)
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/data/models/dashboard_tecnologias.dart';
import 'package:mobile/core/utils/responsive.dart';
import 'package:mobile/presentation/shared/widgets/neon_card.dart'
    show GlowCard;

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
    final fontScale = Responsive.fontScale(context);

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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14 * fontScale,
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
                        if (response != null &&
                            response.touchedSection != null) {
                          _touchedIndex =
                              response.touchedSection!.touchedSectionIndex;
                        } else {
                          _touchedIndex = -1;
                        }
                      });
                      if (widget.onSectionTap != null) {
                        final index = _touchedIndex;
                        widget.onSectionTap!(
                          index >= 0 && index < processedData.length
                              ? processedData[index]
                              : null,
                        );
                      }
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  // ~19% of the chart size as ring thickness so the donut
                  // stays readable at small sizes (was 5%, nearly invisible).
                  centerSpaceRadius: widget.size * 0.31,
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
    final othersCount = sorted
        .skip(maxItems - 1)
        .fold(0, (sum, item) => sum + item.total);
    final othersPercentage = sorted
        .skip(maxItems - 1)
        .fold(0.0, (sum, item) => sum + item.porcentaje);

    if (othersCount > 0) {
      topItems.add(
        TechItem(
          id: -1,
          nombre: 'Otros',
          nombreCode: 'otros',
          icono: '',
          iconoTipo: 'none',
          total: othersCount,
          porcentaje: othersPercentage,
        ),
      );
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
        // In fl_chart 1.x, section.radius is the ring THICKNESS added on top
        // of centerSpaceRadius, not the outer radius. 0.31 + 0.19 = 0.5 so
        // the donut exactly fills its SizedBox.
        radius: widget.size * 0.19 * (isTouched ? 1.08 : 1.0),
        badgeWidget: isTouched ? _buildBadge(item, color, isDark) : null,
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
                color: Theme.of(context).colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
            Text(
              '${item.total} gen',
              style: GoogleFonts.inter(
                fontSize: 9,
                color: Theme.of(context).colorScheme.onSurface
                    .withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterLabel(
    List<TechItem> data,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    final total = data.fold(0, (sum, item) => sum + item.total);
    final selected = _touchedIndex >= 0 && _touchedIndex < data.length
        ? data[_touchedIndex]
        : null;
    final fontScale = Responsive.fontScale(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selected != null) ...[
          Text(
            selected.nombre,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14 * fontScale,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${selected.porcentaje.toStringAsFixed(1)}%',
            style: GoogleFonts.orbitron(
              fontSize: 18 * fontScale,
              fontWeight: FontWeight.w700,
              color: widget.glowColor,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            '${selected.total} de $total',
            style: GoogleFonts.inter(
              fontSize: 10 * fontScale,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ] else ...[
          Text(
            'Total',
            style: GoogleFonts.inter(
              fontSize: 11 * fontScale,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          Text(
            '$total',
            style: GoogleFonts.orbitron(
              fontSize: 24 * fontScale,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            'generaciones',
            style: GoogleFonts.inter(
              fontSize: 10 * fontScale,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLegend(
    List<TechItem> data,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    final colors = _getChartColors(isDark);
    final fontScale = Responsive.fontScale(context);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8 * fontScale,
      runSpacing: 6 * fontScale,
      children: data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final color = colors[index % colors.length];
        final isSelected = index == _touchedIndex;

        return InkWell(
          onTap: () => setState(
            () => _touchedIndex = _touchedIndex == index ? -1 : index,
          ),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: 10 * fontScale,
              vertical: 6 * fontScale,
            ),
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
                SizedBox(width: 6 * fontScale),
                Text(
                  item.nombre,
                  style: GoogleFonts.inter(
                    fontSize: 11 * fontScale,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? color
                        : colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(width: 4 * fontScale),
                Text(
                  '${item.porcentaje.toStringAsFixed(1)}%',
                  style: GoogleFonts.inter(
                    fontSize: 11 * fontScale,
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

/// Shared layout metrics for [NeonDonutGrid] and its loading skeleton.
///
/// The dashboard skeleton must mirror the grid exactly, so the sizing math
/// lives here instead of being duplicated in both places.
class DonutGridMetrics {
  /// Spacing between grid cells.
  static const double spacing = 12.0;

  /// Inner padding of each chart card (see NeonDonutGrid._buildChartCard).
  static const double cardPadding = 16.0;

  /// Base height of the single-line card title (fontSize 14 * line height),
  /// with slack for taller fonts. Scaled by the responsive font scale.
  static const double titleHeight = 22.0;

  /// Combined top+bottom thickness of the card border (1px per side).
  static const double cardBorder = 2.0;

  /// Gap between the title and the chart inside the card.
  static const double titleGap = 12.0;

  /// Estimated height of one row of legend chips including the wrap spacing
  /// (~30px chip + 6px run spacing). Worst case: every chip on its own row.
  static const double legendRowHeight = 38.0;

  /// Gap between the chart and the legend inside NeonDonutChart.
  static const double legendGap = 16.0;

  /// Number of legend chips NeonDonutChart renders with maxItems: 5.
  static const int legendChipCount = 5;

  final int crossAxisCount;
  final double cellWidth;
  final double chartSize;
  final double cellHeight;
  final double aspectRatio;
  final bool showLegend;

  const DonutGridMetrics({
    required this.crossAxisCount,
    required this.cellWidth,
    required this.chartSize,
    required this.cellHeight,
    required this.aspectRatio,
    required this.showLegend,
  });

  /// [availableWidth] must already exclude the outer ListView padding
  /// (16px on each side in the dashboard). [fontScale] should be
  /// `Responsive.fontScale(context)` so titles keep their real height.
  factory DonutGridMetrics.compute(
    double availableWidth, {
    bool showLegend = false,
    double? maxChartSize,
    int? crossAxisCount,
    double fontScale = 1.0,
  }) {
    final columns =
        crossAxisCount ?? (availableWidth >= AppBreakpoints.tablet - 32 ? 3 : 2);
    final chartMax = maxChartSize ?? (columns >= 3 ? 180.0 : 130.0);
    final cellWidth = (availableWidth - spacing * (columns - 1)) / columns;

    // Reserve the card padding on both sides before sizing the chart so the
    // donut never overflows its card.
    final chartSize = ((cellWidth - cardPadding * 2) * 0.95).clamp(72.0, chartMax);

    // Worst-case legend height: gap + every chip on its own row. Cards
    // therefore never overflow even when long labels force a single chip
    // per row.
    final legendHeight = showLegend
        ? legendGap + legendChipCount * legendRowHeight
        : 0.0;

    final cellHeight = cardPadding * 2 +
        cardBorder +
        titleHeight * fontScale +
        titleGap +
        chartSize +
        legendHeight;

    return DonutGridMetrics(
      crossAxisCount: columns,
      cellWidth: cellWidth,
      chartSize: chartSize,
      cellHeight: cellHeight,
      aspectRatio: cellWidth / cellHeight,
      showLegend: showLegend,
    );
  }

  /// Total height of a grid holding [itemCount] cells.
  double gridHeight(int itemCount) {
    final rows = (itemCount / crossAxisCount).ceil();
    return cellHeight * rows + spacing * (rows - 1);
  }
}

/// Grid of donut charts for all technology categories with responsive layout
/// strategies: 2 compact columns on mobile/tablet, 3 columns with legends on
/// desktop/large desktop.
class NeonDonutGrid extends StatelessWidget {
  final DashboardTecnologias data;

  /// Overrides the number of columns (null = derive from available width).
  final int? crossAxisCount;

  /// Upper bound for the chart size in pixels (null = 130 on mobile/tablet,
  /// 180 on desktop).
  final double? maxChartSize;

  const NeonDonutGrid({
    super.key,
    required this.data,
    this.crossAxisCount,
    this.maxChartSize,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = _getCategories(isDark);
    final deviceType = Responsive.deviceType(context);
    final showLegend = deviceType == DeviceType.desktop ||
        deviceType == DeviceType.largeDesktop;

    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = DonutGridMetrics.compute(
          constraints.maxWidth,
          showLegend: showLegend,
          maxChartSize: maxChartSize,
          crossAxisCount: crossAxisCount,
          fontScale: Responsive.fontScale(context),
        );

        return SizedBox(
          height: metrics.gridHeight(categories.length),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: metrics.crossAxisCount,
              childAspectRatio: metrics.aspectRatio,
              crossAxisSpacing: DonutGridMetrics.spacing,
              mainAxisSpacing: DonutGridMetrics.spacing,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final (title, items, glowColor) = categories[index];
              final color = isDark ? glowColor : _getLightVariant(glowColor);

              return _buildChartCard(
                context: context,
                title: title,
                data: items,
                glowColor: color,
                chartSize: metrics.chartSize,
                showLegend: metrics.showLegend,
                index: index,
              );
            },
          ),
        );
      },
    );
  }

  /// Shared chart card wrapper with consistent styling
  Widget _buildChartCard({
    required BuildContext context,
    required String title,
    required List<TechItem> data,
    required Color glowColor,
    required double chartSize,
    required bool showLegend,
    required int index,
  }) {
    return Animate(
      effects: [
        FadeEffect(
          duration: 400.ms,
          delay: Duration(milliseconds: 100 * index),
        ),
        SlideEffect(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
          duration: 400.ms,
          delay: Duration(milliseconds: 100 * index),
          curve: Curves.easeOutCubic,
        ),
      ],
      child: GlowCard(
        glowColor: glowColor.withValues(alpha: 0.15),
        padding: EdgeInsets.zero,
        // The grid already provides spacing between cells; GlowCard's default
        // margin (16h/8v) would shrink the cell content and break the sizing
        // math of DonutGridMetrics.
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: NeonDonutChart(
            data: data,
            title: title,
            glowColor: glowColor,
            maxItems: 5,
            size: chartSize,
            showLegend: showLegend,
          ),
        ),
      ),
    );
  }

  List<(String, List<TechItem>, Color)> _getCategories(bool isDark) {
    return [
      ('Lenguajes', data.lenguajes, NeonColors.cyanDark),
      ('Frameworks', data.frameworks, NeonColors.magentaDark),
      ('Arquitecturas', data.arquitecturas, NeonColors.purpleDark),
      ('ORMs', data.orms, NeonColors.blueDark),
      ('Bases de Datos', data.basesDatos, NeonColors.greenDark),
      ('Artefactos', data.tiposArtefacto, NeonColors.orangeDark),
    ];
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
            color: Theme.of(context).colorScheme.onSurface
                .withValues(alpha: 0.2),
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
              // section.radius is the ring thickness on top of the center
              // hole (fl_chart 1.x): 0.31 + 0.19 = 0.5 fills the box exactly.
              centerSpaceRadius: size * 0.31,
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
    final othersCount = sorted
        .skip(maxItems - 1)
        .fold(0, (sum, item) => sum + item.total);

    if (othersCount > 0) {
      topItems.add(
        TechItem(
          id: -1,
          nombre: 'Otros',
          nombreCode: 'otros',
          icono: '',
          iconoTipo: 'none',
          total: othersCount,
          porcentaje: 0,
        ),
      );
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
        value: item.porcentaje > 0
            ? item.porcentaje
            : (item.total / data.fold(0, (s, i) => s + i.total) * 100),
        title: '',
        radius: size * 0.19,
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
