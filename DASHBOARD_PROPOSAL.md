# KrakenDraw Dashboard - Implementation Proposal

## Backend Endpoints Analysis

| Endpoint | Path | Data | UI Component |
|----------|------|------|--------------|
| KPIs | `GET /dashboard/mi-resumen` | today, week, month, total + comparisons | 4 Metric Cards (NeonMetricCard) |
| Tendencia | `GET /dashboard/mi-tendencia` | Time series + artifact type breakdown | Line/Area Chart + Stacked Bar |
| Tecnologías | `GET /dashboard/mi-tecnologias` | Distributions (language, framework, arch, ORM, DB, artifact) | 6 Donut/Pie Charts in Grid |
| Actividad | `GET /dashboard/mi-actividad` | Heatmap (day of week × hour) | Heatmap Calendar |
| Proyectos | `GET /dashboard/mis-proyectos` | Top projects by generations | Ranked List with Progress Bars |

---

## Proposed Dashboard Structure (Resumen Tab)

### 1. Header Section
- **Page Title**: "Resumen" (dynamic based on selected tab)
- **Date Range Selector** with icon support & fallback
- **Refresh Button** (pull-to-refresh + manual)

### 2. KPI Cards Row (4 cards - from `/mi-resumen`)
```
┌─────────────┬─────────────┬─────────────┬─────────────┐
│  Generaciones│   Esta Semana│   Este Mes  │    Total    │
│      Hoy    │              │             │             │
│     127     │     423      │    1,256    │   12,453    │
│  +12 vs ayer│  +45 vs sem  │  +89 vs mes │  totales    │
│  [chart ↑]  │  [chart ↑]   │  [chart ↑]  │  [chart ↑]  │
└─────────────┴─────────────┴─────────────┴─────────────┘
```
- **Responsive**: 2×2 on mobile, 1×4 on tablet+
- **Each card**: NeonMetricCard with sparkline mini-chart

### 3. Date Range Selector Component
```dart
class DateRangeSelector extends ConsumerWidget {
  // Supports: Today, Week, Month, Quarter, Year, Custom
  // Icon per option (calendar_today, date_range, event, etc.)
  // Fallback: text-only if icon fails
  // Persists selection in Riverpod
}
```

### 4. Tendencia Chart (from `/mi-tendencia`)
- **Chart Type**: Area chart (generations over time) + Stacked bar (artifact types)
- **X-axis**: Date (days/weeks based on range)
- **Y-axis**: Count
- **Legend**: Artifact types with neon colors
- **Tooltip**: Exact count + percentage per type
- **Library**: `fl_chart` (already in pubspec)

### 5. Tecnologías Grid (from `/mi-tecnologias`)
```
┌──────────────┬──────────────┬──────────────┐
│   Lenguajes  │  Frameworks  │ Arquitectura │
│  [Donut 1]   │  [Donut 2]   │  [Donut 3]   │
├──────────────┼──────────────┼──────────────┤
│      ORM     │     Base de  │  Artefactos  │
│  [Donut 4]   │    Datos     │  [Donut 6]   │
│              │  [Donut 5]   │              │
└──────────────┴──────────────┴──────────────┘
```
- **Responsive**: 2 cols mobile, 3 cols tablet, 3 cols desktop
- **Each**: NeonCard with DonutChart + top 3 legend

### 6. Actividad Heatmap (from `/mi-actividad`)
```
       00  01  02  ...  22  23
    ┌──────────────────────────┐
 Lun │ ░░ ░░ ░░     ██ ██ ██ ░░ │
 Mar │ ░░ ░░ ░░     ░░ ░░ ██ ░░ │
 Mié │ ░░ ██ ██     ██ ██ ██ ░░ │
 Jue │ ░░ ░░ ░░     ░░ ░░ ░░ ░░ │
 Vie │ ░░ ░░ ██     ██ ██ ██ ██ │
 Sáb │ ░░ ░░ ░░     ░░ ░░ ░░ ░░ │
 Dom │ ██ ██ ██     ░░ ░░ ░░ ░░ │
    └──────────────────────────┘
    Low ──────────────────── High
```
- **Color scale**: Neon gradient (cyan → magenta → purple)
- **Tooltip**: Exact count on hover/tap
- **Legend**: Min/Max values

### 7. Top Proyectos (from `/mis-proyectos`)
```
┌─────────────────────────────────────────────────────┐
│ 1. KrakenDraw API     ████████████░░░░  1,234 gen   │
│ 2. Dashboard Web      ████████░░░░░░░░░  892 gen    │
│ 3. Mobile App         ██████░░░░░░░░░░░  567 gen    │
│ 4. Auth Service       ████░░░░░░░░░░░░░  345 gen    │
└─────────────────────────────────────────────────────┘
```
- **Progress bar**: Neon glow, percentage of top project
- **Tap**: Navigate to project detail (future)

---

## Date Range Selector - Icon Support with Fallback

```dart
class DateRangeOption {
  final String label;
  final String value;  // 'today', 'week', 'month', 'quarter', 'year', 'custom'
  final IconData icon;
  final IconData? fallbackIcon; // e.g., Icons.calendar_today

  const DateRangeOption({
    required this.label,
    required this.value,
    required this.icon,
    this.fallbackIcon,
  });
}

// Predefined options with icons
static const List<DateRangeOption> dateRangeOptions = [
  DateRangeOption(label: 'Hoy', value: 'today', icon: Icons.today_rounded, fallbackIcon: Icons.event_rounded),
  DateRangeOption(label: 'Esta Semana', value: 'week', icon: Icons.date_range_rounded, fallbackIcon: Icons.calendar_view_week_rounded),
  DateRangeOption(label: 'Este Mes', value: 'month', icon: Icons.calendar_month_rounded, fallbackIcon: Icons.calendar_today_rounded),
  DateRangeOption(label: 'Este Trimestre', value: 'quarter', icon: Icons.calendar_view_month_rounded, fallbackIcon: Icons.event_note_rounded),
  DateRangeOption(label: 'Este Año', value: 'year', icon: Icons.event_rounded, fallbackIcon: Icons.calendar_today_rounded),
  DateRangeOption(label: 'Personalizado', value: 'custom', icon: Icons.tune_rounded, fallbackIcon: Icons.settings_rounded),
];
```

**Icon Fallback Strategy**:
1. Try primary icon (Material Design round)
2. If not available (older Flutter), use fallbackIcon
3. If both fail, render text-only with NeonBadge style

---

## Required Dependencies

```yaml
# pubspec.yaml additions
dependencies:
  fl_chart: ^0.68.0          # Charts (line, area, bar, pie, radar)
  syncfusion_flutter_charts: ^25.1.0  # Alternative with heatmap
  # OR use fl_chart for all (supports heatmap via GridView custom)
```

**Recommendation**: Use `fl_chart` for everything - lighter, neon-friendly, already Material 3 compatible.

---

## Data Models (Freezed) - To Generate

```dart
// lib/data/models/dashboard_resumen.dart
@freezed
class DashboardResumen with _$DashboardResumen {
  factory DashboardResumen({
    required KpiMetric hoy,
    required KpiMetric semana,
    required KpiMetric mes,
    required KpiMetric total,
  }) = _DashboardResumen;

  factory DashboardResumen.fromJson(Map<String, dynamic> json) => _$DashboardResumenFromJson(json);
}

@freezed
class KpiMetric with _$KpiMetric {
  factory KpiMetric({
    required int value,
    required int comparison,      // vs previous period
    required double percentChange,
    required String periodLabel,
  }) = _KpiMetric;
}

// lib/data/models/dashboard_tendencia.dart
@freezed
class DashboardTendencia with _$DashboardTendencia {
  factory DashboardTendencia({
    required List<TimeSeriesPoint> series,
    required List<ArtifactBreakdown> artifactTypes,
  }) = _DashboardTendencia;
}

@freezed
class TimeSeriesPoint with _$TimeSeriesPoint {
  factory TimeSeriesPoint({
    required DateTime date,
    required int total,
    required Map<String, int> byArtifactType,
  }) = _TimeSeriesPoint;
}

// lib/data/models/dashboard_tecnologias.dart
@freezed
class DashboardTecnologias with _$DashboardTecnologias {
  factory DashboardTecnologias({
    required List<DistributionItem> lenguajes,
    required List<DistributionItem> frameworks,
    required List<DistributionItem> arquitecturas,
    required List<DistributionItem> orms,
    required List<DistributionItem> basesDatos,
    required List<DistributionItem> artefactos,
  }) = _DashboardTecnologias;
}

@freezed
class DistributionItem with _$DistributionItem {
  factory DistributionItem({
    required String name,
    required int count,
    required double percentage,
  }) = _DistributionItem;
}

// lib/data/models/dashboard_actividad.dart
@freezed
class DashboardActividad with _$DashboardActividad {
  factory DashboardActividad({
    required List<List<int>> heatmap,  // 7 days × 24 hours
    required int maxValue,
    required int minValue,
    required int total,
  }) = _DashboardActividad;
}

// lib/data/models/dashboard_proyectos.dart
@freezed
class DashboardProyectos with _$DashboardProyectos {
  factory DashboardProyectos({
    required List<ProjectRanking> proyectos,
  }) = _DashboardProyectos;
}

@freezed
class ProjectRanking with _$ProjectRanking {
  factory ProjectRanking({
    required String id,
    required String nombre,
    required int generaciones,
    required double porcentaje,
  }) = _ProjectRanking;
}
```

---

## Riverpod Providers

```dart
// lib/presentation/dashboard/dashboard_providers.dart

// Date range state
final dateRangeProvider = StateProvider<DateRange>((ref) => DateRange.month);

// Individual data providers
final dashboardResumenProvider = FutureProvider.family<DashboardResumen, String?>((ref, tz) async {
  return await ref.read(dashboardServiceProvider).getResumen(tz: tz);
});

final dashboardTendenciaProvider = FutureProvider.family<DashboardTendencia, String?>((ref, tz) async {
  return await ref.read(dashboardServiceProvider).getTendencia(tz: tz);
});

final dashboardTecnologiasProvider = FutureProvider<DashboardTecnologias>((ref) async {
  return await ref.read(dashboardServiceProvider).getTecnologias();
});

final dashboardActividadProvider = FutureProvider.family<DashboardActividad, String?>((ref, tz) async {
  return await ref.read(dashboardServiceProvider).getActividad(tz: tz);
});

final dashboardProyectosProvider = FutureProvider<DashboardProyectos>((ref) async {
  return await ref.read(dashboardServiceProvider).getProyectosUsuarios();
});

// Combined provider for initial load
final dashboardAllProvider = FutureProvider.family<Map<String, dynamic>, String?>((ref, tz) async {
  return await ref.read(dashboardServiceProvider).getAll(tz: tz);
});
```

---

## Chart Widget Components

### 1. NeonLineChart (Tendencia)
```dart
class NeonLineChart extends StatelessWidget {
  final List<TimeSeriesPoint> data;
  final List<ArtifactBreakdown> artifactTypes;
  final bool showArea;
  final Color primaryColor;
}
```

### 2. NeonDonutChart (Tecnologías)
```dart
class NeonDonutChart extends StatelessWidget {
  final List<DistributionItem> data;
  final String title;
  final int maxItems; // Show top N, group rest as "Otros"
  final Color glowColor;
}
```

### 3. NeonHeatmap (Actividad)
```dart
class NeonHeatmap extends StatelessWidget {
  final List<List<int>> grid; // 7x24
  final int maxValue;
  final Color lowColor;
  final Color highColor;
  final ValueChanged<HeatmapCell>? onCellTap;
}
```

### 4. NeonSparkline (KPI Cards)
```dart
class NeonSparkline extends StatelessWidget {
  final List<double> data;
  final Color color;
  final bool showPoints;
}
```

---

## Implementation Priority

### Phase 1: Core KPIs + Date Selector (Week 1)
- [ ] Create Freezed models
- [ ] Run build_runner
- [ ] Connect DashboardService to real API
- [ ] Implement DateRangeSelector with icon fallback
- [ ] Replace mock KPI cards with real data
- [ ] Add pull-to-refresh

### Phase 2: Tendencia Chart (Week 2)
- [ ] Add fl_chart dependency
- [ ] Create NeonLineChart widget
- [ ] Implement time series + stacked artifact breakdown
- [ ] Add tooltip with neon styling
- [ ] Responsive: full width mobile, side-by-side tablet

### Phase 3: Tecnologías Grid (Week 2-3)
- [ ] Create NeonDonutChart widget
- [ ] Build 6-chart responsive grid
- [ ] Add "Top 5 + Otros" grouping
- [ ] Legend with neon colors

### Phase 4: Actividad Heatmap (Week 3)
- [ ] Create NeonHeatmap widget (custom GridView)
- [ ] Neon color gradient (cyan→magenta→purple)
- [ ] Tooltip on tap/hover
- [ ] Day labels (Lun-Dom), Hour labels (0-23)

### Phase 5: Proyectos Ranking (Week 3)
- [ ] Create ProjectRankingList widget
- [ ] Neon progress bars
- [ ] Navigate to detail (placeholder)

### Phase 6: Polish & Skeleton Loaders (Week 4)
- [ ] Create skeleton for each chart type
- [ ] Add error states with retry
- [ ] Polish animations
- [ ] Test on mobile/tablet/desktop

---

## Responsive Breakpoints for Dashboard

| Component | Mobile (<600) | Tablet (600-900) | Desktop (900-1200) | Large (>1200) |
|-----------|---------------|------------------|--------------------|---------------|
| KPI Cards | 2×2 grid | 1×4 row | 1×4 row | 1×4 row |
| Tendencia | Full width | Full width | 60% + Tecnologías 40% | 60% + 40% |
| Tecnologías | 2×3 grid | 3×2 grid | 3×2 grid | 3×2 grid |
| Heatmap | Scrollable | Full | Full | Full |
| Proyectos | Full width cards | 2-col | 3-col | 4-col |

---

## Neon Theme Integration

All charts use `NeonColors` palette:
- **Primary series**: Cyan (dark) / Cyan Light (light)
- **Secondary**: Magenta / Magenta Light
- **Tertiary**: Purple / Purple Light
- **Success**: Green / Green Light
- **Warning**: Orange / Orange Light
- **Heatmap gradient**: Cyan → Magenta → Purple

```dart
// Chart theming helper
class NeonChartTheme {
  static LineChartData lineChartData(BuildContext context, Color primary) { ... }
  static PieChartData donutChartData(BuildContext context, List<Color> colors) { ... }
  static FlGridData gridData(Color color) { ... }
  static FlTitlesData titlesData(BuildContext context) { ... }
}
```

---

## File Structure to Create/Modify

```
lib/
├── data/
│   └── models/
│       ├── dashboard_resumen.dart
│       ├── dashboard_tendencia.dart
│       ├── dashboard_tecnologias.dart
│       ├── dashboard_actividad.dart
│       └── dashboard_proyectos.dart
├── presentation/
│   └── dashboard/
│       ├── dashboard_providers.dart          # NEW: Riverpod providers
│       ├── widgets/
│       │   ├── date_range_selector.dart      # NEW: Date selector with icons
│       │   ├── charts/
│       │   │   ├── neon_line_chart.dart      # NEW: Tendencia chart
│       │   │   ├── neon_donut_chart.dart     # NEW: Tecnologías donuts
│       │   │   ├── neon_heatmap.dart         # NEW: Actividad heatmap
│       │   │   └── neon_sparkline.dart       # NEW: KPI mini charts
│       │   ├── project_ranking_list.dart     # NEW: Proyectos list
│       │   └── kpi_card_row.dart             # NEW: 4 KPI cards row
│       └── skeleton/
│           ├── chart_skeleton.dart           # NEW: Chart skeletons
│           ├── heatmap_skeleton.dart         # NEW: Heatmap skeleton
│           └── donut_skeleton.dart           # NEW: Donut skeleton
```

---

## Next Steps

1. **Confirm approach** - Review this proposal with you
2. **Generate Freezed models** - Run `dart run build_runner build --delete-conflicting-outputs`
3. **Add fl_chart dependency** - `flutter pub add fl_chart`
4. **Start Phase 1** - Implement date selector + connect KPIs to real API
5. **Iterate** - Build each chart component with neon theming

Would you like me to proceed with Phase 1 implementation?