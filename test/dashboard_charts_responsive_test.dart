// Layout regression tests for the responsive dashboard charts.
//
// flutter_test fails the test automatically when a RenderFlex overflow
// ("A RenderFlex overflowed by ... pixels") occurs, so these tests double as
// an overflow guard across phone, tablet and desktop sizes.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/data/models/dashboard_tecnologias.dart';
import 'package:mobile/data/models/dashboard_tendencia.dart';
import 'package:mobile/presentation/dashboard/widgets/charts/neon_donut_chart.dart';
import 'package:mobile/presentation/dashboard/widgets/charts/neon_line_chart.dart';

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
        backend: 4 + i ~/ 2,
        frontend: 3 + i ~/ 3,
        mobile: 2 + i ~/ 4,
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

Future<void> _pumpAtSize(WidgetTester tester, Size logicalSize, Widget child) async {
  tester.view.physicalSize = logicalSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  // Mirror the dashboard structure: full-width ListView with 16px padding.
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [child],
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 150));
}

void main() {
  testWidgets('NeonDonutGrid fits without overflow at multiple sizes',
      (tester) async {
    for (final size in _sizes) {
      await _pumpAtSize(tester, size, NeonDonutGrid(data: _tecnologias()));
      expect(
        tester.takeException(),
        isNull,
        reason: 'NeonDonutGrid overflowed at logical size $size',
      );
    }
  });

  testWidgets('NeonLineChart fits without overflow at multiple sizes',
      (tester) async {
    for (final size in _sizes) {
      await _pumpAtSize(tester, size, NeonLineChart(data: _tendencia()));
      expect(
        tester.takeException(),
        isNull,
        reason: 'NeonLineChart overflowed at logical size $size',
      );
    }
  });
}
