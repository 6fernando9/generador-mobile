// Dashboard page for KrakenDraw - Client metrics, download history, membership history
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/core/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/presentation/shared/widgets/neon_background.dart';
import 'package:mobile/presentation/shared/widgets/neon_button.dart';
import 'package:mobile/presentation/shared/widgets/neon_card.dart'
    show GlowCard, NeonBadge, NeonBadgeStyle;
import 'package:mobile/presentation/shared/widgets/skeleton_base.dart'
    show SkeletonBase, SkeletonBox, SkeletonText;
import 'package:mobile/presentation/shared/theme/theme_switcher.dart';
import 'package:mobile/presentation/dashboard/widgets/download_history_list.dart';
import 'package:mobile/presentation/dashboard/widgets/membership_history_list.dart';
import 'package:mobile/presentation/dashboard/widgets/date_range_selector.dart';
import 'package:mobile/presentation/dashboard/widgets/kpi_card_row.dart';
import 'package:mobile/presentation/dashboard/widgets/charts/neon_line_chart.dart';
import 'package:mobile/presentation/dashboard/widgets/charts/neon_donut_chart.dart';
import 'package:mobile/presentation/dashboard/widgets/charts/neon_heatmap.dart';
import 'package:mobile/presentation/dashboard/widgets/project_ranking_list.dart';
import 'package:mobile/presentation/dashboard/dashboard_providers.dart';
import 'package:mobile/main.dart' show AppBottomNavBar;

/// Dashboard page with tabs for Overview, History, and Memberships
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _selectedIndex = 0;

  // Tab options
  static const List<_DashboardTab> _tabs = [
    _DashboardTab(icon: Icons.insights_rounded, label: 'Resumen', index: 0),
    _DashboardTab(icon: Icons.download_rounded, label: 'Historial', index: 1),
    _DashboardTab(
      icon: Icons.credit_card_rounded,
      label: 'Membresías',
      index: 2,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.index != _selectedIndex) {
      setState(() => _selectedIndex = _tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_tabs[_selectedIndex].label),
        centerTitle: true,
        actions: [
          // Theme toggle
          ThemeToggleButton(iconSize: 22),
          const SizedBox(width: 8),
        ],
      ),
      body: NeonBackground(
        showParticles: false,
        animationDuration: const Duration(seconds: 8),
        child: SafeArea(
          child: Column(
            children: [
              // TabBarView content (expanded)
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(context),
                    _buildHistoryTab(context),
                    _buildMembershipsTab(context),
                  ],
                ),
              ),
              // TabBar at bottom of content area
              TabBar(
                controller: _tabController,
                indicatorColor: colorScheme.primary,
                labelColor: colorScheme.primary,
                unselectedLabelColor: colorScheme.onSurface.withValues(
                  alpha: 0.5,
                ),
                tabs: _tabs
                    .map((tab) => Tab(icon: Icon(tab.icon), text: tab.label))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Watch providers
    final resumenAsync = ref.watch(dashboardResumenAutoProvider);
    final tendenciaAsync = ref.watch(dashboardTendenciaAutoProvider);
    final tecnologiasAsync = ref.watch(dashboardTecnologiasProvider);
    final actividadAsync = ref.watch(dashboardActividadAutoProvider);
    final proyectosAsync = ref.watch(dashboardProyectosProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(dashboardResumenAutoProvider);
        ref.invalidate(dashboardTendenciaAutoProvider);
        ref.invalidate(dashboardTecnologiasProvider);
        ref.invalidate(dashboardActividadAutoProvider);
        ref.invalidate(dashboardProyectosProvider);
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),

          // Date Range Selector
          Animate(
            effects: [FadeEffect(duration: 400.ms)],
            child: DateRangeSelector(showLabel: true),
          ),

          const SizedBox(height: 16),

          // KPI Cards Row
          Animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 100)),
            ],
            child: resumenAsync.when(
              data: (resumen) => KpiCardRow(resumen: resumen),
              loading: () => KpiCardRow(isLoading: true),
              error: (e, _) => KpiCardRow(error: e.toString()),
            ),
          ),

          const SizedBox(height: 32),

          // Tendencia Chart
          Animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 200)),
            ],
            child: _buildSectionHeader(
              context,
              'Tendencia de Generaciones',
              Icons.show_chart_rounded,
              NeonColors.getNeon('cyan', isDark),
            ),
          ),
          const SizedBox(height: 12),
          Animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 300)),
            ],
            child: tendenciaAsync.when(
              data: (tendencia) => NeonLineChart(data: tendencia),
              loading: () => _buildChartSkeleton(
                context,
                height: NeonLineChart.responsiveHeight(context),
              ),
              error: (e, _) => _buildChartError(context, e.toString()),
            ),
          ),

          const SizedBox(height: 32),

          // Tecnologías Grid
          Animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 400)),
            ],
            child: _buildSectionHeader(
              context,
              'Distribución de Tecnologías',
              Icons.code_rounded,
              NeonColors.getNeon('magenta', isDark),
            ),
          ),
          const SizedBox(height: 12),
          Animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 500)),
            ],
            child: tecnologiasAsync.when(
              data: (tecnologias) => NeonDonutGrid(data: tecnologias),
              loading: () => _buildDonutGridSkeleton(context),
              error: (e, _) => _buildChartError(context, e.toString()),
            ),
          ),

          const SizedBox(height: 32),

          // Actividad Heatmap
          Animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 600)),
            ],
            child: _buildSectionHeader(
              context,
              'Mapa de Actividad',
              Icons.grid_on_rounded,
              NeonColors.getNeon('purple', isDark),
            ),
          ),
          const SizedBox(height: 12),
          Animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 700)),
            ],
            child: actividadAsync.when(
              data: (actividad) => NeonHeatmap(data: actividad),
              loading: () => _buildChartSkeleton(context, height: 300),
              error: (e, _) => _buildChartError(context, e.toString()),
            ),
          ),

          const SizedBox(height: 32),

          // Top Proyectos
          Animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 800)),
            ],
            child: proyectosAsync.when(
              data: (proyectos) =>
                  ProjectRankingList(proyectos: proyectos, maxItems: 5),
              loading: () => ProjectRankingList(isLoading: true, maxItems: 5),
              error: (e, _) =>
                  ProjectRankingList(error: e.toString(), maxItems: 5),
            ),
          ),

          const SizedBox(height: 32),

          // Quick Actions
          Animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 900)),
            ],
            child: _buildSectionHeader(
              context,
              'Acciones Rápidas',
              Icons.flash_on_rounded,
              NeonColors.getNeon('orange', isDark),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Animate(
                  effects: [
                    FadeEffect(
                      duration: 400.ms,
                      delay: Duration(milliseconds: 1000),
                    ),
                  ],
                  child: NeonButton(
                    label: 'Nueva Generación',
                    icon: Icons.add_rounded,
                    style: NeonButtonStyle.primary,
                    isFullWidth: true,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Función en desarrollo',
                            style: GoogleFonts.inter(),
                          ),
                          backgroundColor: colorScheme.surfaceContainerHighest,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Animate(
                  effects: [
                    FadeEffect(
                      duration: 400.ms,
                      delay: Duration(milliseconds: 1100),
                    ),
                  ],
                  child: NeonButton(
                    label: 'Ver Planes',
                    icon: Icons.view_module_rounded,
                    style: NeonButtonStyle.secondary,
                    isFullWidth: true,
                    onPressed: () => _tabController.animateTo(2),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.code_rounded), text: 'Generaciones'),
              Tab(icon: Icon(Icons.description_rounded), text: 'Archivos'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                DownloadHistoryList(),
                const Center(
                  child: Text(
                    'Los archivos se descargarán desde aquí',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipsTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh membership data
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),

          // Subscription header
          Animate(
            effects: [FadeEffect(duration: 400.ms)],
            child: GlowCard(
              glowColor: NeonColors.getNeon(
                'green',
                Theme.of(context).brightness == Brightness.dark,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Animate(
                    effects: [FadeEffect(duration: 400.ms)],
                    child: Text(
                      'Tu Suscripción',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      NeonBadge(
                        label: 'Premium',
                        icon: Icons.star_rounded,
                        color: NeonColors.green,
                        style: NeonBadgeStyle.filled,
                        glowColor: NeonColors.getGlow(
                          'green',
                          Theme.of(context).brightness == Brightness.dark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Vige hasta 31/12/2024',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                        ),
                      ),
                      NeonButton(
                        label: 'Renovar',
                        icon: Icons.refresh_rounded,
                        style: NeonButtonStyle.outline,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Función en desarrollo',
                                style: GoogleFonts.inter(),
                              ),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                            ),
                          );
                        },
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Membership history header
          Animate(
            effects: [FadeEffect(duration: 400.ms)],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Historial de Pagos',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // TODO: Implement view all
                  },
                  icon: const Icon(Icons.list_rounded, size: 18),
                  label: Text(
                    'Ver todo',
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Payment history cards
          MembershipHistoryList(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartSkeleton(BuildContext context, {double height = 200}) {
    return SkeletonBase(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
    );
  }

  Widget _buildDonutGridSkeleton(BuildContext context) {
    // Mirror NeonDonutGrid sizing via the shared DonutGridMetrics helper.
    final deviceType = Responsive.deviceType(context);
    final showLegend = deviceType == DeviceType.desktop ||
        deviceType == DeviceType.largeDesktop;

    // The dashboard ListView pads its children by 16px on each side, which is
    // exactly what NeonDonutGrid receives through its LayoutBuilder.
    final metrics = DonutGridMetrics.compute(
      MediaQuery.sizeOf(context).width - 32,
      showLegend: showLegend,
      fontScale: Responsive.fontScale(context),
    );

    return SizedBox(
      height: metrics.gridHeight(6),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: metrics.crossAxisCount,
          childAspectRatio: metrics.aspectRatio,
          crossAxisSpacing: DonutGridMetrics.spacing,
          mainAxisSpacing: DonutGridMetrics.spacing,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => SkeletonBase(
          child: _DonutSkeletonContent(chartSize: metrics.chartSize),
        ),
      ),
    );
  }

  Widget _buildChartError(BuildContext context, String error) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.redAccent.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Error al cargar gráfico',
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
            const SizedBox(height: 12),
            NeonButton(
              label: 'Reintentar',
              icon: Icons.refresh_rounded,
              style: NeonButtonStyle.primary,
              onPressed: () {
                // Refresh all providers
                ref.invalidate(dashboardResumenAutoProvider);
                ref.invalidate(dashboardTendenciaAutoProvider);
                ref.invalidate(dashboardTecnologiasProvider);
                ref.invalidate(dashboardActividadAutoProvider);
                ref.invalidate(dashboardProyectosProvider);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DonutSkeletonContent extends StatelessWidget {
  final double chartSize;

  const _DonutSkeletonContent({this.chartSize = 120});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Column(
        children: [
          SkeletonText(width: 80, height: 14),
          const SizedBox(height: 12),
          Expanded(
            child: Center(
              child: SkeletonBox(
                width: chartSize,
                height: chartSize,
                borderRadius: chartSize / 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardTab {
  final IconData icon;
  final String label;
  final int index;

  const _DashboardTab({
    required this.icon,
    required this.label,
    required this.index,
  });
}
