// Regression tests for the "Ver todos" technology selector.
//
// The dialog must open with every catalog option checked when there is no
// active filter, because the backend already returns all options by default.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/data/models/dashboard_catalogos.dart';
import 'package:mobile/data/models/dashboard_tecnologias.dart';
import 'package:mobile/presentation/dashboard/dashboard_providers.dart';
import 'package:mobile/presentation/dashboard/widgets/tecnologias_section.dart';

DashboardTecnologias _tecnologias() => DashboardTecnologias(
  total: 100,
  lenguajes: const [
    TechItem(id: 1, nombre: 'Go', nombreCode: 'go', total: 60, porcentaje: 60),
    TechItem(
      id: 2,
      nombre: 'TypeScript',
      nombreCode: 'typescript',
      total: 30,
      porcentaje: 30,
    ),
    TechItem(
      id: 3,
      nombre: 'Dart',
      nombreCode: 'dart',
      total: 10,
      porcentaje: 10,
    ),
  ],
);

DashboardCatalogos _catalogos() =>
    DashboardCatalogos(lenguajes: _tecnologias().lenguajes);

Future<void> _pumpSection(WidgetTester tester) async {
  tester.view.physicalSize = const Size(420, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        dashboardTecnologiasAutoProvider.overrideWith(
          (ref) async => _tecnologias(),
        ),
        dashboardCatalogosProvider.overrideWith((ref) async => _catalogos()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: const [TecnologiasSection()],
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('"Ver todos" opens with every option pre-selected', (
    tester,
  ) async {
    await _pumpSection(tester);

    await tester.tap(find.textContaining('Ver todos'));
    await tester.pumpAndSettle();

    final tiles = tester
        .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
        .toList();
    expect(tiles, hasLength(3));
    expect(tiles.every((tile) => tile.value == true), isTrue);
    expect(find.text('3 de 3 seleccionados'), findsOneWidget);
  });

  testWidgets('Deselecting options keeps the rest checked on reopen', (
    tester,
  ) async {
    await _pumpSection(tester);

    await tester.tap(find.textContaining('Ver todos'));
    await tester.pumpAndSettle();

    // Uncheck "Dart" and apply the filter.
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Dart'));
    await tester.pumpAndSettle();
    expect(find.text('2 de 3 seleccionados'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Aplicar'));
    await tester.pumpAndSettle();

    // Filter active -> label shows the count.
    expect(find.text('Ver todos (2)'), findsOneWidget);

    // Reopen: the two previous options stay selected.
    await tester.tap(find.text('Ver todos (2)'));
    await tester.pumpAndSettle();

    final tiles = tester
        .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
        .toList();
    final seleccionados = tiles.where((tile) => tile.value == true).length;
    expect(seleccionados, 2);
    expect(find.text('2 de 3 seleccionados'), findsOneWidget);
  });

  testWidgets('Marking everything back clears the server-side filter', (
    tester,
  ) async {
    await _pumpSection(tester);

    await tester.tap(find.textContaining('Ver todos'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CheckboxListTile, 'Dart'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Aplicar'));
    await tester.pumpAndSettle();
    expect(find.text('Ver todos (2)'), findsOneWidget);

    await tester.tap(find.text('Ver todos (2)'));
    await tester.pumpAndSettle();

    // "Todos" marks every option again.
    await tester.tap(find.widgetWithText(TextButton, 'Todos'));
    await tester.pumpAndSettle();
    expect(find.text('3 de 3 seleccionados'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Aplicar'));
    await tester.pumpAndSettle();

    // No active filter -> no counter in the button.
    expect(find.text('Ver todos (2)'), findsNothing);
    expect(find.text('Ver todos'), findsOneWidget);
  });
}
