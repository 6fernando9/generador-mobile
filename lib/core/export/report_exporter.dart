import 'dart:convert';
import 'dart:io';

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

/// Exportación de reportes a PDF (con marca Kraken Draw) y CSV (UTF-8 BOM,
/// separador `;`).
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
        header: (context) => _pdfHeader(regular, bold),
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

  static pw.Widget _pdfHeader(pw.Font regular, pw.Font bold) {
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
            width: 34,
            height: 34,
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(
              color: const PdfColor.fromInt(0xFF0B1220),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Text(
              'K',
              style: pw.TextStyle(
                font: bold,
                fontSize: 20,
                color: const PdfColor.fromInt(0xFF00E5FF),
              ),
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
  // CSV
  // ---------------------------------------------------------------------------

  static Future<File> buildCsv(ReportResult result) async {
    final rows = csvRows(result);
    final buffer = StringBuffer('\uFEFF');
    for (final row in rows) {
      buffer.writeln(row.map(_escapeCsv).join(';'));
    }

    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, '${_baseName(result)}.csv'));
    await file.writeAsString(buffer.toString(), encoding: utf8, flush: true);
    return file;
  }

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
        final rows = <List<String>>[
          ['categoria', 'nombre', 'total', 'porcentaje'],
        ];
        for (final categoria in TecnologiaCategoria.values) {
          for (final item in data.itemsDe(categoria)) {
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
        final rows = <List<String>>[['tipo', 'clave', 'total']];
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

  static String _escapeCsv(String value) {
    if (value.contains(';') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
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
