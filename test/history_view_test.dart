// Tests de integración del historial con un servicio falso.
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/network/services/logs_service.dart';
import 'package:mobile/data/models/common_models.dart';
import 'package:mobile/data/models/log_models.dart';
import 'package:mobile/presentation/dashboard/history/generation_history_view.dart';
import 'package:mobile/presentation/dashboard/history/logs_providers.dart';

LogGeneracion _log(int id) => LogGeneracion(
  id: 'log-$id',
  proyectoId: 'p-$id',
  rolId: 18,
  rolMomentoCode: 'propietario',
  versionGenerador: '1.0.0',
  createdAt: DateTime(2026, 11, 1, 12, id),
  tipoArtefacto: const LogDimensionRef(
    id: 1,
    nombre: 'Backend',
    nombreCode: 'backend',
    icono: 'server',
    iconoTipo: 'icono',
  ),
  proyecto: LogProyectoRef(id: 'p-$id', nombre: 'Proyecto $id'),
);

class _FakeLogsService extends LogsService {
  _FakeLogsService() : super(dio: Dio());

  final List<int> paginasPedidas = [];
  String ultimoSearch = '';

  @override
  Future<PaginatedLogs> getMisLogs({
    int page = 1,
    int perPage = 10,
    String? search,
    int? tipoArtefactoId,
    int? lenguajeId,
    int? frameworkId,
    int? arquitecturaId,
    int? ormId,
    int? baseDatosId,
    int? tipoReporteId,
    int? tipoXmlId,
    String? versionGenerador,
    DateTime? desde,
    DateTime? hasta,
  }) async {
    paginasPedidas.add(page);
    ultimoSearch = search ?? '';
    return PaginatedLogs(
      items: [for (var i = 1; i <= 3; i++) _log((page - 1) * 3 + i)],
      meta: PaginationMeta(
        totalItems: 6,
        totalPages: 2,
        currentPage: page,
        pageSize: perPage,
      ),
    );
  }

  @override
  Future<LogFilterOptions> getFilterOptions() async => const LogFilterOptions();
}

Future<_FakeLogsService> _pump(
  WidgetTester tester, {
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final fake = _FakeLogsService();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [logsServiceProvider.overrideWithValue(fake)],
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(body: GenerationHistoryView()),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return fake;
}

void main() {
  testWidgets('lista las generaciones y muestra la paginación', (tester) async {
    await _pump(tester);

    expect(find.text('Proyecto 1'), findsOneWidget);
    expect(find.text('Proyecto 3'), findsOneWidget);
    expect(find.text('Página 1 de 2'), findsOneWidget);
    expect(find.text('6 registros'), findsOneWidget);
    expect(
      find.widgetWithIcon(IconButton, Icons.visibility_rounded),
      findsNWidgets(3),
    );
  });

  testWidgets('el botón siguiente avanza de página', (tester) async {
    final fake = await _pump(tester);

    await tester.tap(find.byTooltip('Página siguiente'));
    await tester.pumpAndSettle();

    expect(fake.paginasPedidas, [1, 2]);
    expect(find.text('Proyecto 4'), findsOneWidget);
    expect(find.text('Página 2 de 2'), findsOneWidget);
  });

  testWidgets('la búsqueda se aplica con debounce y vuelve a página 1', (
    tester,
  ) async {
    final fake = await _pump(tester);

    await tester.enterText(find.byType(TextFormField), 'kraken');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(fake.ultimoSearch, 'kraken');
    expect(fake.paginasPedidas.last, 1);
  });

  testWidgets('el icono de filtros abre los filtros avanzados', (tester) async {
    await _pump(tester);

    await tester.tap(find.byTooltip('Filtros avanzados'));
    await tester.pumpAndSettle();

    expect(find.text('Filtros avanzados'), findsOneWidget);
    expect(find.text('Versión del generador'), findsOneWidget);
  });

  testWidgets('no desborda en un móvil angosto', (tester) async {
    await _pump(tester, size: const Size(320, 720));

    expect(tester.takeException(), isNull);
  });

  testWidgets('en pantalla ancha los filtros abren un diálogo', (tester) async {
    await _pump(tester, size: const Size(1024, 800));

    await tester.tap(find.byTooltip('Filtros avanzados'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Filtros avanzados'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
