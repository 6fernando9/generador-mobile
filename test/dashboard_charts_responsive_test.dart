// Layout regression tests for the responsive dashboard charts.
//
// flutter_test fails the test automatically when a RenderFlex overflow
// ("A RenderFlex overflowed by ... pixels") occurs, so these tests double as
// an overflow guard across phone, tablet and desktop sizes.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/data/models/dashboard_catalogos.dart';
import 'package:mobile/data/models/dashboard_resumen.dart';
import 'package:mobile/data/models/dashboard_tecnologias.dart';
import 'package:mobile/data/models/dashboard_tendencia.dart';
import 'package:mobile/presentation/dashboard/dashboard_providers.dart';
import 'package:mobile/presentation/dashboard/widgets/charts/neon_donut_chart.dart';
import 'package:mobile/presentation/dashboard/widgets/charts/neon_line_chart.dart';
import 'package:mobile/presentation/dashboard/widgets/kpi_card_row.dart';
import 'package:mobile/presentation/dashboard/widgets/tecnologias_section.dart';

DashboardResumen _resumen() => const DashboardResumen(
  hoy: 2,
  ayer: 0,
  semana: 66,
  semanaPasada: 11,
  mes: 2,
  mesPasado: 0,
  total: 77,
  deltas: Deltas(semana: 500),
);

DashboardTecnologias _tecnologias() {
  List<TechItem> items(int n) => List.generate(
    n,
    (i) => TechItem(
      id: i,
      nombre: 'Tecnología $i',
      nombreCode: 'tech_$i',
      total: 50 - i * 5,
      porcentaje: 20.0 - i * 3,
    ),
  );

  return DashboardTecnologias(
    total: 100,
    lenguajes: items(5),
    frameworks: items(6), // more than maxItems forces the "Otros" grouping
    arquitecturas: items(3),
    orms: items(4),
    basesDatos: items(2),
    tiposArtefacto: items(6),
  );
}

DashboardTendencia _tendencia() {
  return DashboardTendencia(
    total: 200,
    granularidad: 'dia',
    serie: List.generate(
      14,
      (i) => TimeSeriesPoint(
        periodo: DateTime(2026, 1, 1 + i).toIso8601String(),
        total: 10 + i,
        porTipo: {
          'backend': 4 + i ~/ 2,
          'frontend': 3 + i ~/ 3,
          'mobile': 2 + i ~/ 4,
          'reporte': 1 + i ~/ 5,
        },
      ),
    ),
  );
}

/// Logical sizes covering phone, tablet and desktop breakpoints.
const List<Size> _sizes = <Size>[
  Size(360, 800), // small Android phone
  Size(390, 844), // iPhone 12+
  Size(414, 896), // large phone
  Size(600, 900), // small tablet (breakpoint)
  Size(768, 1024), // tablet
  Size(1024, 768), // small desktop window
  Size(1280, 900), // desktop
  Size(1600, 1000), // large desktop
];

Future<void> _pumpAtSize(
  WidgetTester tester,
  Size logicalSize,
  Widget child,
) async {
  tester.view.physicalSize = logicalSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  // Mirror the dashboard structure: full-width ListView with 16px padding.
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: ListView(padding: const EdgeInsets.all(16), children: [child]),
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 150));
}

void main() {
  testWidgets('NeonDonutGrid fits without overflow at multiple sizes', (
    tester,
  ) async {
    for (final size in _sizes) {
      await _pumpAtSize(tester, size, NeonDonutGrid(data: _tecnologias()));
      expect(
        tester.takeException(),
        isNull,
        reason: 'NeonDonutGrid overflowed at logical size $size',
      );
    }
  });

  testWidgets('NeonLineChart fits without overflow at multiple sizes', (
    tester,
  ) async {
    for (final size in _sizes) {
      await _pumpAtSize(tester, size, NeonLineChart(data: _tendencia()));
      expect(
        tester.takeException(),
        isNull,
        reason: 'NeonLineChart overflowed at logical size $size',
      );
    }
  });

  testWidgets('TecnologiasSection fits without overflow at multiple sizes', (
    tester,
  ) async {
    final data = _tecnologias();
    final catalog = DashboardCatalogos(
      lenguajes: data.lenguajes,
      frameworks: data.frameworks,
      arquitecturas: data.arquitecturas,
      orms: data.orms,
      basesDatos: data.basesDatos,
      tiposArtefacto: data.tiposArtefacto,
    );

    for (final size in _sizes) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardTecnologiasAutoProvider.overrideWith((ref) async => data),
            dashboardCatalogosProvider.overrideWith((ref) async => catalog),
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
      await tester.pump(const Duration(milliseconds: 200));

      expect(
        tester.takeException(),
        isNull,
        reason: 'TecnologiasSection overflowed at logical size $size',
      );
    }
  });

  testWidgets('KpiCardRow fits without overflow at multiple sizes', (
    tester,
  ) async {
    for (final size in _sizes) {
      await _pumpAtSize(tester, size, KpiCardRow(resumen: _resumen()));
      expect(
        tester.takeException(),
        isNull,
        reason: 'KpiCardRow overflowed at logical size $size',
      );
    }
  });

  testWidgets('KpiCardRow fits with large text scale', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.4;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    for (final size in _sizes) {
      await _pumpAtSize(tester, size, KpiCardRow(resumen: _resumen()));
      expect(
        tester.takeException(),
        isNull,
        reason: 'KpiCardRow overflowed with textScale 1.4 at $size',
      );
    }
  });
}
