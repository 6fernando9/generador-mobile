import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import 'package:mobile/core/report/report_coordinator.dart';
import 'package:mobile/data/models/dashboard_actividad.dart';
import 'package:mobile/data/models/dashboard_proyectos.dart';
import 'package:mobile/data/models/dashboard_resumen.dart';
import 'package:mobile/data/models/dashboard_tecnologias.dart';
import 'package:mobile/data/models/dashboard_tendencia.dart';

/// Exportación de reportes a PDF y libros Excel con marca Kraken Draw.
class ReportExporter {
  const ReportExporter._();

  static final DateFormat _sello = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _archivo = DateFormat('yyyyMMdd_HHmm');

  static String _baseName(ReportResult result) {
    final metrica = result.intent.categoria == null
        ? result.intent.metrica
        : '${result.intent.metrica}_${result.intent.categoria}';
    return 'kraken_reporte_${metrica}_${_archivo.format(DateTime.now())}';
  }

  // ---------------------------------------------------------------------------
  // PDF
  // ---------------------------------------------------------------------------

  static Future<File> buildPdf({
    required ReportResult result,
    required String username,
  }) async {
    final regular = pw.Font.ttf(
      await _assetBytes('assets/fonts/DroidSans.ttf'),
    );
    final bold = pw.Font.ttf(
      await _assetBytes('assets/fonts/DroidSans-Bold.ttf'),
    );
    final logoBytes = (await _assetBytes('assets/kraken_logo_trans.png')).buffer
        .asUint8List();
    final logo = pw.MemoryImage(logoBytes);

    final doc = pw.Document(
      title: result.intent.descripcion,
      author: 'Kraken Draw',
    );

    final theme = pw.ThemeData.withFont(base: regular, bold: bold);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        theme: theme,
        header: (context) => _pdfHeader(regular, bold, logo),
        footer: (context) => _pdfFooter(context, regular),
        build: (context) => [
          pw.SizedBox(height: 8),
          pw.Text(
            result.intent.descripcion,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: const PdfColor.fromInt(0xFF0B1220),
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            'Usuario: $username',
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.Text(
            'Período: ${result.reporte.rango.etiqueta} '
            '(${result.reporte.rango.tz})',
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.Text(
            result.desdeCache
                ? 'Datos al ${_sello.format(result.reporte.generadoEn)} '
                      '(guardados sin conexión)'
                : 'Generado el ${_sello.format(result.reporte.generadoEn)}',
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 16),
          pw.Divider(color: const PdfColor.fromInt(0xFF00C2D1), thickness: 1),
          pw.SizedBox(height: 12),
          ...result.texto
              .split('\n')
              .where((line) => line.trim().isNotEmpty)
              .map(
                (line) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Text(
                    line,
                    style: const pw.TextStyle(fontSize: 12, lineSpacing: 2),
                  ),
                ),
              ),
          pw.SizedBox(height: 8),
          ..._pdfDataSections(result, regular, bold),
          pw.SizedBox(height: 18),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: const PdfColor.fromInt(0xFFF1F5F9),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Text(
              'Reporte generado por Kraken Draw. Los datos corresponden a tus '
              'métricas personales de generación. Las cifras son calculadas '
              'por el servidor de Kraken Draw; el asistente local solo las '
              'presenta.',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
            ),
          ),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, '${_baseName(result)}.pdf'));
    await file.writeAsBytes(await doc.save(), flush: true);
    return file;
  }

  static Future<ByteData> _assetBytes(String path) => rootBundle.load(path);

  static List<pw.Widget> _pdfDataSections(
    ReportResult result,
    pw.Font regular,
    pw.Font bold,
  ) {
    final rows = csvRows(result);
    final sections = <(String, List<List<String>>)>[];
    if (result.intent.metrica == 'actividad') {
      final labels = {
        'dia_semana': 'Actividad por día',
        'hora': 'Actividad por hora',
        'heatmap': 'Mapa de actividad',
      };
      for (final type in labels.keys) {
        final subset = rows.skip(1).where((row) => row[0] == type).toList();
        if (subset.isNotEmpty) {
          sections.add((
            labels[type]!,
            [
              [
                type == 'dia_semana'
                    ? 'Día'
                    : type == 'hora'
                    ? 'Hora'
                    : 'Día-Hora',
                'Total',
              ],
              for (final row in subset) [row[1], row[2]],
            ],
          ));
        }
      }
    } else if (result.intent.metrica == 'tecnologias') {
      for (final category in TecnologiaCategoria.values) {
        final subset = rows
            .skip(1)
            .where((row) => row[0] == category.apiKey)
            .toList();
        if (subset.isNotEmpty) {
          sections.add((
            category.label,
            [
              ['Nombre', 'Total', 'Porcentaje'],
              for (final row in subset) [row[1], row[2], '${row[3]}%'],
            ],
          ));
        }
      }
    } else {
      sections.add((
        'Datos del reporte',
        [
          for (final row in rows)
            row.map((value) => value.replaceAll('_', ' ')).toList(),
        ],
      ));
    }

    final widgets = <pw.Widget>[];
    final chartRows = _chartRows(result, rows);
    if (chartRows.isNotEmpty) {
      widgets.add(
        pw.Text('Visualización', style: pw.TextStyle(font: bold, fontSize: 14)),
      );
      widgets.add(pw.SizedBox(height: 8));
      widgets.addAll(_barChart(chartRows, regular));
      widgets.add(pw.SizedBox(height: 16));
    }
    for (final (title, tableRows) in sections) {
      widgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8, bottom: 6),
          child: pw.Text(title, style: pw.TextStyle(font: bold, fontSize: 13)),
        ),
      );
      widgets.add(
        pw.TableHelper.fromTextArray(
          headers: tableRows.first,
          data: tableRows.skip(1).toList(),
          headerStyle: pw.TextStyle(
            font: bold,
            fontSize: 9,
            color: PdfColors.white,
          ),
          cellStyle: pw.TextStyle(font: regular, fontSize: 9),
          headerDecoration: const pw.BoxDecoration(
            color: PdfColor.fromInt(0xFF17233A),
          ),
          rowDecoration: const pw.BoxDecoration(
            color: PdfColor.fromInt(0xFFF4F7FA),
          ),
          oddRowDecoration: const pw.BoxDecoration(color: PdfColors.white),
          cellPadding: const pw.EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 5,
          ),
        ),
      );
    }
    return widgets;
  }

  static List<(String, double)> _chartRows(
    ReportResult result,
    List<List<String>> rows,
  ) {
    final metric = result.intent.metrica;
    final candidates = <(String, double)>[];
    if (metric == 'tecnologias' || metric == 'proyectos') {
      final seleccionadas = _categoriasSolicitadas(result.intent.categoria);
      for (final row in rows.skip(1)) {
        if (metric == 'tecnologias' &&
            seleccionadas != null &&
            !seleccionadas.contains(row[0])) {
          continue;
        }
        final name = metric == 'tecnologias' ? row[1] : row[0];
        final value =
            double.tryParse(metric == 'tecnologias' ? row[2] : row[1]) ?? 0;
        if (value > 0) candidates.add((name, value));
      }
      candidates.sort((a, b) => b.$2.compareTo(a.$2));
    } else if (metric == 'actividad') {
      for (final row in rows.skip(1).where((row) => row[0] == 'dia_semana')) {
        candidates.add((row[1], double.tryParse(row[2]) ?? 0));
      }
    } else if (metric == 'tendencia') {
      for (final row in rows.skip(1)) {
        candidates.add((row[0], double.tryParse(row[1]) ?? 0));
      }
      if (candidates.length > 12) {
        return candidates.sublist(candidates.length - 12);
      }
    } else if (metric == 'resumen') {
      for (final row in rows.skip(1).take(7)) {
        candidates.add((
          row[0].replaceAll('_', ' '),
          double.tryParse(row[1]) ?? 0,
        ));
      }
    }
    final limit = metric == 'tecnologias'
        ? (result.intent.topN ?? 5).clamp(1, 50)
        : 10;
    return candidates.where((row) => row.$2 > 0).take(limit).toList();
  }

  static List<pw.Widget> _barChart(
    List<(String, double)> rows,
    pw.Font regular,
  ) {
    final maxValue = rows.map((row) => row.$2).reduce((a, b) => a > b ? a : b);
    return [
      for (final (label, value) in rows)
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 5),
          child: pw.Row(
            children: [
              pw.SizedBox(
                width: 100,
                child: pw.Text(
                  label,
                  maxLines: 1,
                  style: pw.TextStyle(font: regular, fontSize: 8),
                ),
              ),
              pw.Expanded(
                child: pw.Container(
                  height: 11,
                  alignment: pw.Alignment.centerLeft,
                  decoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFFE6EDF4),
                  ),
                  child: pw.Container(
                    width: 360 * value / maxValue,
                    height: 11,
                    color: const PdfColor.fromInt(0xFF00B8C8),
                  ),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.SizedBox(
                width: 34,
                child: pw.Text(
                  value.toStringAsFixed(0),
                  style: pw.TextStyle(font: regular, fontSize: 8),
                ),
              ),
            ],
          ),
        ),
    ];
  }

  static pw.Widget _pdfHeader(
    pw.Font regular,
    pw.Font bold,
    pw.ImageProvider logo,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      margin: const pw.EdgeInsets.only(bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColor.fromInt(0xFFE2E8F0)),
        ),
      ),
      child: pw.Row(
        children: [
          pw.Container(
            width: 38,
            height: 38,
            padding: const pw.EdgeInsets.all(3),
            decoration: pw.BoxDecoration(
              color: const PdfColor.fromInt(0xFF10121D),
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: const PdfColor.fromInt(0xFF00E5FF)),
            ),
            child: pw.ClipRRect(
              horizontalRadius: 5,
              verticalRadius: 5,
              child: pw.Image(logo, fit: pw.BoxFit.contain),
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'KRAKEN DRAW',
                style: pw.TextStyle(
                  font: bold,
                  fontSize: 13,
                  letterSpacing: 1.4,
                  color: const PdfColor.fromInt(0xFF0B1220),
                ),
              ),
              pw.Text(
                'Asistente de reportes',
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 9,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
          pw.Spacer(),
          pw.Text(
            _sello.format(DateTime.now()),
            style: pw.TextStyle(
              font: regular,
              fontSize: 9,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _pdfFooter(pw.Context context, pw.Font regular) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 12),
      child: pw.Text(
        'Kraken Draw · Página ${context.pageNumber} de ${context.pagesCount}',
        style: pw.TextStyle(
          font: regular,
          fontSize: 8,
          color: PdfColors.grey600,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Excel
  // ---------------------------------------------------------------------------

  static Future<File> buildExcel(ReportResult result) async {
    final sheets = <String, List<List<String>>>{
      'Resumen': <List<String>>[
        ['Reporte', result.intent.descripcion],
        ['Métrica', result.intent.metrica],
        ['Categoría', result.intent.categoria ?? 'Todas'],
        ['Período', result.reporte.rango.etiqueta],
        ['Zona horaria', result.reporte.rango.tz],
        ['Generado', _sello.format(result.reporte.generadoEn)],
      ],
      ..._excelSections(result),
    };
    final archive = Archive();
    void add(String name, String content) {
      final bytes = utf8.encode(content);
      archive.addFile(ArchiveFile(name, bytes.length, bytes));
    }

    add('[Content_Types].xml', _contentTypes(sheets.length));
    add('_rels/.rels', _rootRelationships);
    add('xl/workbook.xml', _workbookXml(sheets.keys.toList()));
    add('xl/_rels/workbook.xml.rels', _workbookRelationships(sheets.length));
    var index = 1;
    for (final rows in sheets.values) {
      add('xl/worksheets/sheet$index.xml', _worksheetXml(rows));
      index++;
    }
    final bytes = ZipEncoder().encodeBytes(archive);
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, '${_baseName(result)}.xlsx'));
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static String _xml(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&apos;');

  static String _columnName(int index) {
    var number = index + 1;
    var result = '';
    while (number > 0) {
      final remainder = (number - 1) % 26;
      result = String.fromCharCode(65 + remainder) + result;
      number = (number - 1) ~/ 26;
    }
    return result;
  }

  static String _worksheetXml(List<List<String>> rows) {
    final buffer =
        StringBuffer('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
          ..write(
            '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData>',
          );
    for (var r = 0; r < rows.length; r++) {
      buffer.write('<row r="${r + 1}">');
      for (var c = 0; c < rows[r].length; c++) {
        final value = rows[r][c];
        final ref = '${_columnName(c)}${r + 1}';
        final numeric = num.tryParse(value);
        if (numeric != null) {
          buffer.write('<c r="$ref"><v>$value</v></c>');
        } else {
          buffer.write(
            '<c r="$ref" t="inlineStr"><is><t xml:space="preserve">${_xml(value)}</t></is></c>',
          );
        }
      }
      buffer.write('</row>');
    }
    buffer.write('</sheetData></worksheet>');
    return buffer.toString();
  }

  static String _contentTypes(int count) =>
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
      '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
      '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
      '<Default Extension="xml" ContentType="application/xml"/>'
      '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
      '${List.generate(count, (i) => '<Override PartName="/xl/worksheets/sheet${i + 1}.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>').join()}'
      '</Types>';

  static const String _rootRelationships =
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>'
      '</Relationships>';

  static String _workbookXml(List<String> names) =>
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
      '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><sheets>'
      '${List.generate(names.length, (i) => '<sheet name="${_xml(names[i])}" sheetId="${i + 1}" r:id="rId${i + 1}"/>').join()}'
      '</sheets></workbook>';

  static String _workbookRelationships(int count) =>
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
      '${List.generate(count, (i) => '<Relationship Id="rId${i + 1}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet${i + 1}.xml"/>').join()}'
      '</Relationships>';

  static Map<String, List<List<String>>> _excelSections(ReportResult result) {
    final rows = csvRows(result);
    if (result.intent.metrica == 'tecnologias') {
      final grouped = <String, List<List<String>>>{};
      for (final row in rows.skip(1)) {
        final sheetName = _sheetName(row[0]);
        grouped.putIfAbsent(
          sheetName,
          () => [
            ['Nombre', 'Total', 'Porcentaje'],
          ],
        );
        grouped[sheetName]!.add([row[1], row[2], row[3]]);
      }
      return grouped.isEmpty ? {'Datos': rows} : grouped;
    }
    if (result.intent.metrica == 'actividad') {
      final grouped = <String, List<List<String>>>{};
      for (final row in rows.skip(1)) {
        final name = switch (row[0]) {
          'dia_semana' => 'Días',
          'hora' => 'Horas',
          _ => 'Mapa de calor',
        };
        grouped.putIfAbsent(
          name,
          () => [
            [
              row[0] == 'dia_semana'
                  ? 'Día'
                  : row[0] == 'hora'
                  ? 'Hora'
                  : 'Día-Hora',
              'Total',
            ],
          ],
        );
        grouped[name]!.add([row[1], row[2]]);
      }
      return grouped.isEmpty ? {'Datos': rows} : grouped;
    }
    return {'Datos': rows};
  }

  static String _sheetName(String value) => switch (value) {
    'lenguajes' => 'Lenguajes',
    'frameworks' => 'Frameworks',
    'arquitecturas' => 'Arquitecturas',
    'orms' => 'ORMs',
    'bases_datos' => 'Bases de datos',
    'tipos_artefacto' => 'Artefactos',
    'tipos_reporte' => 'Tipos de reporte',
    'tipos_xml' => 'Formatos XML',
    _ => value,
  };

  /// Filas crudas del reporte: encabezado + datos, sin texto narrativo.
  static List<List<String>> csvRows(ReportResult result) {
    final payload = result.reporte.payload;
    final metrica = result.intent.metrica;

    switch (metrica) {
      case 'resumen':
        final data = DashboardResumen.fromJson(payload);
        return [
          ['metrica', 'valor'],
          ['hoy', '${data.hoy}'],
          ['ayer', '${data.ayer}'],
          ['semana', '${data.semana}'],
          ['semana_pasada', '${data.semanaPasada}'],
          ['mes', '${data.mes}'],
          ['mes_pasado', '${data.mesPasado}'],
          ['total', '${data.total}'],
          ['delta_hoy', '${data.deltas.hoy ?? ''}'],
          ['delta_semana', '${data.deltas.semana ?? ''}'],
          ['delta_mes', '${data.deltas.mes ?? ''}'],
        ];
      case 'tecnologias':
        final data = DashboardTecnologias.fromJson(payload);
        final seleccionadas = _categoriasSolicitadas(result.intent.categoria);
        final rows = <List<String>>[
          ['categoria', 'nombre', 'total', 'porcentaje'],
        ];
        for (final categoria in TecnologiaCategoria.values) {
          if (seleccionadas != null &&
              !seleccionadas.contains(categoria.apiKey)) {
            continue;
          }
          final limite = (result.intent.topN ?? 5).clamp(1, 50);
          for (final item in data.itemsDe(categoria).take(limite)) {
            rows.add([
              categoria.apiKey,
              item.nombre,
              '${item.total}',
              '${item.porcentaje}',
            ]);
          }
        }
        return rows;
      case 'actividad':
        final data = DashboardActividad.fromJson(payload);
        final rows = <List<String>>[
          ['tipo', 'clave', 'total'],
        ];
        for (final dia in data.porDiaSemana) {
          rows.add(['dia_semana', dia.nombre, '${dia.total}']);
        }
        for (final hora in data.porHora) {
          rows.add(['hora', '${hora.hora}', '${hora.total}']);
        }
        for (final punto in data.heatmap) {
          rows.add(['heatmap', '${punto.dia}-${punto.hora}', '${punto.total}']);
        }
        return rows;
      case 'tendencia':
        final data = DashboardTendencia.fromJson(payload);
        final tipos = <String>{};
        for (final point in data.serie) {
          tipos.addAll(point.porTipo.keys);
        }
        final tiposOrdenados = tipos.toList()..sort();
        return [
          ['periodo', 'total', ...tiposOrdenados],
          for (final point in data.serie)
            [
              point.periodo,
              '${point.total}',
              for (final tipo in tiposOrdenados) '${point.valorTipo(tipo)}',
            ],
        ];
      case 'proyectos':
        final data = DashboardProyectos.fromJson(payload);
        return [
          ['proyecto', 'total', 'porcentaje'],
          for (final proyecto in data.proyectos)
            [proyecto.nombre, '${proyecto.total}', '${proyecto.porcentaje}'],
        ];
      default:
        return [
          ['metrica', 'valor'],
          ['desconocido', '0'],
        ];
    }
  }

  static Set<String>? _categoriasSolicitadas(String? categoria) {
    if (categoria == null || categoria.trim().isEmpty) return null;
    return categoria
        .split(',')
        .map(
          (value) => switch (value.trim()) {
            'orm' => 'orms',
            'bd' => 'bases_datos',
            _ => value.trim(),
          },
        )
        .toSet();
  }

  static Future<void> shareFile(File file, {String? subject}) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: subject ?? 'Reporte Kraken Draw',
        text: 'Reporte generado por Kraken Draw',
      ),
    );
  }
}
