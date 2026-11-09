import 'package:mobile/data/models/report_models.dart';

/// Intención de reporte detectada de forma determinista en el dispositivo.
///
/// El modelo local no interpreta los datos: solo el parser decide qué métrica,
/// categoría y rango se consultan.
class ReportIntent {
  final String metrica;
  final String? categoria;
  final ReportRange rango;
  final String descripcion;

  const ReportIntent({
    required this.metrica,
    this.categoria,
    required this.rango,
    required this.descripcion,
  });
}

class ReportIntentParser {
  const ReportIntentParser._();

  static const String timezone = 'America/La_Paz';

  static final RegExp _explicitReport = RegExp(
    r'\b(reporte|reportes|estadistica|estadisticas|mis metricas|mi resumen|'
    r'mi actividad|mi tendencia|mi ranking|mis numeros|mis datos|'
    r'cuantas generaciones|cuantos proyectos|cuantas veces genere|'
    r'lenguajes mas usados|frameworks mas usados|'
    r'tecnologias mas usadas|que lenguajes use|que frameworks use|'
    r'resumen de mis|resumen de mi)\b',
  );

  static final RegExp _metricWords = RegExp(
    r'\b(generaciones|generacion|proyectos|actividad|tendencia|lenguajes|'
    r'frameworks|arquitecturas|orms?|bases de datos|tecnologias)\b',
  );

  static final RegExp _statWords = RegExp(
    r'\b(cuantas|cuantos|cuanta|cuanto|total|totales|mas usado|mas usados|'
    r'mas utilizados?|ranking|top|hoy|ayer|semana|mes|periodo|promedio|'
    r'use|utilice|genere|hice|tengo)\b',
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
    if (RegExp(r'\blenguajes?\b').hasMatch(text)) return 'lenguajes';
    if (RegExp(r'\bframeworks?\b').hasMatch(text)) return 'frameworks';
    if (RegExp(r'\barquitecturas?\b').hasMatch(text)) return 'arquitecturas';
    if (RegExp(r'\borms?\b').hasMatch(text)) return 'orm';
    if (RegExp(r'\b(bases? de datos?|bd)\b').hasMatch(text)) return 'bd';
    return null;
  }

  static String _detectMetric(String text, String? category) {
    if (category != null) return 'tecnologias';
    if (RegExp(r'\b(actividad|mapa de calor|heatmap|por hora|por dia|'
            r'dia de la semana)\b')
        .hasMatch(text)) {
      return 'actividad';
    }
    if (RegExp(r'\b(tendencia|evolucion|serie|por dia|linea de tiempo)\b')
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
    if (RegExp(r'\b(esta semana|semana actual|la semana)\b').hasMatch(text)) {
      final monday = today.subtract(Duration(days: today.weekday - 1));
      return ReportRange(desde: monday, hasta: now, tz: timezone);
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
    if (RegExp(r'\b(este mes|mes actual)\b').hasMatch(text)) {
      return ReportRange(
        desde: DateTime(now.year, now.month, 1),
        hasta: now,
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

  static String _describe(String metrica, String? categoria, ReportRange range) {
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
    return '$base · ${range.etiqueta}';
  }

  /// Devuelve `null` cuando el mensaje no es una solicitud de reporte.
  static ReportIntent? parse(String message, {DateTime? now}) {
    final text = _normalize(message);
    if (text.isEmpty) return null;

    final explicit = _explicitReport.hasMatch(text);
    final metricWord = _metricWords.hasMatch(text);
    final statWord = _statWords.hasMatch(text);
    final hasGenerationPeriod =
        RegExp(r'\bgeneraciones\b').hasMatch(text) &&
        RegExp(r'\b(hoy|ayer|semana|mes|total|cuantas|cuantos)\b')
            .hasMatch(text);

    if (!explicit && !(metricWord && statWord) && !hasGenerationPeriod) {
      return null;
    }

    final category = _detectCategory(text);
    final metrica = _detectMetric(text, category);
    final range = _detectRange(text, now ?? DateTime.now());

    return ReportIntent(
      metrica: metrica,
      categoria: category,
      rango: range,
      descripcion: _describe(metrica, category, range),
    );
  }
}
