// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/main.dart';

void main() {
  testWidgets('App loads splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: KrakenDrawApp()));

    // La pantalla de bienvenida se muestra durante 3 segundos antes de
    // navegar a /auth; se comprueba dentro de esa ventana. No se usa
    // pumpAndSettle porque el fondo tiene animaciones continuas.
    await tester.pump(const Duration(milliseconds: 2900));

    expect(find.text('KrakenDraw'), findsOneWidget);

    // Desmontar la pantalla cancela el timer de navegación pendiente.
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
