// KPI Card Row for Dashboard Overview
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/presentation/dashboard/widgets/charts/neon_sparkline.dart';
import 'package:mobile/presentation/dashboard/dashboard_providers.dart';
import 'package:mobile/presentation/shared/widgets/neon_card.dart';
import 'package:mobile/presentation/shared/widgets/skeleton_base.dart'
    show SkeletonBase, SkeletonBox, SkeletonText;
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/data/models/dashboard_resumen.dart';
import 'package:mobile/core/utils/responsive.dart';

/// Row of 4 KPI cards with sparklines
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

    if (isLoading) {
      return _buildSkeleton(context);
    }

    if (error != null) {
      return _buildError(context, error!);
    }

    if (resumen == null) {
      return _buildEmpty(context);
    }

    // Build KPI data from the new model structure
    final metrics = [
      _KpiData(
        title: 'Generaciones Hoy',
        value: resumen!.hoy.toString(),
        subtitle: _formatComparison(resumen!.deltas.hoy),
        icon: Icons.today_rounded,
        color: 'cyan',
        sparklineData: _generateMockSparkline(24, 0), // 24 hours
      ),
      _KpiData(
        title: 'Ayer',
        value: resumen!.ayer.toString(),
        subtitle: 'Comparado con anteayer',
        icon: Icons.history_rounded,
        color: 'blue',
        sparklineData: _generateMockSparkline(24, 1),
      ),
      _KpiData(
        title: 'Esta Semana',
        value: resumen!.semana.toString(),
        subtitle: _formatComparison(resumen!.deltas.semana),
        icon: Icons.date_range_rounded,
        color: 'magenta',
        sparklineData: _generateMockSparkline(7, 2), // 7 days
      ),
      _KpiData(
        title: 'Semana Pasada',
        value: resumen!.semanaPasada.toString(),
        subtitle: 'Comparado con semana anterior',
        icon: Icons.event_rounded,
        color: 'purple',
        sparklineData: _generateMockSparkline(7, 3),
      ),
      _KpiData(
        title: 'Este Mes',
        value: resumen!.mes.toString(),
        subtitle: resumen!.deltas.mes != null ? _formatComparison(resumen!.deltas.mes!) : 'Sin datos previos',
        icon: Icons.calendar_month_rounded,
        color: 'purple',
        sparklineData: _generateMockSparkline(30, 4), // 30 days
      ),
      _KpiData(
        title: 'Mes Pasado',
        value: resumen!.mesPasado.toString(),
        subtitle: 'Comparado con mes anterior',
        icon: Icons.calendar_today_rounded,
        color: 'orange',
        sparklineData: _generateMockSparkline(30, 5),
      ),
      _KpiData(
        title: 'Total',
        value: _formatNumber(resumen!.total),
        subtitle: 'Total histórico',
        icon: Icons.insights_rounded,
        color: 'green',
        sparklineData: _generateMockSparkline(12, 6), // 12 months
      ),
    ];

    // Calculate grid height based on constraints to avoid infinite constraints in ListView
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
            final isMobile = constraints.maxWidth < 600;
            final crossAxisCount = isMobile ? 2 : 4;
            final childAspectRatio = isMobile ? 1.1 : 1.2;
            final itemCount = metrics.length;
            final rows = (itemCount / crossAxisCount).ceil();
            const spacing = 12.0;
            const horizontalPadding = 0.0; // No extra horizontal padding inside grid
            final availableWidth = constraints.maxWidth;
            final itemWidth = (availableWidth - spacing * (crossAxisCount - 1)) / crossAxisCount;
            final itemHeight = itemWidth / childAspectRatio;
            final gridHeight = itemHeight * rows + spacing * (rows - 1);

            return SizedBox(
              height: gridHeight,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                ),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  final metric = metrics[index];
                  return _KpiCard(
                    metric: metric,
                    isDark: isDark,
                    index: index,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatComparison(double percentage) {
    if (percentage == 0) return 'Sin cambios';
    final sign = percentage > 0 ? '+' : '';
    return '$sign${percentage.toStringAsFixed(1)}%';
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  List<double> _generateMockSparkline(int points, [int index = 0]) {
    // In production, this would come from the API time series data
    // For now, generate deterministic data based on current time
    final seed = DateTime.now().millisecondsSinceEpoch;
    return List.generate(points, (i) {
      final pseudoRandom = (seed + i * 17 + index * 31) % 1000;
      return 20 + (pseudoRandom / 1000) * 60;
    });
  }

  Widget _buildSkeleton(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final crossAxisCount = isMobile ? 2 : 4;
        const childAspectRatio = 1.1;
        const itemCount = 4;
        const spacing = 12.0;
        final availableWidth = constraints.maxWidth;
        final itemWidth = (availableWidth - spacing * (crossAxisCount - 1)) / crossAxisCount;
        final itemHeight = itemWidth / childAspectRatio;
        final rows = (itemCount / crossAxisCount).ceil();
        final gridHeight = itemHeight * rows + spacing * (rows - 1);

        return SizedBox(
          height: gridHeight,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 4,
            itemBuilder: (context, index) => const _KpiCardSkeleton(),
          ),
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
          Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text(
            'Error al cargar métricas',
            style: GoogleFonts.spaceGrotesk(fontSize: 16, color: colorScheme.onSurface.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: GoogleFonts.inter(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.5)),
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
          Icon(Icons.insights_rounded, size: 48, color: colorScheme.onSurface.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'Sin datos de métricas',
            style: GoogleFonts.spaceGrotesk(fontSize: 16, color: colorScheme.onSurface.withValues(alpha: 0.5)),
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
  final List<double> sparklineData;

  const _KpiData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.sparklineData,
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
    final colorScheme = Theme.of(context).colorScheme;
    final neonColor = NeonColors.getNeon(metric.color, isDark);
    final glowColor = NeonColors.getGlow(metric.color, isDark);

    return NeonMetricCard(
      title: metric.title,
      value: metric.value,
      subtitle: metric.subtitle,
      icon: metric.icon,
      glowColor: neonColor,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Detalles de ${metric.title}'),
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
        );
      },
      trailing: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ResponsiveSparkline(
          data: metric.sparklineData,
          color: neonColor,
          showArea: true,
        ),
      ),
    );
  }
}

class _KpiCardSkeleton extends StatelessWidget {
  const _KpiCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonBase(
      child: const _KpiCardSkeletonContent(),
    );
  }
}

class _KpiCardSkeletonContent extends StatelessWidget {
  const _KpiCardSkeletonContent();

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const SkeletonText(width: 100, height: 14),
          const SizedBox(height: 12),
          const SkeletonText(width: 80, height: 28),
          const SizedBox(height: 8),
          Row(
            children: [
              const SkeletonText(width: 60, height: 12),
              const SizedBox(width: 8),
              const SkeletonText(width: 60, height: 12),
            ],
          ),
          const SizedBox(height: 16),
          const SkeletonBox(width: double.infinity, height: 40),
        ],
      ),
    );
  }
}

/// Provider for KPI card row data
final kpiCardRowProvider = FutureProvider<DashboardResumen>((ref) async {
  final tz = ref.watch(dashboardTimezoneProvider);
  return await ref.read(dashboardServiceProvider).getResumen(tz: tz);
});