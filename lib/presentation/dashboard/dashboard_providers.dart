// Dashboard Providers - Riverpod state management for dashboard data
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/services/dashboard_service.dart';
import 'package:mobile/data/models/dashboard_actividad.dart';
import 'package:mobile/data/models/dashboard_proyectos.dart';
import 'package:mobile/data/models/dashboard_resumen.dart';
import 'package:mobile/data/models/dashboard_tecnologias.dart';
import 'package:mobile/data/models/dashboard_tendencia.dart';

// Service provider
final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return DashboardService();
});

// Date range selection
enum DateRangePreset {
  today('today', 'Hoy', Icons.today_rounded),
  week('week', 'Esta Semana', Icons.date_range_rounded),
  month('month', 'Este Mes', Icons.calendar_month_rounded),
  quarter('quarter', 'Este Trimestre', Icons.calendar_view_month_rounded),
  year('year', 'Este Año', Icons.event_rounded),
  custom('custom', 'Personalizado', Icons.tune_rounded);

  const DateRangePreset(this.value, this.label, this.icon);

  final String value;
  final String label;
  final IconData icon;
}

/// Notifier for date range selection
class DateRangeNotifier extends Notifier<DateRangePreset> {
  @override
  DateRangePreset build() => DateRangePreset.month;

  void setPreset(DateRangePreset preset) => state = preset;
}

/// Notifier for dashboard timezone
class DashboardTimezoneNotifier extends Notifier<String> {
  @override
  String build() => 'America/La_Paz';

  void setTimezone(String tz) => state = tz;
}

final dateRangeProvider = NotifierProvider<DateRangeNotifier, DateRangePreset>(() => DateRangeNotifier());

// Timezone provider (defaults to America/La_Paz as per backend)
final dashboardTimezoneProvider = NotifierProvider<DashboardTimezoneNotifier, String>(() => DashboardTimezoneNotifier());

// Individual data providers
final dashboardResumenProvider = FutureProvider.family<DashboardResumen, String>((ref, tz) async {
  return await ref.read(dashboardServiceProvider).getResumen(tz: tz);
});

final dashboardTendenciaProvider = FutureProvider.family<DashboardTendencia, String>((ref, tz) async {
  return await ref.read(dashboardServiceProvider).getTendencia(tz: tz);
});

final dashboardTecnologiasProvider = FutureProvider<DashboardTecnologias>((ref) async {
  return await ref.read(dashboardServiceProvider).getTecnologias();
});

final dashboardActividadProvider = FutureProvider.family<DashboardActividad, String>((ref, tz) async {
  return await ref.read(dashboardServiceProvider).getActividad(tz: tz);
});

final dashboardProyectosProvider = FutureProvider<DashboardProyectos>((ref) async {
  return await ref.read(dashboardServiceProvider).getProyectosUsuarios();
});

// Combined provider for initial load (optional, for parallel loading)
final dashboardAllProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, tz) async {
  return await ref.read(dashboardServiceProvider).getAll(tz: tz);
});

// Convenience providers that auto-use current timezone
final dashboardResumenAutoProvider = FutureProvider<DashboardResumen>((ref) async {
  final tz = ref.watch(dashboardTimezoneProvider);
  final dateRange = ref.watch(dateRangeProvider);
  // Pass tz only for relative ranges; today/week/month/quarter/year use backend defaults
  // For 'custom' we'd need start/end dates - TODO: implement custom range
  return await ref.read(dashboardServiceProvider).getResumen(tz: tz);
});

final dashboardTendenciaAutoProvider = FutureProvider<DashboardTendencia>((ref) async {
  final tz = ref.watch(dashboardTimezoneProvider);
  return await ref.read(dashboardServiceProvider).getTendencia(tz: tz);
});

final dashboardActividadAutoProvider = FutureProvider<DashboardActividad>((ref) async {
  final tz = ref.watch(dashboardTimezoneProvider);
  return await ref.read(dashboardServiceProvider).getActividad(tz: tz);
});