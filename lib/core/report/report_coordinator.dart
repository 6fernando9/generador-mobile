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
  final String? cacheClave;
  final ReporteConsulta? anterior;
  final String? textoPersonalizado;

  const ReportResult({
    required this.intent,
    required this.reporte,
    required this.desdeCache,
    this.cacheClave,
    this.anterior,
    this.textoPersonalizado,
  });

  String get texto =>
      textoPersonalizado ??
      ReportFormatter.build(
        intent: intent,
        reporte: reporte,
        desdeCache: desdeCache,
        anterior: anterior,
      );

  /// Texto sin el sello final, para combinar varios reportes en una respuesta.
  String get textoCuerpo => ReportFormatter.build(
    intent: intent,
    reporte: reporte,
    desdeCache: desdeCache,
    anterior: anterior,
    incluirSello: false,
  );

  String get sello => ReportFormatter.sello(
    reporte: reporte,
    desdeCache: desdeCache,
  );

  String get clave => cacheClave ?? reporte.cacheKey;
}

/// Resuelve un reporte en línea y cae a la caché exacta cuando no hay red.
class ReportCoordinator {
  ReportCoordinator({ReportesService? service})
    : _service = service ?? ReportesService();

  final ReportesService _service;

  /// La caché se separa por usuario para que una cuenta no vea reportes de
  /// otra tras cerrar sesión.
  String _clave(String userId, ReportIntent intent, {ReportRange? rango}) {
    final r = rango ?? intent.rango;
    return '$userId|${r.cacheKey(intent.metrica, intent.categoria)}';
  }

  Future<ReportResult> consultar(
    ReportIntent intent, {
    required bool permitido,
    required bool offline,
    required String userId,
  }) async {
    if (!permitido) {
      throw const ReportAccessDeniedException();
    }

    final clave = _clave(userId, intent);

    if (offline) {
      final cached = await LocalDatabase.instance.getReport(clave);
      if (cached == null) {
        throw const ReportOfflineNoCacheException();
      }
      return ReportResult(
        intent: intent,
        reporte: cached.toReporte(),
        desdeCache: true,
        cacheClave: clave,
      );
    }

    try {
      final reporte = await _service.consultar(
        metrica: intent.metrica,
        categoria: intent.categoria,
        rango: intent.rango,
        limite: _limite(intent),
      );
      await LocalDatabase.instance.saveReport(
        CachedReport.fromReporte(reporte, clave: clave),
      );

      ReporteConsulta? anterior;
      if (intent.comparar && intent.metrica != 'resumen') {
        try {
          anterior = await _service.consultar(
            metrica: intent.metrica,
            categoria: intent.categoria,
            rango: intent.rango.anterior(),
            limite: _limite(intent),
          );
        } catch (_) {
          // Una comparativa es opcional: si falla, se entrega el reporte base.
          anterior = null;
        }
      }

      return ReportResult(
        intent: intent,
        reporte: reporte,
        desdeCache: false,
        cacheClave: clave,
        anterior: anterior,
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
          cacheClave: clave,
        );
      }
      rethrow;
    }
  }

  int? _limite(ReportIntent intent) {
    if (intent.topN != null) return intent.topN;
    return intent.metrica == 'proyectos' ? 10 : null;
  }
}
