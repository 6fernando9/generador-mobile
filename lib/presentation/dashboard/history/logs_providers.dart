// Providers del historial personal de generaciones.
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/services/logs_service.dart';
import 'package:mobile/data/models/log_models.dart';
import 'package:mobile/presentation/dashboard/history/logs_filters.dart';

final logsServiceProvider = Provider<LogsService>((ref) => LogsService());

/// Filtros activos del historial.
class LogsFiltrosNotifier extends Notifier<LogsFiltros> {
  @override
  LogsFiltros build() => const LogsFiltros();

  void setPage(int page) {
    if (page < 1 || page == state.page) return;
    state = state.copyWith(page: page, reiniciarPagina: false);
  }

  void setSearch(String value) {
    if (value == state.search) return;
    state = state.copyWith(search: value);
  }

  void setFiltro(LogsFiltroCampo campo, int? id) {
    state = state.conFiltro(campo, id);
  }

  void setVersion(String value) {
    if (value == state.versionGenerador) return;
    state = state.copyWith(versionGenerador: value);
  }

  void setRango(DateTimeRange? rango) {
    state = state.copyWith(desde: rango?.start, hasta: rango?.end);
  }

  void aplicar(LogsFiltros filtros) => state = filtros.copyWith();

  void limpiarFiltros() => state = state.limpiarFiltros();
}

final logsFiltrosProvider = NotifierProvider<LogsFiltrosNotifier, LogsFiltros>(
  LogsFiltrosNotifier.new,
);

/// Catálogos de filtros avanzados (se cargan una vez).
final logFilterOptionsProvider = FutureProvider<LogFilterOptions>((ref) async {
  ref.keepAlive();
  return ref.watch(logsServiceProvider).getFilterOptions();
});

/// Página de historial correspondiente a los filtros activos.
final misLogsProvider = FutureProvider<PaginatedLogs>((ref) {
  final filtros = ref.watch(logsFiltrosProvider);
  return ref
      .watch(logsServiceProvider)
      .getMisLogs(
        page: filtros.page,
        perPage: kLogsPerPage,
        search: filtros.search,
        tipoArtefactoId: filtros.tipoArtefactoId,
        lenguajeId: filtros.lenguajeId,
        frameworkId: filtros.frameworkId,
        arquitecturaId: filtros.arquitecturaId,
        ormId: filtros.ormId,
        baseDatosId: filtros.baseDatosId,
        tipoReporteId: filtros.tipoReporteId,
        tipoXmlId: filtros.tipoXmlId,
        versionGenerador: filtros.versionGenerador,
        desde: filtros.desde,
        hasta: filtros.hasta,
      );
});

/// Detalle público de una generación (sin cookie) para el visor y la descarga.
final logDetallePublicoProvider = FutureProvider.family<LogDetalle, String>((
  ref,
  id,
) {
  return ref.watch(logsServiceProvider).getLogDetallePublico(id);
});
