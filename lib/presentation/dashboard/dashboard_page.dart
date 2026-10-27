// Dashboard page for KrakenDraw - Client metrics, download history, membership history
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/presentation/shared/widgets/neon_background.dart';
import 'package:mobile/presentation/shared/widgets/neon_button.dart';
import 'package:mobile/presentation/shared/widgets/neon_card.dart';
import 'package:mobile/presentation/shared/widgets/skeleton_base.dart';
import 'package:mobile/presentation/shared/theme/theme_switcher.dart';
import 'package:mobile/presentation/dashboard/widgets/metrics_cards.dart';
import 'package:mobile/presentation/dashboard/widgets/download_history_list.dart';
import 'package:mobile/presentation/dashboard/widgets/membership_history_list.dart';
import 'package:mobile/presentation/dashboard/skeleton/metrics_skeleton.dart';
import 'package:mobile/presentation/dashboard/skeleton/history_list_skeleton.dart';
import 'package:mobile/presentation/dashboard/skeleton/membership_skeleton.dart';

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
    _DashboardTab(icon: Icons.credit_card_rounded, label: 'Membresías', index: 2),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          // Profile avatar button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: NeonIconButton(
              icon: Icons.person_outline_rounded,
              tooltip: 'Perfil',
              style: NeonButtonStyle.ghost,
              onPressed: () => context.go('/profile'),
            ),
          ),
          // Theme toggle
          ThemeToggleButton(
            iconSize: 22,
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colorScheme.primary,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.5),
          tabs: _tabs.map((tab) => Tab(icon: Icon(tab.icon), text: tab.label)).toList(),
        ),
      ),
      body: NeonBackground(
        showParticles: false,
        animationDuration: const Duration(seconds: 8),
        child: SafeArea(
          child: TabBarView(controller: _tabController, children: [
            _buildOverviewTab(context),
            _buildHistoryTab(context),
            _buildMembershipsTab(context),
          ]),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        // TODO: Refresh dashboard data
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),

          // Stats section
          Animate(
            effects: [FadeEffect(duration: 400.ms)],
            child: Text(
              'Estadísticas del Cliente',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),

          const SizedBox(height: 16),

          // Metrics cards grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Animate(
                effects: [
                  FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 100 * index)),
                  SlideEffect(begin: const Offset(0, 0.3), end: Offset.zero, duration: 400.ms),
                ],
                child: NeonMetricCard(
                  title: _getMetricTitle(index),
                  value: _getMetricValue(index),
                  subtitle: _getMetricSubtitle(index),
                  icon: _getMetricIcon(index),
                  glowColor: NeonColors.getNeon(_getMetricColor(index), isDark),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Detalles de ${_getMetricTitle(index)}',
                          style: GoogleFonts.inter(),
                        ),
                        backgroundColor: colorScheme.surfaceContainerHighest,
                      ),
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Quick actions
          Animate(
            effects: [FadeEffect(duration: 400.ms)],
            child: Text(
              'Acciones Rápidas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Animate(
                  effects: [FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 200))],
                  child: NeonButton(
                    label: 'Descargar',
                    icon: Icons.download_rounded,
                    style: NeonButtonStyle.primary,
                    isFullWidth: true,
                    onPressed: () {
                      // TODO: Implement download action
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
                  effects: [FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 300))],
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

          const SizedBox(height: 32),

          // Recent activity placeholder
          Animate(
            effects: [FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 600))],
            child: GlowCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Animate(
                    effects: [FadeEffect(duration: 400.ms)],
                    child: Text(
                      'Actividad Reciente',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Animate(
                    effects: [FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 400))],
                    child: Text(
                      'Sin actividad reciente',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Animate(
                    effects: [FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 500))],
                    child: TextButton.icon(
                      onPressed: () {
                        // Navigate to history tab
                        _tabController.animateTo(1);
                      },
                      icon: const Icon(Icons.history_rounded, size: 18),
                      label: Text(
                        'Ver historial completo',
                        style: GoogleFonts.inter(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
        await Future.delayed(const Duration(seconds: 1));
        // TODO: Refresh membership data
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),

          // Subscription header
          Animate(
            effects: [FadeEffect(duration: 400.ms)],
            child: GlowCard(
              glowColor: NeonColors.getNeon('green', Theme.of(context).brightness == Brightness.dark),
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
                        glowColor: NeonColors.getGlow('green', Theme.of(context).brightness == Brightness.dark),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Vige hasta 31/12/2024',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                        ),
                      ),
                      NeonButton(
                        label: 'Renovar',
                        icon: Icons.refresh_rounded,
                        style: NeonButtonStyle.outline,
                        onPressed: () {
                          // TODO: Implement renewal
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Función en desarrollo',
                                style: GoogleFonts.inter(),
                              ),
                              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            ),
                          );
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  Widget _buildBottomNav(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
          _tabController.animateTo(index);
        });
      },
      destinations: _tabs.map((tab) {
        return NavigationDestination(
          icon: Icon(tab.icon),
          selectedIcon: Icon(tab.icon, color: colorScheme.primary),
          label: tab.label,
        );
      }).toList(),
    );
  }

  String _getMetricTitle(int index) {
    switch (index) {
      case 0:
        return 'Generaciones Hoy';
      case 1:
        return 'Esta Semana';
      case 2:
        return 'Este Mes';
      case 3:
        return 'Total';
      default:
        return 'Métrica';
    }
  }

  String _getMetricValue(int index) {
    switch (index) {
      case 0:
        return '12';
      case 1:
        return '45';
      case 2:
        return '156';
      case 3:
        return '1.243';
      default:
        return '0';
    }
  }

  String _getMetricSubtitle(int index) {
    switch (index) {
      case 0:
        return '+2 respecto a ayer';
      case 1:
        return '+5 respecto a la semana anterior';
      case 2:
        return '+12 respecto al mes anterior';
      case 3:
        return 'generaciones totales';
      default:
        return '';
    }
  }

  IconData _getMetricIcon(int index) {
    switch (index) {
      case 0:
        return Icons.show_chart_rounded;
      case 1:
        return Icons.show_chart_rounded;
      case 2:
        return Icons.show_chart_rounded;
      case 3:
        return Icons.insights_rounded;
      default:
        return Icons.show_chart_rounded;
    }
  }

  String _getMetricColor(int index) {
    switch (index % 4) {
      case 0:
        return 'cyan';
      case 1:
        return 'magenta';
      case 2:
        return 'purple';
      case 3:
        return 'green';
      default:
        return 'cyan';
    }
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