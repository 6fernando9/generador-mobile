import 'package:intl/intl.dart';
import 'package:mobile/core/report/report_intent_parser.dart';
import 'package:mobile/data/models/dashboard_actividad.dart';
import 'package:mobile/data/models/dashboard_proyectos.dart';
import 'package:mobile/data/models/dashboard_resumen.dart';
import 'package:mobile/data/models/dashboard_tecnologias.dart';
import 'package:mobile/data/models/dashboard_tendencia.dart';
import 'package:mobile/data/models/report_models.dart';

/// Convierte el payload crudo del backend en una respuesta legible.
///
/// Es determinista: el modelo local nunca calcula ni inventa cifras.
class ReportFormatter {
  const ReportFormatter._();

  static final DateFormat _fechaHora = DateFormat('dd/MM/yyyy HH:mm');

  static String _pct(double value) {
    final normalized = value <= 1 ? value * 100 : value;
    return '${normalized.toStringAsFixed(1)}%';
  }

  static String _plural(int n, String singular, String plural) =>
      '$n ${n == 1 ? singular : plural}';

  static String sello({
    required ReporteConsulta reporte,
    required bool desdeCache,
  }) {
    return desdeCache
        ? 'Datos al ${_fechaHora.format(reporte.generadoEn)} '
              '(guardados sin conexión).'
        : 'Generado el ${_fechaHora.format(reporte.generadoEn)} '
              'para ${reporte.rango.etiqueta}.';
  }

  static String build({
    required ReportIntent intent,
    required ReporteConsulta reporte,
    required bool desdeCache,
    ReporteConsulta? anterior,
    bool incluirSello = true,
  }) {
    var body = switch (intent.metrica) {
      'resumen' => _resumen(reporte.payload),
      'tecnologias' => _tecnologias(
        reporte.payload,
        intent.categoria,
        intent.topN ?? 5,
      ),
      'actividad' => _actividad(reporte.payload),
      'tendencia' => _tendencia(reporte.payload),
      'proyectos' => _proyectos(reporte.payload, intent.topN ?? 5),
      _ => 'No pude interpretar ese reporte.',
    };

    if (anterior != null && intent.metrica != 'resumen') {
      final comparacion = _comparacion(reporte.payload, anterior.payload);
      if (comparacion != null) {
        body = '$body\n$comparacion';
      }
    }

    if (!incluirSello) return body;
    return '$body\n\n${sello(reporte: reporte, desdeCache: desdeCache)}';
  }

  /// Compara el total del período actual con el del período anterior.
  static String? _comparacion(
    Map<String, dynamic> actual,
    Map<String, dynamic> anterior,
  ) {
    final totalActual = _total(actual);
    final totalAnterior = _total(anterior);
    if (totalActual == null || totalAnterior == null) return null;

    final variacion = totalAnterior == 0
        ? (totalActual == 0 ? 0.0 : 100.0)
        : ((totalActual - totalAnterior) / totalAnterior) * 100;

    return 'Comparado con el período anterior: $totalAnterior '
        '${totalAnterior == 1 ? 'generación' : 'generaciones'} '
        '(${variacion >= 0 ? '+' : ''}${variacion.toStringAsFixed(1)}%).';
  }

  static int? _total(Map<String, dynamic> json) {
    final value = json['total'];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

  static String _resumen(Map<String, dynamic> json) {
    final data = DashboardResumen.fromJson(json);
    final buffer = StringBuffer();

    if (data.total == 0) {
      return 'No tienes generaciones registradas todavía.';
    }

    buffer.write(
      'Hoy registraste ${_plural(data.hoy, 'generación', 'generaciones')} '
      'y ayer ${data.ayer}. ',
    );
    buffer.write(
      'Esta semana llevas ${data.semana} '
      '(la semana pasada fueron ${data.semanaPasada}). ',
    );
    buffer.write(
      'Este mes acumulas ${data.mes} '
      '(el mes pasado fueron ${data.mesPasado}). ',
    );
    buffer.write('En total tienes ${data.total} generaciones históricas.');

    final deltas = <String>[];
    if (data.deltas.hoy != null) {
      deltas.add('hoy ${_signed(data.deltas.hoy!)}%');
    }
    if (data.deltas.semana != null) {
      deltas.add('semana ${_signed(data.deltas.semana!)}%');
    }
    if (data.deltas.mes != null) {
      deltas.add('mes ${_signed(data.deltas.mes!)}%');
    }
    if (deltas.isNotEmpty) {
      buffer.write(
        '\nVariación frente al período anterior: ${deltas.join(', ')}.',
      );
    }
    return buffer.toString();
  }

  static String _signed(double value) =>
      '${value >= 0 ? '+' : ''}${value.toStringAsFixed(1)}';

  static String _tecnologias(
    Map<String, dynamic> json,
    String? categoria,
    int topN,
  ) {
    final data = DashboardTecnologias.fromJson(json);
    if (data.total == 0) {
      return 'No hay generaciones en el período consultado, así que todavía '
          'no puedo calcular tecnologías usadas.';
    }

    final categories = categoria == null
        ? const <String>[]
        : categoria.split(',').where((value) => value.isNotEmpty).toList();
    if (categories.isNotEmpty) {
      final lines = <String>[];
      for (final selected in categories) {
        final items = data.itemsDe(_categoria(selected));
        if (items.isEmpty) continue;
        final top = items.take(topN).toList();
        lines.add('${_nombreCategoria(selected)} más usados:');
        for (var i = 0; i < top.length; i++) {
          lines.add(
            '${i + 1}. ${top[i].nombre}: ${top[i].total} '
            '(${_pct(top[i].porcentaje)})',
          );
        }
      }
      if (lines.isEmpty) {
        final names = categories.map(_nombreCategoria).join(' y ');
        return 'No registraste $names en el período consultado.';
      }
      return lines.join('\n');
    }

    final bloques = <String>[];
    for (final cat in const [
      TecnologiaCategoria.lenguajes,
      TecnologiaCategoria.frameworks,
      TecnologiaCategoria.arquitecturas,
      TecnologiaCategoria.orms,
      TecnologiaCategoria.basesDatos,
    ]) {
      final items = data.itemsDe(cat);
      if (items.isEmpty) continue;
      final top = items
          .take(topN.clamp(1, 10))
          .map((item) {
            return '${item.nombre} (${item.total})';
          })
          .join(', ');
      bloques.add('${cat.label}: $top');
    }

    if (bloques.isEmpty) {
      return 'No hay tecnologías registradas en el período consultado.';
    }
    return 'Tecnologías más usadas en el período:\n${bloques.join('\n')}';
  }

  static TecnologiaCategoria _categoria(String code) => switch (code) {
    'lenguajes' => TecnologiaCategoria.lenguajes,
    'frameworks' => TecnologiaCategoria.frameworks,
    'arquitecturas' => TecnologiaCategoria.arquitecturas,
    'orm' || 'orms' => TecnologiaCategoria.orms,
    'bd' || 'bases_datos' => TecnologiaCategoria.basesDatos,
    _ => TecnologiaCategoria.lenguajes,
  };

  static String _nombreCategoria(String code) => switch (code) {
    'lenguajes' => 'Lenguajes',
    'frameworks' => 'Frameworks',
    'arquitecturas' => 'Arquitecturas',
    'orm' || 'orms' => 'ORMs',
    'bd' || 'bases_datos' => 'Bases de datos',
    _ => 'Tecnologías',
  };

  static String _actividad(Map<String, dynamic> json) {
    final data = DashboardActividad.fromJson(json);
    if (data.total == 0) {
      return 'No hay actividad registrada en el período consultado.';
    }

    final buffer = StringBuffer(
      'Total de generaciones en el período: ${data.total}.',
    );

    final dias = [...data.porDiaSemana]
      ..sort((a, b) => b.total.compareTo(a.total));
    final topDias = dias.where((d) => d.total > 0).take(3).toList();
    if (topDias.isNotEmpty) {
      buffer.write(
        '\nDías con más actividad: '
        '${topDias.map((d) => '${d.nombre} (${d.total})').join(', ')}.',
      );
    }

    final horas = [...data.porHora]..sort((a, b) => b.total.compareTo(a.total));
    final topHoras = horas.where((h) => h.total > 0).take(3).toList();
    if (topHoras.isNotEmpty) {
      buffer.write(
        '\nHoras con más actividad: '
        '${topHoras.map((h) => '${h.hora.toString().padLeft(2, '0')}:00 (${h.total})').join(', ')}.',
      );
    }

    return buffer.toString();
  }

  static String _tendencia(Map<String, dynamic> json) {
    final data = DashboardTendencia.fromJson(json);
    if (data.total == 0 || data.serie.isEmpty) {
      return 'No hay generaciones registradas en el período consultado.';
    }

    final serie = data.serie;
    final pico = serie.reduce((a, b) => a.total >= b.total ? a : b);
    final buffer = StringBuffer(
      'Tendencia con granularidad ${data.granularidad.isEmpty ? 'diaria' : data.granularidad}: '
      '${data.total} generaciones en ${_plural(serie.length, 'período', 'períodos')}.',
    );
    buffer.write(
      '\nPrimer período: ${serie.first.periodo} con ${serie.first.total}. '
      'Último: ${serie.last.periodo} con ${serie.last.total}.',
    );
    buffer.write(
      '\nPico: ${pico.periodo} con ${_plural(pico.total, 'generación', 'generaciones')}.',
    );

    final tipos = <String, int>{};
    for (final point in serie) {
      point.porTipo.forEach(
        (key, value) => tipos[key] = (tipos[key] ?? 0) + value,
      );
    }
    if (tipos.isNotEmpty) {
      final ordenados = tipos.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      buffer.write(
        '\nPor tipo: '
        '${ordenados.map((e) => '${e.key} ${e.value}').join(', ')}.',
      );
    }
    return buffer.toString();
  }

  static String _proyectos(Map<String, dynamic> json, int topN) {
    final data = DashboardProyectos.fromJson(json);
    final proyectos = data.proyectos;
    if (proyectos.isEmpty) {
      return 'No hay proyectos con generaciones en el período consultado.';
    }

    final top = proyectos.take(topN.clamp(1, 20)).toList();
    final lines = <String>['Proyectos con más generaciones:'];
    for (var i = 0; i < top.length; i++) {
      final p = top[i];
      lines.add('${i + 1}. ${p.nombre}: ${p.total} (${_pct(p.porcentaje)})');
    }
    return lines.join('\n');
  }
}
