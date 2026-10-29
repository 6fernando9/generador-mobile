// Chart widgets for Dashboard
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobile/core/theme/neon_colors.dart';

/// Mini sparkline chart for KPI cards
class NeonSparkline extends StatelessWidget {
  final List<double> data;
  final Color color;
  final bool showArea;
  final double strokeWidth;
  final double height;

  const NeonSparkline({
    super.key,
    required this.data,
    required this.color,
    this.showArea = true,
    this.strokeWidth = 2,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(height: height, child: const Center(child: Text('—')));
    }

    final spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();

    final minY = data.reduce((a, b) => a < b ? a : b);
    final maxY = data.reduce((a, b) => a > b ? a : b);
    final minX = 0.0;
    final maxX = (data.length - 1).toDouble();

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: minY - (maxY - minY) * 0.1,
          maxY: maxY + (maxY - minY) * 0.1,
          lineTouchData: LineTouchData(
            enabled: false,
          ),
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
              belowBarData: showArea
                  ? BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.3),
                          color.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    )
                  : BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

/// Responsive sparkline that adapts to container
class ResponsiveSparkline extends StatelessWidget {
  final List<double> data;
  final Color color;
  final bool showArea;

  const ResponsiveSparkline({
    super.key,
    required this.data,
    required this.color,
    this.showArea = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return NeonSparkline(
          data: data,
          color: color,
          showArea: showArea,
          strokeWidth: constraints.maxWidth > 200 ? 2.5 : 2,
          height: constraints.maxHeight,
        );
      },
    );
  }
}

/// Generate mock sparkline data for testing
List<double> generateMockSparklineData(int points, {double base = 50, double variance = 30}) {
  final random = DateTime.now().millisecondsSinceEpoch;
  return List.generate(points, (i) {
    // Deterministic pseudo-random based on index
    final seed = (random + i * 17) % 1000;
    return base + (seed / 1000) * variance * 2 - variance;
  });
}