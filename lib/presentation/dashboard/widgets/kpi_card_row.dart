// KPI Card Row for Dashboard Overview
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/presentation/dashboard/dashboard_providers.dart';
import 'package:mobile/presentation/shared/widgets/neon_card.dart';
import 'package:mobile/presentation/shared/widgets/skeleton_base.dart'
    show SkeletonBase, SkeletonText;
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/data/models/dashboard_resumen.dart';

/// Row of 4 KPI cards: hoy, semana, mes y total histórico.
class KpiCardRow extends ConsumerWidget {
  final DashboardResumen? resumen;
  final bool isLoading;
  final String? error;

  const KpiCardRow({
    super.key,
    this.resumen,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading) return _buildSkeleton(context);
    if (error != null) return _buildError(context, error!);
    if (resumen == null) return _buildEmpty(context);

    final data = resumen!;
    final metrics = <_KpiData>[
      _KpiData(
        title: 'Generaciones de Hoy',
        value: _formatNumber(data.hoy),
        subtitle: _formatComparison(data.deltas.hoy),
        icon: Icons.today_rounded,
        color: 'cyan',
      ),
      _KpiData(
        title: 'Esta Semana',
        value: _formatNumber(data.semana),
        subtitle: _formatComparison(data.deltas.semana),
        icon: Icons.date_range_rounded,
        color: 'magenta',
      ),
      _KpiData(
        title: 'Este Mes',
        value: _formatNumber(data.mes),
        subtitle: _formatComparison(data.deltas.mes),
        icon: Icons.calendar_month_rounded,
        color: 'purple',
      ),
      _KpiData(
        title: 'Total Histórico',
        value: _formatNumber(data.total),
        subtitle: 'Generaciones acumuladas',
        icon: Icons.insights_rounded,
        color: 'green',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estadísticas del Cliente',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final metricsGrid = _gridMetrics(context, constraints.maxWidth);

            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: metricsGrid.columns,
                mainAxisExtent: metricsGrid.extent,
                crossAxisSpacing: _gap,
                mainAxisSpacing: _gap,
              ),
              itemCount: metrics.length,
              itemBuilder: (context, index) {
                return _KpiCard(
                  metric: metrics[index],
                  isDark: isDark,
                  index: index,
                );
              },
            );
          },
        ),
      ],
    );
  }

  /// Spacing shared by the KPI grid cells.
  static const double _gap = 12;

  /// Resolves column count and row height for the KPI grid.
  ///
  /// Cards narrower than 200px use the compact vertical layout, so they need
  /// a little more height (title can wrap to two lines).
  static ({int columns, double extent}) _gridMetrics(
    BuildContext context,
    double width,
  ) {
    final columns = width < 600 ? 2 : 4;
    final cardWidth = (width - _gap * (columns - 1)) / columns;
    final scale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.6);
    final baseExtent = cardWidth < 200 ? 138.0 : 120.0;
    return (columns: columns, extent: baseExtent * scale);
  }

  String _formatComparison(double? percentage) {
    if (percentage == null) return 'Sin datos previos';
    if (percentage == 0) return 'Sin cambios';
    final sign = percentage > 0 ? '+' : '';
    return '$sign${percentage.toStringAsFixed(1)}% vs período anterior';
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  Widget _buildSkeleton(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metricsGrid = _gridMetrics(context, constraints.maxWidth);

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: metricsGrid.columns,
            mainAxisExtent: metricsGrid.extent,
            crossAxisSpacing: _gap,
            mainAxisSpacing: _gap,
          ),
          itemCount: 4,
          itemBuilder: (context, index) => const _KpiCardSkeleton(),
        );
      },
    );
  }

  Widget _buildError(BuildContext context, String error) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Colors.redAccent.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Error al cargar métricas',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.insights_rounded,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin datos de métricas',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiData {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final String color;

  const _KpiData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class _KpiCard extends StatelessWidget {
  final _KpiData metric;
  final bool isDark;
  final int index;

  const _KpiCard({
    required this.metric,
    required this.isDark,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final neonColor = NeonColors.getNeon(metric.color, isDark);

    return NeonMetricCard(
      title: metric.title,
      value: metric.value,
      subtitle: metric.subtitle,
      icon: metric.icon,
      glowColor: neonColor,
      iconColor: neonColor,
    );
  }
}

class _KpiCardSkeleton extends StatelessWidget {
  const _KpiCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonBase(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor, width: 1),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonText(width: 100, height: 14),
            SizedBox(height: 12),
            SkeletonText(width: 80, height: 28),
            SizedBox(height: 8),
            SkeletonText(width: 60, height: 12),
          ],
        ),
      ),
    );
  }
}

/// Provider for KPI card row data
final kpiCardRowProvider = FutureProvider<DashboardResumen>((ref) async {
  final tz = ref.watch(dashboardTimezoneProvider);
  return ref.read(dashboardServiceProvider).getResumen(tz: tz);
});
