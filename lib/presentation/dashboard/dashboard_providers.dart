// Dashboard Providers - Riverpod state management for dashboard data
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/services/dashboard_service.dart';
import 'package:mobile/data/models/dashboard_actividad.dart';
import 'package:mobile/data/models/dashboard_catalogos.dart';
import 'package:mobile/data/models/dashboard_proyectos.dart';
import 'package:mobile/data/models/dashboard_resumen.dart';
import 'package:mobile/data/models/dashboard_tecnologias.dart';
import 'package:mobile/data/models/dashboard_tendencia.dart';

// Service provider
final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return DashboardService();
});

// ---------------------------------------------------------------------------
// Date range
// ---------------------------------------------------------------------------

enum DateRangePreset {
  today('today', 'Hoy', Icons.today_rounded),
  week('week', 'Esta Semana', Icons.date_range_rounded),
  month('month', 'Este Mes', Icons.calendar_month_rounded),
  last30('last30', 'Últimos 30 días', Icons.history_rounded),
  quarter('quarter', 'Este Trimestre', Icons.calendar_view_month_rounded),
  year('year', 'Este Año', Icons.event_rounded),
  custom('custom', 'Personalizado', Icons.tune_rounded);

  const DateRangePreset(this.value, this.label, this.icon);

  final String value;
  final String label;
  final IconData icon;
}

/// Rango resuelto que se envía a los endpoints (`desde` / `hasta`).
class DashboardRange {
  final DateTime desde;
  final DateTime hasta;

  const DashboardRange({required this.desde, required this.hasta});
}

/// Notifier for date range selection
class DateRangeNotifier extends Notifier<DateRangePreset> {
  @override
  DateRangePreset build() => DateRangePreset.last30;

  void setPreset(DateRangePreset preset) => state = preset;
}

/// Rango elegido manualmente cuando el preset es [DateRangePreset.custom].
class CustomDateRangeNotifier extends Notifier<DateTimeRange?> {
  @override
  DateTimeRange? build() => null;

  void setRange(DateTimeRange? range) => state = range;
}

/// Notifier for dashboard timezone
class DashboardTimezoneNotifier extends Notifier<String> {
  @override
  String build() => 'America/La_Paz';

  void setTimezone(String tz) => state = tz;
}

final dateRangeProvider = NotifierProvider<DateRangeNotifier, DateRangePreset>(
  DateRangeNotifier.new,
);

final customDateRangeProvider =
    NotifierProvider<CustomDateRangeNotifier, DateTimeRange?>(
      CustomDateRangeNotifier.new,
    );

/// Timezone provider (defaults to America/La_Paz as per backend)
final dashboardTimezoneProvider =
    NotifierProvider<DashboardTimezoneNotifier, String>(
      DashboardTimezoneNotifier.new,
    );

/// Rango concreto (local) derivado del preset seleccionado.
final dashboardRangeProvider = Provider<DashboardRange>((ref) {
  final preset = ref.watch(dateRangeProvider);
  final custom = ref.watch(customDateRangeProvider);
  return _resolverRango(preset, custom);
});

DashboardRange _resolverRango(DateRangePreset preset, DateTimeRange? custom) {
  final now = DateTime.now();
  final hoy = DateTime(now.year, now.month, now.day);

  DateTime inicioSemana() =>
      hoy.subtract(Duration(days: now.weekday - DateTime.monday));

  DateTime inicioMes() => DateTime(now.year, now.month, 1);

  DateTime inicioTrimestre() {
    final mes = ((now.month - 1) ~/ 3) * 3 + 1;
    return DateTime(now.year, mes, 1);
  }

  DateTime finDelDia(DateTime day) =>
      DateTime(day.year, day.month, day.day, 23, 59, 59, 999);

  switch (preset) {
    case DateRangePreset.today:
      return DashboardRange(desde: hoy, hasta: now);
    case DateRangePreset.week:
      return DashboardRange(desde: inicioSemana(), hasta: now);
    case DateRangePreset.month:
      return DashboardRange(desde: inicioMes(), hasta: now);
    case DateRangePreset.last30:
      return DashboardRange(
        desde: hoy.subtract(const Duration(days: 29)),
        hasta: now,
      );
    case DateRangePreset.quarter:
      return DashboardRange(desde: inicioTrimestre(), hasta: now);
    case DateRangePreset.year:
      return DashboardRange(desde: DateTime(now.year, 1, 1), hasta: now);
    case DateRangePreset.custom:
      if (custom == null) {
        return DashboardRange(
          desde: hoy.subtract(const Duration(days: 29)),
          hasta: now,
        );
      }
      return DashboardRange(
        desde: DateTime(
          custom.start.year,
          custom.start.month,
          custom.start.day,
        ),
        hasta: finDelDia(custom.end),
      );
  }
}

// ---------------------------------------------------------------------------
// Data providers
// ---------------------------------------------------------------------------

final dashboardResumenAutoProvider = FutureProvider<DashboardResumen>((
  ref,
) async {
  final tz = ref.watch(dashboardTimezoneProvider);
  return ref.read(dashboardServiceProvider).getResumen(tz: tz);
});

final dashboardTendenciaAutoProvider = FutureProvider<DashboardTendencia>((
  ref,
) async {
  final tz = ref.watch(dashboardTimezoneProvider);
  final range = ref.watch(dashboardRangeProvider);
  return ref
      .read(dashboardServiceProvider)
      .getTendencia(tz: tz, desde: range.desde, hasta: range.hasta);
});

final dashboardCatalogosProvider = FutureProvider<DashboardCatalogos>((
  ref,
) async {
  return ref.read(dashboardServiceProvider).getCatalogos();
});

final dashboardActividadAutoProvider = FutureProvider<DashboardActividad>((
  ref,
) async {
  final tz = ref.watch(dashboardTimezoneProvider);
  final range = ref.watch(dashboardRangeProvider);
  return ref
      .read(dashboardServiceProvider)
      .getActividad(tz: tz, desde: range.desde, hasta: range.hasta);
});

final dashboardProyectosProvider = FutureProvider<DashboardProyectos>((
  ref,
) async {
  final range = ref.watch(dashboardRangeProvider);
  return ref
      .read(dashboardServiceProvider)
      .getMisProyectos(desde: range.desde, hasta: range.hasta);
});

// ---------------------------------------------------------------------------
// Tecnologías: vista (Total/Proyecto/Reporte) + filtros por dimensión
// ---------------------------------------------------------------------------

class TecnologiaVistaNotifier extends Notifier<DashboardTecnologiaVista> {
  @override
  DashboardTecnologiaVista build() => DashboardTecnologiaVista.total;

  void setVista(DashboardTecnologiaVista vista) => state = vista;
}

class TecnologiaCategoriaNotifier extends Notifier<TecnologiaCategoria> {
  @override
  TecnologiaCategoria build() => TecnologiaCategoria.lenguajes;

  void setCategoria(TecnologiaCategoria categoria) => state = categoria;
}

final tecnologiaVistaProvider =
    NotifierProvider<TecnologiaVistaNotifier, DashboardTecnologiaVista>(
      TecnologiaVistaNotifier.new,
    );

final tecnologiaCategoriaProvider =
    NotifierProvider<TecnologiaCategoriaNotifier, TecnologiaCategoria>(
      TecnologiaCategoriaNotifier.new,
    );

/// Filtros por vista y por `apiKey` de categoría.
typedef TecnologiaFiltros =
    Map<DashboardTecnologiaVista, Map<String, Set<int>>>;

class TecnologiaFiltrosNotifier extends Notifier<TecnologiaFiltros> {
  @override
  TecnologiaFiltros build() => {
    for (final vista in DashboardTecnologiaVista.values)
      vista: <String, Set<int>>{},
  };

  Set<int> seleccion(
    DashboardTecnologiaVista vista,
    TecnologiaCategoria categoria,
  ) {
    return state[vista]?[categoria.apiKey] ?? const <int>{};
  }

  void setSeleccion(
    DashboardTecnologiaVista vista,
    TecnologiaCategoria categoria,
    Set<int> ids,
  ) {
    final porVista = Map<String, Set<int>>.from(
      state[vista] ?? <String, Set<int>>{},
    );
    if (ids.isEmpty) {
      porVista.remove(categoria.apiKey);
    } else {
      porVista[categoria.apiKey] = Set<int>.from(ids);
    }
    state = {...state, vista: porVista};
  }

  void limpiar(DashboardTecnologiaVista vista) {
    state = {...state, vista: <String, Set<int>>{}};
  }
}

final tecnologiaFiltrosProvider =
    NotifierProvider<TecnologiaFiltrosNotifier, TecnologiaFiltros>(
      TecnologiaFiltrosNotifier.new,
    );

final dashboardTecnologiasAutoProvider = FutureProvider<DashboardTecnologias>((
  ref,
) async {
  final vista = ref.watch(tecnologiaVistaProvider);
  final filtros = ref.watch(tecnologiaFiltrosProvider);
  final tz = ref.watch(dashboardTimezoneProvider);
  final range = ref.watch(dashboardRangeProvider);

  return ref
      .read(dashboardServiceProvider)
      .getTecnologias(
        vista: vista,
        tz: tz,
        desde: range.desde,
        hasta: range.hasta,
        filtros: filtros[vista] ?? const {},
      );
});
