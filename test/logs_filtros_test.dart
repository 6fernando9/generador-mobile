// Tests del estado de filtros del historial.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/presentation/dashboard/history/logs_filters.dart';
import 'package:mobile/presentation/dashboard/history/logs_providers.dart';

void main() {
  group('LogsFiltros.toQuery', () {
    test('solo envía page y perPage por defecto', () {
      expect(const LogsFiltros().toQuery(), {'page': 1, 'perPage': 10});
    });

    test('incluye filtros activos y omite los vacíos', () {
      final filtros = LogsFiltros(
        page: 3,
        search: '  kraken  ',
        lenguajeId: 1,
        baseDatosId: 3,
        versionGenerador: '1.0.0',
        desde: DateTime.utc(2026, 1, 1),
        hasta: DateTime.utc(2026, 1, 31, 23, 59, 59),
      );

      final query = filtros.toQuery();

      expect(query['page'], 3);
      expect(query['perPage'], kLogsPerPage);
      expect(query['search'], 'kraken');
      expect(query['lenguaje_id'], 1);
      expect(query['base_datos_id'], 3);
      expect(query['version_generador'], '1.0.0');
      expect(query['created_desde'], '2026-01-01T00:00:00.000Z');
      expect(query['created_hasta'], '2026-01-31T23:59:59.000Z');
      expect(query.containsKey('framework_id'), isFalse);
      expect(query.containsKey('orm_id'), isFalse);
    });
  });

  group('LogsFiltros helpers', () {
    test('cuenta filtros activos', () {
      final filtros = const LogsFiltros(
        lenguajeId: 1,
        frameworkId: 2,
        versionGenerador: '1.0.0',
      );

      expect(filtros.filtrosActivos, hasLength(2));
      expect(filtros.totalFiltrosActivos, 3);
      expect(filtros.conFiltrosActivos, isTrue);
    });

    test('limpiarFiltros conserva la búsqueda', () {
      final limpio = const LogsFiltros(
        search: 'kraken',
        lenguajeId: 1,
      ).limpiarFiltros();

      expect(limpio.search, 'kraken');
      expect(limpio.lenguajeId, isNull);
      expect(limpio.conFiltrosActivos, isFalse);
      expect(limpio.page, 1);
    });

    test('copyWith resetea la página al cambiar filtros', () {
      final filtros = const LogsFiltros(page: 5).copyWith(lenguajeId: 2);
      expect(filtros.page, 1);
      expect(filtros.lenguajeId, 2);
    });

    test('conFiltro(null) elimina el filtro', () {
      final filtros = const LogsFiltros(lenguajeId: 2)
          .conFiltro(LogsFiltroCampo.lenguaje, null);
      expect(filtros.lenguajeId, isNull);
    });
  });

  group('LogsFiltrosNotifier', () {
    late ProviderContainer container;

    setUp(() => container = ProviderContainer());
    tearDown(() => container.dispose());

    test('setSearch reinicia a la primera página', () {
      final notifier = container.read(logsFiltrosProvider.notifier);
      notifier.setPage(4);
      expect(container.read(logsFiltrosProvider).page, 4);

      notifier.setSearch('kraken');

      final estado = container.read(logsFiltrosProvider);
      expect(estado.search, 'kraken');
      expect(estado.page, 1);
    });

    test('setPage cambia la página sin resetearla', () {
      final notifier = container.read(logsFiltrosProvider.notifier);
      notifier.setPage(3);
      expect(container.read(logsFiltrosProvider).page, 3);

      notifier.setPage(0);
      expect(container.read(logsFiltrosProvider).page, 3);
    });

    test('aplicar fija la página en 1', () {
      final notifier = container.read(logsFiltrosProvider.notifier);
      notifier.setPage(5);
      notifier.aplicar(const LogsFiltros(lenguajeId: 2, page: 7));

      final estado = container.read(logsFiltrosProvider);
      expect(estado.page, 1);
      expect(estado.lenguajeId, 2);
    });

    test('setRango permite limpiar el rango', () {
      final notifier = container.read(logsFiltrosProvider.notifier);
      notifier.setRango(
        DateTimeRange(start: DateTime(2026, 1, 1), end: DateTime(2026, 1, 31)),
      );
      expect(container.read(logsFiltrosProvider).tieneRango, isTrue);

      notifier.setRango(null);
      expect(container.read(logsFiltrosProvider).tieneRango, isFalse);
    });
  });
}
