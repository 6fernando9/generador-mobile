import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/report/report_intent_parser.dart';

void main() {
  final ahora = DateTime(2026, 11, 9, 15, 30);

  test('detecta tecnologías y el mes actual', () {
    final intent = ReportIntentParser.parse(
      '¿Cuáles son los lenguajes más usados este mes?',
      now: ahora,
    );

    expect(intent, isNotNull);
    expect(intent!.metrica, 'tecnologias');
    expect(intent.categoria, 'lenguajes');
    expect(intent.rango.desde, DateTime(2026, 11, 1));
  });

  test('detecta ayer como día completo', () {
    final intent = ReportIntentParser.parse(
      '¿Cuántas generaciones hice ayer?',
      now: ahora,
    );

    expect(intent, isNotNull);
    expect(intent!.metrica, 'resumen');
    expect(intent.rango.desde, DateTime(2026, 11, 8));
    expect(intent.rango.hasta.hour, 23);
    expect(intent.rango.hasta.minute, 59);
  });

  test('detecta top N y el trimestre actual', () {
    final intent = ReportIntentParser.parse(
      'Top 10 frameworks de este trimestre',
      now: ahora,
    );

    expect(intent, isNotNull);
    expect(intent!.metrica, 'tecnologias');
    expect(intent.categoria, 'frameworks');
    expect(intent.topN, 10);
    expect(intent.rango.desde, DateTime(2026, 10, 1));
  });

  test('el último trimestre es el trimestre cerrado anterior', () {
    final intent = ReportIntentParser.parse(
      'Top 10 frameworks del último trimestre',
      now: ahora,
    );

    expect(intent, isNotNull);
    expect(intent!.rango.desde, DateTime(2026, 7, 1));
    expect(intent.rango.hasta.month, 9);
    expect(intent.rango.hasta.day, 30);
  });

  test('marca comparación con el período anterior', () {
    final intent = ReportIntentParser.parse(
      'Compara mis generaciones de esta semana con la semana pasada',
      now: ahora,
    );

    expect(intent, isNotNull);
    expect(intent!.comparar, isTrue);
    expect(intent.rango.desde, DateTime(2026, 11, 9));
  });

  test('combina resumen con lenguajes', () {
    final intent = ReportIntentParser.parse(
      'Dame el resumen y los lenguajes más usados este mes',
      now: ahora,
    );

    expect(intent, isNotNull);
    expect(intent!.metrica, 'resumen');
    expect(intent.extras.length, 1);
    expect(intent.extras.first.metrica, 'tecnologias');
    expect(intent.extras.first.categoria, 'lenguajes');
  });

  test('detecta últimos N meses', () {
    final intent = ReportIntentParser.parse(
      'Tecnologías más usadas en los últimos 3 meses',
      now: ahora,
    );

    expect(intent, isNotNull);
    expect(intent!.rango.desde, DateTime(2026, 9, 1));
  });

  test('detecta un mes concreto con año', () {
    final intent = ReportIntentParser.parse(
      '¿Cuántas generaciones hice en diciembre de 2025?',
      now: ahora,
    );

    expect(intent, isNotNull);
    expect(intent!.rango.desde, DateTime(2025, 12, 1));
    expect(intent.rango.hasta.month, 12);
    expect(intent.rango.hasta.day, 31);
  });

  test('no convierte un saludo en reporte', () {
    expect(ReportIntentParser.parse('Hola, ¿cómo estás?', now: ahora), isNull);
  });
}
