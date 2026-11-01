// Interaction tests for the responsive activity heatmap.
//
// Cells must not render numbers (color intensity only); the detail is shown in
// a fixed row when a cell is tapped (mobile) or hovered (desktop/web).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/data/models/dashboard_actividad.dart';
import 'package:mobile/presentation/dashboard/widgets/charts/neon_heatmap.dart';

/// 7 days × 24 hours with a value derived from the position, so each cell has a
/// predictable total: `(day * 24 + hour) % 6`.
DashboardActividad _actividad() => DashboardActividad(
  total: 168,
  heatmap: [
    for (var day = 0; day < 7; day++)
      for (var hour = 0; hour < 24; hour++)
        HeatmapPoint(dia: day, hora: hour, total: (day * 24 + hour) % 6),
  ],
);

Future<void> _pump(
  WidgetTester tester, {
  Size size = const Size(360, 800),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [NeonHeatmap(data: _actividad())],
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 200));
}

void main() {
  testWidgets('renders all 168 cells without numeric labels', (tester) async {
    await _pump(tester);

    // One gesture detector per cell.
    expect(find.byType(GestureDetector), findsNWidgets(168));

    // No cell contains a Text child (values are color-only).
    expect(
      find.descendant(
        of: find.byType(GestureDetector),
        matching: find.byType(Text),
      ),
      findsNothing,
    );

    // Hint row is visible until a cell is selected.
    expect(find.textContaining('Toca o pasa el cursor'), findsOneWidget);
    expect(
      find.textContaining('generaciones'),
      findsOneWidget,
    ); // subtitle only
  });

  testWidgets('tapping a cell shows its detail and tapping again clears it', (
    tester,
  ) async {
    await _pump(tester);

    // Cell index = day * 24 + hour → day 2 (Miércoles), hour 14.
    // value = (2 * 24 + 14) % 6 = 2.
    await tester.tap(find.byType(GestureDetector).at(2 * 24 + 14));
    await tester.pumpAndSettle();

    expect(find.text('Miércoles 14:00'), findsOneWidget);
    expect(find.text('2 generaciones'), findsOneWidget);
    expect(find.textContaining('Toca o pasa el cursor'), findsNothing);

    await tester.tap(find.byType(GestureDetector).at(2 * 24 + 14));
    await tester.pumpAndSettle();

    expect(find.text('Miércoles 14:00'), findsNothing);
    expect(find.textContaining('Toca o pasa el cursor'), findsOneWidget);
  });

  testWidgets('selecting another cell replaces the detail', (tester) async {
    await _pump(tester);

    // Day 6 (Domingo), hour 0 → value = 144 % 6 = 0.
    await tester.tap(find.byType(GestureDetector).at(6 * 24));
    await tester.pumpAndSettle();
    expect(find.text('Domingo 00:00'), findsOneWidget);
    expect(find.text('0 generaciones'), findsOneWidget);

    // Day 0 (Lunes), hour 9 → value = 9 % 6 = 3.
    await tester.tap(find.byType(GestureDetector).at(9));
    await tester.pumpAndSettle();
    expect(find.text('Lunes 09:00'), findsOneWidget);
    expect(find.text('3 generaciones'), findsOneWidget);
    expect(find.text('Domingo 00:00'), findsNothing);
  });

  testWidgets('the grid fits a 320 px phone without horizontal scrolling', (
    tester,
  ) async {
    await _pump(tester, size: const Size(320, 720));

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsNothing);
    expect(find.byType(GestureDetector), findsNWidgets(168));
  });
}
