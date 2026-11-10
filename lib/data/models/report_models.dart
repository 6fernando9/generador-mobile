import 'dart:convert';

import 'package:intl/intl.dart';

/// Rango temporal de un reporte. El backend espera ISO-8601 y una zona IANA.
class ReportRange {
  final DateTime desde;
  final DateTime hasta;
  final String tz;

  const ReportRange({
    required this.desde,
    required this.hasta,
    this.tz = 'America/La_Paz',
  });

  String get desdeIso => desde.toUtc().toIso8601String();
  String get hastaIso => hasta.toUtc().toIso8601String();

  /// Clave exacta de caché. No se aproxima: si el rango cambia, no hay caché.
  String cacheKey(String metrica, String? categoria) =>
      '$metrica|${categoria ?? ''}|$desdeIso|$hastaIso|$tz';

  /// Rango inmediatamente anterior de la misma duración (para comparativas).
  ReportRange anterior() {
    final duracion = hasta.difference(desde);
    final hastaAnterior = desde.subtract(const Duration(milliseconds: 1));
    final desdeAnterior = hastaAnterior.subtract(duracion);
    return ReportRange(
      desde: desdeAnterior,
      hasta: hastaAnterior,
      tz: tz,
    );
  }

  String get etiqueta {
    final fmt = DateFormat('dd/MM/yyyy HH:mm');
    return '${fmt.format(desde)} – ${fmt.format(hasta)}';
  }

  Map<String, dynamic> toJson() => {
    'desde': desdeIso,
    'hasta': hastaIso,
    'tz': tz,
  };
}

/// Respuesta de `GET /api/reportes/consultar`.
class ReporteConsulta {
  final String metrica;
  final String? categoria;
  final ReportRange rango;
  final DateTime generadoEn;
  final Map<String, dynamic> payload;

  const ReporteConsulta({
    required this.metrica,
    this.categoria,
    required this.rango,
    required this.generadoEn,
    required this.payload,
  });

  factory ReporteConsulta.fromJson(Map<String, dynamic> json) {
    final rangoJson = json['rango'] as Map<String, dynamic>? ?? const {};
    return ReporteConsulta(
      metrica: json['metrica'] as String? ?? '',
      categoria: json['categoria'] as String?,
      rango: ReportRange(
        desde: DateTime.tryParse(rangoJson['desde'] as String? ?? '') ??
            DateTime.now(),
        hasta: DateTime.tryParse(rangoJson['hasta'] as String? ?? '') ??
            DateTime.now(),
        tz: rangoJson['tz'] as String? ?? 'America/La_Paz',
      ),
      generadoEn:
          DateTime.tryParse(json['generadoEn'] as String? ?? '') ??
          DateTime.now(),
      payload: json['payload'] as Map<String, dynamic>? ?? const {},
    );
  }

  String get cacheKey => rango.cacheKey(metrica, categoria);
}

/// Fila de la tabla `cache_reportes`: payload crudo + fecha de generación.
class CachedReport {
  final String clave;
  final String metrica;
  final String? categoria;
  final ReportRange rango;
  final DateTime generadoEn;
  final DateTime guardadoEn;
  final Map<String, dynamic> payload;

  const CachedReport({
    required this.clave,
    required this.metrica,
    this.categoria,
    required this.rango,
    required this.generadoEn,
    required this.guardadoEn,
    required this.payload,
  });

  factory CachedReport.fromReporte(
    ReporteConsulta reporte, {
    String? clave,
  }) {
    return CachedReport(
      clave: clave ?? reporte.cacheKey,
      metrica: reporte.metrica,
      categoria: reporte.categoria,
      rango: reporte.rango,
      generadoEn: reporte.generadoEn,
      guardadoEn: DateTime.now(),
      payload: reporte.payload,
    );
  }

  ReporteConsulta toReporte() => ReporteConsulta(
    metrica: metrica,
    categoria: categoria,
    rango: rango,
    generadoEn: generadoEn,
    payload: payload,
  );

  Map<String, Object?> toMap() => {
    'clave': clave,
    'metrica': metrica,
    'categoria': categoria,
    'desde': rango.desdeIso,
    'hasta': rango.hastaIso,
    'tz': rango.tz,
    'payload': jsonEncode(payload),
    'generado_en': generadoEn.millisecondsSinceEpoch,
    'guardado_en': guardadoEn.millisecondsSinceEpoch,
  };

  factory CachedReport.fromMap(Map<String, Object?> map) {
    Map<String, dynamic> payload;
    try {
      payload =
          jsonDecode(map['payload'] as String? ?? '{}') as Map<String, dynamic>;
    } catch (_) {
      payload = const {};
    }
    return CachedReport(
      clave: map['clave'] as String,
      metrica: map['metrica'] as String? ?? '',
      categoria: map['categoria'] as String?,
      rango: ReportRange(
        desde: DateTime.tryParse(map['desde'] as String? ?? '') ??
            DateTime.now(),
        hasta: DateTime.tryParse(map['hasta'] as String? ?? '') ??
            DateTime.now(),
        tz: map['tz'] as String? ?? 'America/La_Paz',
      ),
      generadoEn: DateTime.fromMillisecondsSinceEpoch(
        map['generado_en'] as int? ?? 0,
      ),
      guardadoEn: DateTime.fromMillisecondsSinceEpoch(
        map['guardado_en'] as int? ?? 0,
      ),
      payload: payload,
    );
  }
}
