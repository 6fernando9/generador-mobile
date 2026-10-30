// Neon Line Chart for Tendencia (Time Series with Artifact Breakdown)
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/data/models/dashboard_tendencia.dart';
import 'package:mobile/presentation/shared/widgets/neon_card.dart'
    show NeonBadge, NeonBadgeStyle;

/// Main chart for Tendencia tab - shows time series with stacked artifact types
class NeonLineChart extends StatefulWidget {
  final DashboardTendencia data;
  final bool showArtifactBreakdown;

  /// Fixed chart height. When null, the height is computed responsively from
  /// the available width (see [responsiveHeight]).
  final double? height;

  const NeonLineChart({
    super.key,
    required this.data,
    this.showArtifactBreakdown = true,
    this.height,
  });

  /// Horizontal padding used by the dashboard ListView (EdgeInsets.all(16)).
  static const double _horizontalPadding = 32.0;

  /// Responsive chart height derived from the screen width. Shared with the
  /// dashboard skeleton so both stay in sync.
  static double responsiveHeight(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final availableWidth = (screenWidth - _horizontalPadding).clamp(
      0.0,
      double.infinity,
    );
    return (availableWidth * 0.55).clamp(220.0, 320.0);
  }

  @override
  State<NeonLineChart> createState() => _NeonLineChartState();
}

class _NeonLineChartState extends State<NeonLineChart> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final data = widget.data;

    if (data.serie.isEmpty) {
      return _buildEmptyState(context);
    }

    // Prepare line data for each series
    final totalSpots = _buildTotalSpots(data.serie);
    final backendSpots = _buildBackendSpots(data.serie);
    final frontendSpots = _buildFrontendSpots(data.serie);
    final mobileSpots = _buildMobileSpots(data.serie);

    final chartHeight =
        widget.height ?? NeonLineChart.responsiveHeight(context);
    final isNarrow = MediaQuery.sizeOf(context).width < 600;

    return Container(
      height: chartHeight,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Chart area
          Expanded(
            child: Stack(
              children: [
                LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: (data.serie.length - 1).toDouble().clamp(1, double.infinity),
                    minY: _calculateMinY(data.serie),
                    maxY: _calculateMaxY(data.serie),
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          // Return tooltip item for EACH touchedSpot to match size
                          // Only show content for primary line (barIndex == 0)
                          return touchedSpots.map((spot) {
                            if (spot.barIndex != 0) {
                              // Return empty tooltip for non-primary lines
                              return LineTooltipItem('', TextStyle(fontSize: 0));
                            }
                            return _buildTooltipItems([spot], data, isDark, context).first;
                          }).toList();
                        },
                        tooltipBorderRadius: BorderRadius.circular(12),
                        tooltipPadding: const EdgeInsets.all(12),
                      ),
                      handleBuiltInTouches: true,
                      touchCallback: (event, response) {
                        if (response != null && response.lineBarSpots != null) {
                          // Only track selection on primary line
                          final primarySpots = response.lineBarSpots!.where((s) => s.barIndex == 0).toList();
                          if (primarySpots.isNotEmpty) {
                            setState(() {
                              _selectedIndex = primarySpots.first.spotIndex.toInt();
                            });
                          }
                        } else {
                          setState(() {
                            _selectedIndex = null;
                          });
                        }
                      },
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _calculateYInterval(data.serie),
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.1),
                        strokeWidth: 1,
                        dashArray: [4, 4],
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          interval: _calculateXInterval(data.serie.length),
                          getTitlesWidget: (value, meta) => _buildBottomTitle(value, meta, data, context),
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 48,
                          interval: _calculateYInterval(data.serie),
                          getTitlesWidget: (value, meta) => _buildLeftTitle(value, meta, colorScheme),
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      // Total line (primary)
                      LineChartBarData(
                        spots: totalSpots,
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: NeonColors.getNeon('cyan', isDark),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            final isSelected = _selectedIndex == index;
                            return FlDotCirclePainter(
                              radius: isSelected ? 6 : 4,
                              color: NeonColors.getNeon('cyan', isDark),
                              strokeWidth: isSelected ? 3 : 0,
                              strokeColor: isDark ? Colors.black : Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              NeonColors.getNeon('cyan', isDark).withValues(alpha: 0.25),
                              NeonColors.getNeon('cyan', isDark).withValues(alpha: 0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      // Artifact breakdown lines (if enabled)
                      if (widget.showArtifactBreakdown) ...[
                        LineChartBarData(
                          spots: backendSpots,
                          isCurved: true,
                          curveSmoothness: 0.35,
                          color: NeonColors.getNeon('magenta', isDark).withValues(alpha: 0.7),
                          barWidth: 1.5,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                        LineChartBarData(
                          spots: frontendSpots,
                          isCurved: true,
                          curveSmoothness: 0.35,
                          color: NeonColors.getNeon('purple', isDark).withValues(alpha: 0.7),
                          barWidth: 1.5,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                        LineChartBarData(
                          spots: mobileSpots,
                          isCurved: true,
                          curveSmoothness: 0.35,
                          color: NeonColors.getNeon('green', isDark).withValues(alpha: 0.7),
                          barWidth: 1.5,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ],
                  ),
                ),
                // Legend (floating only on wide screens; narrow screens get
                // a wrap below the chart to avoid overlapping the line)
                if (widget.showArtifactBreakdown && !isNarrow)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _buildLegend(isDark, colorScheme),
                  ),
              ],
            ),
          ),
          // Legend below chart on narrow screens
          if (widget.showArtifactBreakdown && isNarrow) ...[
            const SizedBox(height: 8),
            _buildLegendWrap(isDark, colorScheme),
          ],
          // Selected point details
          if (_selectedIndex != null && _selectedIndex! < data.serie.length)
            _buildSelectedPointDetails(data, _selectedIndex!, isDark, colorScheme, context),
        ],
      ),
    );
  }

  List<FlSpot> _buildTotalSpots(List<TimeSeriesPoint> serie) {
    return serie.asMap().entries.map((e) {
      final value = e.value.total;
      return FlSpot(e.key.toDouble(), (value ?? 0).toDouble());
    }).toList();
  }

  List<FlSpot> _buildBackendSpots(List<TimeSeriesPoint> serie) {
    return serie.asMap().entries.map((e) {
      final value = e.value.backend;
      return FlSpot(e.key.toDouble(), (value ?? 0).toDouble());
    }).toList();
  }

  List<FlSpot> _buildFrontendSpots(List<TimeSeriesPoint> serie) {
    return serie.asMap().entries.map((e) {
      final value = e.value.frontend;
      return FlSpot(e.key.toDouble(), (value ?? 0).toDouble());
    }).toList();
  }

  List<FlSpot> _buildMobileSpots(List<TimeSeriesPoint> serie) {
    return serie.asMap().entries.map((e) {
      final value = e.value.mobile;
      return FlSpot(e.key.toDouble(), (value ?? 0).toDouble());
    }).toList();
  }

  double _calculateMinY(List<TimeSeriesPoint> serie) {
    if (serie.isEmpty) return 0;
    final min = serie.map((e) => e.total ?? 0).reduce((a, b) => a < b ? a : b);
    return (min * 0.9).floorToDouble();
  }

  double _calculateMaxY(List<TimeSeriesPoint> serie) {
    if (serie.isEmpty) return 10;
    final max = serie.map((e) => e.total ?? 0).reduce((a, b) => a > b ? a : b);
    return (max * 1.15).ceilToDouble();
  }

  double _calculateXInterval(int length) {
    if (length <= 7) return 1;
    if (length <= 14) return 2;
    if (length <= 30) return 5;
    return (length / 6).ceilToDouble();
  }

  double _calculateYInterval(List<TimeSeriesPoint> serie) {
    if (serie.isEmpty) return 5;
    final max = serie.map((e) => e.total ?? 0).reduce((a, b) => a > b ? a : b);
    final min = serie.map((e) => e.total ?? 0).reduce((a, b) => a < b ? a : b);
    final range = max - min;
    if (range <= 10) return 1;
    if (range <= 50) return 5;
    if (range <= 100) return 10;
    if (range <= 500) return 50;
    return 100;
  }

  Widget _buildBottomTitle(double value, TitleMeta meta, DashboardTendencia data, BuildContext context) {
    final index = value.toInt();
    if (index < 0 || index >= data.serie.length) return const SizedBox.shrink();

    final point = data.serie[index];
    final date = DateTime.tryParse(point.periodo) ?? DateTime.now();
    final colorScheme = Theme.of(context).colorScheme;

    // Show label every N points based on data length
    final interval = _calculateXInterval(data.serie.length).toInt();
    if (index % interval != 0 && index != data.serie.length - 1) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        _formatDate(date),
        style: GoogleFonts.inter(
          fontSize: 10,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildLeftTitle(double value, TitleMeta meta, ColorScheme colorScheme) {
    if (value == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        value.toInt().toString(),
        style: GoogleFonts.inter(
          fontSize: 10,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    if (diff == 0) return 'Hoy';
    if (diff == 1) return 'Ayer';
    if (diff < 7) {
      const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
      return days[date.weekday - 1];
    }
    return '${date.day}/${date.month}';
  }

  List<LineTooltipItem> _buildTooltipItems(
    List<LineBarSpot> touchedSpots,
    DashboardTendencia data,
    bool isDark,
    BuildContext context,
  ) {
    final items = <LineTooltipItem>[];
    final index = touchedSpots.first.spotIndex.toInt();

    if (index >= data.serie.length) return items;

    final point = data.serie[index];
    final date = DateTime.tryParse(point.periodo) ?? DateTime.now();

    // Total
    items.add(LineTooltipItem(
      'Total: ${point.total}\n',
      GoogleFonts.spaceGrotesk(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: NeonColors.getNeon('cyan', isDark),
      ),
    ));

    // Artifact breakdown
    if (point.backend > 0) {
      items.add(LineTooltipItem(
        'Backend: ${point.backend}\n',
        GoogleFonts.inter(
          fontSize: 11,
          color: NeonColors.getNeon('magenta', isDark),
        ),
      ));
    }
    if (point.frontend > 0) {
      items.add(LineTooltipItem(
        'Frontend: ${point.frontend}\n',
        GoogleFonts.inter(
          fontSize: 11,
          color: NeonColors.getNeon('purple', isDark),
        ),
      ));
    }
    if (point.mobile > 0) {
      items.add(LineTooltipItem(
        'Mobile: ${point.mobile}\n',
        GoogleFonts.inter(
          fontSize: 11,
          color: NeonColors.getNeon('green', isDark),
        ),
      ));
    }

    // Date
    items.add(LineTooltipItem(
      _formatDateFull(date),
      GoogleFonts.inter(
        fontSize: 10,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    ));

    return items;
  }

  String _formatDateFull(DateTime date) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildLegend(bool isDark, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLegendItem('Total', NeonColors.getNeon('cyan', isDark), colorScheme),
          _buildLegendItem('Backend', NeonColors.getNeon('magenta', isDark), colorScheme),
          _buildLegendItem('Frontend', NeonColors.getNeon('purple', isDark), colorScheme),
          _buildLegendItem('Mobile', NeonColors.getNeon('green', isDark), colorScheme),
        ],
      ),
    );
  }

  /// Compact horizontal legend used on narrow screens (below the chart).
  Widget _buildLegendWrap(bool isDark, ColorScheme colorScheme) {
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: [
        _buildLegendItem('Total', NeonColors.getNeon('cyan', isDark), colorScheme),
        _buildLegendItem('Backend', NeonColors.getNeon('magenta', isDark), colorScheme),
        _buildLegendItem('Frontend', NeonColors.getNeon('purple', isDark), colorScheme),
        _buildLegendItem('Mobile', NeonColors.getNeon('green', isDark), colorScheme),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPointDetails(
    DashboardTendencia data,
    int index,
    bool isDark,
    ColorScheme colorScheme,
    BuildContext context,
  ) {
    final point = data.serie[index];
    final date = DateTime.tryParse(point.periodo) ?? DateTime.now();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDateFull(date),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total generaciones: ${point.total}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          // Artifact breakdown for selected point
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              if (point.backend > 0)
                NeonBadge(
                  label: 'Backend: ${point.backend}',
                  icon: Icons.circle_rounded,
                  color: NeonColors.getNeon('magenta', isDark),
                  style: NeonBadgeStyle.soft,
                  glowColor: NeonColors.getNeon('magenta', isDark).withValues(alpha: 0.3),
                ),
              if (point.frontend > 0)
                NeonBadge(
                  label: 'Frontend: ${point.frontend}',
                  icon: Icons.circle_rounded,
                  color: NeonColors.getNeon('purple', isDark),
                  style: NeonBadgeStyle.soft,
                  glowColor: NeonColors.getNeon('purple', isDark).withValues(alpha: 0.3),
                ),
              if (point.mobile > 0)
                NeonBadge(
                  label: 'Mobile: ${point.mobile}',
                  icon: Icons.circle_rounded,
                  color: NeonColors.getNeon('green', isDark),
                  style: NeonBadgeStyle.soft,
                  glowColor: NeonColors.getNeon('green', isDark).withValues(alpha: 0.3),
                ),
            ],
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
            Icons.show_chart_rounded,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin datos de tendencia',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Genera algunos proyectos para ver la tendencia',
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

/// Simplified version for smaller spaces (e.g., in a card)
class NeonMiniLineChart extends StatelessWidget {
  final List<double> data;
  final Color color;
  final double height;
  final double strokeWidth;

  const NeonMiniLineChart({
    super.key,
    required this.data,
    required this.color,
    this.height = 80,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return SizedBox(height: height);

    final spots = data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();
    final minY = data.reduce((a, b) => a < b ? a : b);
    final maxY = data.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: minY - (maxY - minY) * 0.1,
          maxY: maxY + (maxY - minY) * 0.1,
          lineTouchData: LineTouchData(enabled: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.35,
              color: color,
              barWidth: strokeWidth,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.3),
                    color.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}