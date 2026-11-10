import 'package:mobile/data/models/report_models.dart';

/// Consulta adicional que acompaña a un reporte combinado.
class ReportConsultaExtra {
  final String metrica;
  final String? categoria;

  const ReportConsultaExtra({required this.metrica, this.categoria});
}

/// Intención de reporte detectada de forma determinista en el dispositivo.
///
/// El modelo local no interpreta los datos: solo el parser decide qué métrica,
/// categoría y rango se consultan.
class ReportIntent {
  final String metrica;
  final String? categoria;
  final ReportRange rango;
  final String descripcion;

  /// Cuántos elementos mostrar en rankings (top N).
  final int? topN;

  /// Si se debe comparar contra el período inmediatamente anterior.
  final bool comparar;

  /// Métricas adicionales que se responden junto con la principal.
  final List<ReportConsultaExtra> extras;

  const ReportIntent({
    required this.metrica,
    this.categoria,
    required this.rango,
    required this.descripcion,
    this.topN,
    this.comparar = false,
    this.extras = const [],
  });
}

class ReportIntentParser {
  const ReportIntentParser._();

  static const String timezone = 'America/La_Paz';

  static final RegExp _explicitReport = RegExp(
    r'\b(reporte|reportes|estadistica|estadisticas|mis metricas|mi resumen|'
    r'mi actividad|mi tendencia|mi ranking|mis numeros|mis datos|'
    r'cuantas generaciones|cuantos proyectos|cuantas veces genere|'
    r'cuantos diagramas|cuantas diagramaciones|'
    r'lenguajes? mas usados?|frameworks? mas usados?|'
    r'tecnologias? mas usadas?|que lenguajes? use|que frameworks? use|'
    r'resumen de mis|resumen de mi|top de|ranking de)\b',
  );

  static final RegExp _metricWords = RegExp(
    r'\b(generaciones|generacion|diagramas|diagramaciones|proyectos|'
    r'actividad|tendencia|lenguajes?|frameworks?|arquitecturas?|orms?|'
    r'bases? de datos?|tecnologias?|stack)\b',
  );

  static final RegExp _statWords = RegExp(
    r'\b(cuantas|cuantos|cuanta|cuanto|total|totales|mas usado|mas usados|'
    r'mas utilizados?|ranking|top|hoy|ayer|semana|mes|trimestre|ano|periodo|'
    r'promedio|use|utilice|genere|hice|tengo)\b',
  );

  static String _normalize(String input) {
    const withAccents = 'áéíóúüñ';
    const withoutAccents = 'aeiouun';
    var out = input.toLowerCase();
    for (var i = 0; i < withAccents.length; i++) {
      out = out.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return out.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static String? _detectCategory(String text) {
    if (RegExp(r'\b(lenguajes?|lenguaje de programacion)\b').hasMatch(text)) {
      return 'lenguajes';
    }
    if (RegExp(r'\b(frameworks?|librerias?)\b').hasMatch(text)) {
      return 'frameworks';
    }
    if (RegExp(r'\b(arquitecturas?|patrones? de diseno)\b').hasMatch(text)) {
      return 'arquitecturas';
    }
    if (RegExp(r'\b(orms?|mapeo objeto relacional)\b').hasMatch(text)) {
      return 'orm';
    }
    if (RegExp(r'\b(bases? de datos?|bd|gestores? de bases?)\b')
        .hasMatch(text)) {
      return 'bd';
    }
    return null;
  }

  static bool _wantsResumen(String text) => RegExp(
    r'\b(resumen|mi resumen|cuantas generaciones|cuantos proyectos|'
    r'cuantos diagramas|total de generaciones)\b',
  ).hasMatch(text);

  static bool _wantsTendencia(String text) => RegExp(
    r'\b(tendencia|evolucion|serie|linea de tiempo)\b',
  ).hasMatch(text);

  static bool _wantsActividad(String text) => RegExp(
    r'\b(actividad|mapa de calor|heatmap|por hora|dia de la semana)\b',
  ).hasMatch(text);

  static bool _wantsProyectos(String text) => RegExp(
    r'\b(proyectos?|ranking de proyectos|top de proyectos|por proyecto)\b',
  ).hasMatch(text);

  static String _detectMetric(String text, String? category) {
    if (category != null) return 'tecnologias';
    if (RegExp(r'\b(actividad|mapa de calor|heatmap|por hora|por dia|'
            r'dia de la semana)\b')
        .hasMatch(text)) {
      return 'actividad';
    }
    if (RegExp(r'\b(tendencia|evolucion|serie|linea de tiempo)\b')
        .hasMatch(text)) {
      return 'tendencia';
    }
    if (RegExp(r'\b(proyectos?|ranking de proyectos|top de proyectos)\b')
        .hasMatch(text)) {
      return 'proyectos';
    }
    if (RegExp(r'\b(tecnologias?|tecnologia|stack)\b').hasMatch(text)) {
      return 'tecnologias';
    }
    return 'resumen';
  }

  static DateTime _startOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day);

  static DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59, 999);

  static DateTime _addMonths(DateTime date, int months) {
    final target = DateTime(date.year, date.month + months, 1);
    return target;
  }

  static const Map<String, int> _meses = {
    'enero': 1,
    'febrero': 2,
    'marzo': 3,
    'abril': 4,
    'mayo': 5,
    'junio': 6,
    'julio': 7,
    'agosto': 8,
    'septiembre': 9,
    'setiembre': 9,
    'octubre': 10,
    'noviembre': 11,
    'diciembre': 12,
  };

  static ReportRange _detectRange(String text, DateTime now) {
    final today = _startOfDay(now);

    if (RegExp(r'\banteayer\b').hasMatch(text)) {
      final day = today.subtract(const Duration(days: 2));
      return ReportRange(desde: day, hasta: _endOfDay(day), tz: timezone);
    }
    if (RegExp(r'\bayer\b').hasMatch(text)) {
      final day = today.subtract(const Duration(days: 1));
      return ReportRange(desde: day, hasta: _endOfDay(day), tz: timezone);
    }
    if (RegExp(r'\b(hoy|dia de hoy)\b').hasMatch(text)) {
      return ReportRange(desde: today, hasta: now, tz: timezone);
    }

    // Últimos N días / semanas / meses / años.
    final daysMatch = RegExp(
      r'ultimos?\s+(\d{1,3})\s+dias?',
    ).firstMatch(text);
    if (daysMatch != null) {
      final days = int.tryParse(daysMatch.group(1) ?? '') ?? 7;
      return ReportRange(
        desde: today.subtract(Duration(days: days - 1)),
        hasta: now,
        tz: timezone,
      );
    }

    final weeksMatch = RegExp(
      r'ultimas?\s+(\d{1,2})\s+semanas?',
    ).firstMatch(text);
    if (weeksMatch != null) {
      final weeks = int.tryParse(weeksMatch.group(1) ?? '') ?? 4;
      return ReportRange(
        desde: today.subtract(Duration(days: weeks * 7 - 1)),
        hasta: now,
        tz: timezone,
      );
    }

    final monthsMatch = RegExp(
      r'ultimos?\s+(\d{1,2})\s+meses?',
    ).firstMatch(text);
    if (monthsMatch != null) {
      final months = int.tryParse(monthsMatch.group(1) ?? '') ?? 3;
      return ReportRange(
        desde: _addMonths(DateTime(now.year, now.month, 1), -(months - 1)),
        hasta: now,
        tz: timezone,
      );
    }

    final yearsMatch = RegExp(
      r'ultimos?\s+(\d{1,2})\s+anos?',
    ).firstMatch(text);
    if (yearsMatch != null) {
      final years = int.tryParse(yearsMatch.group(1) ?? '') ?? 1;
      return ReportRange(
        desde: DateTime(now.year - (years - 1), 1, 1),
        hasta: now,
        tz: timezone,
      );
    }

    // Los períodos actuales se evalúan antes que los anteriores para que
    // "este mes vs. el mes pasado" tome el mes actual y compare contra el
    // anterior. Un texto que solo dice "mes pasado" sigue funcionando.
    if (RegExp(r'\b(esta semana|semana actual)\b').hasMatch(text)) {
      final monday = today.subtract(Duration(days: today.weekday - 1));
      return ReportRange(desde: monday, hasta: now, tz: timezone);
    }
    if (RegExp(r'\b(semana pasada|ultima semana)\b').hasMatch(text)) {
      final monday = today.subtract(Duration(days: today.weekday - 1));
      final previousMonday = monday.subtract(const Duration(days: 7));
      final previousSunday = monday.subtract(const Duration(days: 1));
      return ReportRange(
        desde: previousMonday,
        hasta: _endOfDay(previousSunday),
        tz: timezone,
      );
    }

    if (RegExp(r'\b(este trimestre|trimestre actual)\b').hasMatch(text)) {
      return ReportRange(
        desde: DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 1, 1),
        hasta: now,
        tz: timezone,
      );
    }
    if (RegExp(r'\b(trimestre pasado|ultimo trimestre)\b').hasMatch(text)) {
      final firstThisQuarter = DateTime(
        now.year,
        ((now.month - 1) ~/ 3) * 3 + 1,
        1,
      );
      final lastPreviousQuarter = firstThisQuarter.subtract(
        const Duration(days: 1),
      );
      final firstPreviousQuarter = DateTime(
        lastPreviousQuarter.year,
        ((lastPreviousQuarter.month - 1) ~/ 3) * 3 + 1,
        1,
      );
      return ReportRange(
        desde: firstPreviousQuarter,
        hasta: _endOfDay(lastPreviousQuarter),
        tz: timezone,
      );
    }

    if (RegExp(r'\b(este ano|ano actual)\b').hasMatch(text)) {
      return ReportRange(
        desde: DateTime(now.year, 1, 1),
        hasta: now,
        tz: timezone,
      );
    }
    if (RegExp(r'\b(ano pasado|ultimo ano)\b').hasMatch(text)) {
      return ReportRange(
        desde: DateTime(now.year - 1, 1, 1),
        hasta: _endOfDay(DateTime(now.year - 1, 12, 31)),
        tz: timezone,
      );
    }

    if (RegExp(r'\b(este mes|mes actual)\b').hasMatch(text)) {
      return ReportRange(
        desde: DateTime(now.year, now.month, 1),
        hasta: now,
        tz: timezone,
      );
    }
    if (RegExp(r'\b(mes pasado|ultimo mes)\b').hasMatch(text)) {
      final firstThisMonth = DateTime(now.year, now.month, 1);
      final lastPreviousMonth = firstThisMonth.subtract(const Duration(days: 1));
      final firstPreviousMonth = DateTime(
        lastPreviousMonth.year,
        lastPreviousMonth.month,
        1,
      );
      return ReportRange(
        desde: firstPreviousMonth,
        hasta: _endOfDay(lastPreviousMonth),
        tz: timezone,
      );
    }

    // Mes concreto: "en marzo", "marzo de 2025", "de enero".
    for (final entry in _meses.entries) {
      final match = RegExp(
        '\\b(?:de\\s+|en\\s+)?${entry.key}(?:\\s+de\\s+(\\d{4}))?\\b',
      ).firstMatch(text);
      if (match == null) continue;
      final year = int.tryParse(match.group(1) ?? '') ?? now.year;
      final month = entry.value;
      final desde = DateTime(year, month, 1);
      final hasta = DateTime(year, month + 1, 1)
          .subtract(const Duration(milliseconds: 1));
      return ReportRange(
        desde: desde,
        hasta: _endOfDay(hasta),
        tz: timezone,
      );
    }

    // Mismo rango por defecto del backend: últimos 29 días.
    return ReportRange(
      desde: today.subtract(const Duration(days: 29)),
      hasta: now,
      tz: timezone,
    );
  }

  static int? _detectTopN(String text) {
    final match = RegExp(
      r'\btop\s*(\d{1,2})\b',
    ).firstMatch(text);
    if (match != null) return int.tryParse(match.group(1) ?? '');

    final segundo = RegExp(
      r'\b(\d{1,2})\s+(?:primeros?|mejores?|mas usados?|mas utilizados?)\b',
    ).firstMatch(text);
    return int.tryParse(segundo?.group(1) ?? '');
  }

  static bool _detectComparar(String text) => RegExp(
    r'\b(compar\w*|vs\.?|versus|respecto|diferencia|variacion|'
    r'frente al? (?:periodo )?anterior)\b',
  ).hasMatch(text);

  static String _describe(
    String metrica,
    String? categoria,
    ReportRange range,
    List<ReportConsultaExtra> extras,
  ) {
    final tech = switch (categoria) {
      'lenguajes' => 'Lenguajes más usados',
      'frameworks' => 'Frameworks más usados',
      'arquitecturas' => 'Arquitecturas más usadas',
      'orm' => 'ORM más usados',
      'bd' => 'Bases de datos más usadas',
      _ => 'Tecnologías más usadas',
    };
    final base = switch (metrica) {
      'resumen' => 'Resumen de generaciones',
      'tecnologias' => tech,
      'actividad' => 'Actividad de generaciones',
      'tendencia' => 'Tendencia de generaciones',
      'proyectos' => 'Ranking de proyectos',
      _ => 'Reporte',
    };
    final extra = extras.isEmpty
        ? ''
        : ' + ${extras.map((e) {
            if (e.categoria != null) {
              return switch (e.categoria) {
                'lenguajes' => 'lenguajes',
                'frameworks' => 'frameworks',
                'arquitecturas' => 'arquitecturas',
                'orm' => 'ORM',
                'bd' => 'bases de datos',
                _ => 'tecnologías',
              };
            }
            return e.metrica;
          }).join(' + ')}';
    return '$base$extra · ${range.etiqueta}';
  }

  /// Devuelve `null` cuando el mensaje no es una solicitud de reporte.
  static ReportIntent? parse(String message, {DateTime? now}) {
    final text = _normalize(message);
    if (text.isEmpty) return null;

    final explicit = _explicitReport.hasMatch(text);
    final metricWord = _metricWords.hasMatch(text);
    final statWord = _statWords.hasMatch(text);
    final hasGenerationPeriod =
        RegExp(r'\b(generaciones|diagramas)\b').hasMatch(text) &&
        RegExp(r'\b(hoy|ayer|semana|mes|trimestre|ano|total|cuantas|cuantos)\b')
            .hasMatch(text);
    final hasTop = RegExp(r'\btop\s*\d{1,2}\b').hasMatch(text);

    if (!explicit &&
        !(metricWord && statWord) &&
        !hasGenerationPeriod &&
        !hasTop) {
      return null;
    }

    final category = _detectCategory(text);
    final wantsResumen = _wantsResumen(text);

    String metrica;
    final extras = <ReportConsultaExtra>[];

    if (wantsResumen) {
      metrica = 'resumen';
      if (category != null) {
        extras.add(ReportConsultaExtra(metrica: 'tecnologias', categoria: category));
      }
      if (_wantsTendencia(text)) {
        extras.add(const ReportConsultaExtra(metrica: 'tendencia'));
      }
      if (_wantsActividad(text)) {
        extras.add(const ReportConsultaExtra(metrica: 'actividad'));
      }
      if (_wantsProyectos(text)) {
        extras.add(const ReportConsultaExtra(metrica: 'proyectos'));
      }
    } else {
      metrica = _detectMetric(text, category);
    }

    final range = _detectRange(text, now ?? DateTime.now());

    return ReportIntent(
      metrica: metrica,
      categoria: category,
      rango: range,
      descripcion: _describe(metrica, category, range, extras),
      topN: _detectTopN(text),
      comparar: _detectComparar(text),
      extras: extras,
    );
  }
}
