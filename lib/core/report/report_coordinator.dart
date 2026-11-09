import 'package:dio/dio.dart';
import 'package:mobile/core/network/services/reportes_service.dart';
import 'package:mobile/core/report/report_formatter.dart';
import 'package:mobile/core/report/report_intent_parser.dart';
import 'package:mobile/core/storage/local_database.dart';
import 'package:mobile/data/models/report_models.dart';

class ReportAccessDeniedException implements Exception {
  const ReportAccessDeniedException();
}

class ReportOfflineNoCacheException implements Exception {
  const ReportOfflineNoCacheException();
}

class ReportResult {
  final ReportIntent intent;
  final ReporteConsulta reporte;
  final bool desdeCache;

  const ReportResult({
    required this.intent,
    required this.reporte,
    required this.desdeCache,
  });

  String get texto => ReportFormatter.build(
    intent: intent,
    reporte: reporte,
    desdeCache: desdeCache,
  );

  String get clave => reporte.cacheKey;
}

/// Resuelve un reporte en línea y cae a la caché exacta cuando no hay red.
class ReportCoordinator {
  ReportCoordinator({ReportesService? service})
    : _service = service ?? ReportesService();

  final ReportesService _service;

  Future<ReportResult> consultar(
    ReportIntent intent, {
    required bool permitido,
    required bool offline,
  }) async {
    if (!permitido) {
      throw const ReportAccessDeniedException();
    }

    final clave = intent.rango.cacheKey(intent.metrica, intent.categoria);

    if (offline) {
      final cached = await LocalDatabase.instance.getReport(clave);
      if (cached == null) {
        throw const ReportOfflineNoCacheException();
      }
      return ReportResult(
        intent: intent,
        reporte: cached.toReporte(),
        desdeCache: true,
      );
    }

    try {
      final reporte = await _service.consultar(
        metrica: intent.metrica,
        categoria: intent.categoria,
        rango: intent.rango,
        limite: intent.metrica == 'proyectos' ? 10 : null,
      );
      await LocalDatabase.instance.saveReport(
        CachedReport.fromReporte(reporte),
      );
      return ReportResult(
        intent: intent,
        reporte: reporte,
        desdeCache: false,
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 403) {
        throw const ReportAccessDeniedException();
      }
      if (status == 401) rethrow;

      // Fallo de red/servidor: se intenta la caché exacta.
      final cached = await LocalDatabase.instance.getReport(clave);
      if (cached != null) {
        return ReportResult(
          intent: intent,
          reporte: cached.toReporte(),
          desdeCache: true,
        );
      }
      rethrow;
    }
  }
}
