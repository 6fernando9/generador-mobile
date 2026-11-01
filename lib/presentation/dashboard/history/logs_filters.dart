// Estado de filtros del historial personal de generaciones.
import 'package:flutter/foundation.dart';
import 'package:mobile/data/models/dashboard_tecnologias.dart';
import 'package:mobile/data/models/log_models.dart';

/// Dimensiones filtrables de `/logs/mis-logs`.
enum LogsFiltroCampo {
  tipoArtefacto(
    queryKey: 'tipo_artefacto_id',
    label: 'Artefacto',
    categoria: TecnologiaCategoria.tiposArtefacto,
  ),
  lenguaje(
    queryKey: 'lenguaje_id',
    label: 'Lenguaje',
    categoria: TecnologiaCategoria.lenguajes,
  ),
  framework(
    queryKey: 'framework_id',
    label: 'Framework',
    categoria: TecnologiaCategoria.frameworks,
  ),
  arquitectura(
    queryKey: 'arquitectura_id',
    label: 'Arquitectura',
    categoria: TecnologiaCategoria.arquitecturas,
  ),
  orm(queryKey: 'orm_id', label: 'ORM', categoria: TecnologiaCategoria.orms),
  baseDatos(
    queryKey: 'base_datos_id',
    label: 'Base de Datos',
    categoria: TecnologiaCategoria.basesDatos,
  ),
  tipoReporte(
    queryKey: 'tipo_reporte_id',
    label: 'Tipo de Reporte',
    categoria: TecnologiaCategoria.tiposReporte,
  ),
  tipoXml(
    queryKey: 'tipo_xml_id',
    label: 'Formato XML',
    categoria: TecnologiaCategoria.tiposXml,
  );

  const LogsFiltroCampo({
    required this.queryKey,
    required this.label,
    required this.categoria,
  });

  final String queryKey;
  final String label;
  final TecnologiaCategoria categoria;
}

extension LogFilterOptionsX on LogFilterOptions {
  List<LogDimensionRef> itemsDe(LogsFiltroCampo campo) => switch (campo) {
    LogsFiltroCampo.tipoArtefacto => tiposArtefacto,
    LogsFiltroCampo.lenguaje => lenguajes,
    LogsFiltroCampo.framework => frameworks,
    LogsFiltroCampo.arquitectura => arquitecturas,
    LogsFiltroCampo.orm => orms,
    LogsFiltroCampo.baseDatos => basesDatos,
    LogsFiltroCampo.tipoReporte => tiposReporte,
    LogsFiltroCampo.tipoXml => tiposXml,
  };
}

/// Tamaño de página fijo del historial.
const int kLogsPerPage = 10;

const Object _sinCambio = Object();

/// Filtros aplicados a la consulta paginada.
@immutable
class LogsFiltros {
  const LogsFiltros({
    this.page = 1,
    this.search = '',
    this.tipoArtefactoId,
    this.lenguajeId,
    this.frameworkId,
    this.arquitecturaId,
    this.ormId,
    this.baseDatosId,
    this.tipoReporteId,
    this.tipoXmlId,
    this.versionGenerador = '',
    this.desde,
    this.hasta,
  });

  final int page;
  final String search;
  final int? tipoArtefactoId;
  final int? lenguajeId;
  final int? frameworkId;
  final int? arquitecturaId;
  final int? ormId;
  final int? baseDatosId;
  final int? tipoReporteId;
  final int? tipoXmlId;
  final String versionGenerador;
  final DateTime? desde;
  final DateTime? hasta;

  int? idDe(LogsFiltroCampo campo) => switch (campo) {
    LogsFiltroCampo.tipoArtefacto => tipoArtefactoId,
    LogsFiltroCampo.lenguaje => lenguajeId,
    LogsFiltroCampo.framework => frameworkId,
    LogsFiltroCampo.arquitectura => arquitecturaId,
    LogsFiltroCampo.orm => ormId,
    LogsFiltroCampo.baseDatos => baseDatosId,
    LogsFiltroCampo.tipoReporte => tipoReporteId,
    LogsFiltroCampo.tipoXml => tipoXmlId,
  };

  LogsFiltros conFiltro(LogsFiltroCampo campo, int? id) => switch (campo) {
    LogsFiltroCampo.tipoArtefacto => copyWith(tipoArtefactoId: id),
    LogsFiltroCampo.lenguaje => copyWith(lenguajeId: id),
    LogsFiltroCampo.framework => copyWith(frameworkId: id),
    LogsFiltroCampo.arquitectura => copyWith(arquitecturaId: id),
    LogsFiltroCampo.orm => copyWith(ormId: id),
    LogsFiltroCampo.baseDatos => copyWith(baseDatosId: id),
    LogsFiltroCampo.tipoReporte => copyWith(tipoReporteId: id),
    LogsFiltroCampo.tipoXml => copyWith(tipoXmlId: id),
  };

  /// Filtros avanzados activos (sin contar búsqueda ni paginación).
  List<MapEntry<LogsFiltroCampo, int>> get filtrosActivos => [
    for (final campo in LogsFiltroCampo.values)
      if (idDe(campo) != null) MapEntry(campo, idDe(campo)!),
  ];

  bool get tieneRango => desde != null || hasta != null;
  bool get tieneVersion => versionGenerador.trim().isNotEmpty;
  bool get conFiltrosActivos =>
      filtrosActivos.isNotEmpty || tieneRango || tieneVersion;

  int get totalFiltrosActivos =>
      filtrosActivos.length + (tieneRango ? 1 : 0) + (tieneVersion ? 1 : 0);

  /// Limpia solo los filtros avanzados; conserva la búsqueda.
  LogsFiltros limpiarFiltros() => LogsFiltros(search: search);

  /// Query params que entiende el backend (omite los vacíos).
  Map<String, dynamic> toQuery() {
    final query = <String, dynamic>{'page': page, 'perPage': kLogsPerPage};
    if (search.trim().isNotEmpty) query['search'] = search.trim();
    for (final entry in filtrosActivos) {
      query[entry.key.queryKey] = entry.value;
    }
    if (tieneVersion) query['version_generador'] = versionGenerador.trim();
    if (desde != null) {
      query['created_desde'] = desde!.toUtc().toIso8601String();
    }
    if (hasta != null) {
      query['created_hasta'] = hasta!.toUtc().toIso8601String();
    }
    return query;
  }

  LogsFiltros copyWith({
    int? page,
    String? search,
    Object? tipoArtefactoId = _sinCambio,
    Object? lenguajeId = _sinCambio,
    Object? frameworkId = _sinCambio,
    Object? arquitecturaId = _sinCambio,
    Object? ormId = _sinCambio,
    Object? baseDatosId = _sinCambio,
    Object? tipoReporteId = _sinCambio,
    Object? tipoXmlId = _sinCambio,
    String? versionGenerador,
    Object? desde = _sinCambio,
    Object? hasta = _sinCambio,
    bool reiniciarPagina = true,
  }) {
    return LogsFiltros(
      page: reiniciarPagina ? 1 : (page ?? this.page),
      search: search ?? this.search,
      tipoArtefactoId: identical(tipoArtefactoId, _sinCambio)
          ? this.tipoArtefactoId
          : tipoArtefactoId as int?,
      lenguajeId: identical(lenguajeId, _sinCambio)
          ? this.lenguajeId
          : lenguajeId as int?,
      frameworkId: identical(frameworkId, _sinCambio)
          ? this.frameworkId
          : frameworkId as int?,
      arquitecturaId: identical(arquitecturaId, _sinCambio)
          ? this.arquitecturaId
          : arquitecturaId as int?,
      ormId: identical(ormId, _sinCambio) ? this.ormId : ormId as int?,
      baseDatosId: identical(baseDatosId, _sinCambio)
          ? this.baseDatosId
          : baseDatosId as int?,
      tipoReporteId: identical(tipoReporteId, _sinCambio)
          ? this.tipoReporteId
          : tipoReporteId as int?,
      tipoXmlId: identical(tipoXmlId, _sinCambio)
          ? this.tipoXmlId
          : tipoXmlId as int?,
      versionGenerador: versionGenerador ?? this.versionGenerador,
      desde: identical(desde, _sinCambio) ? this.desde : desde as DateTime?,
      hasta: identical(hasta, _sinCambio) ? this.hasta : hasta as DateTime?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogsFiltros &&
          page == other.page &&
          search == other.search &&
          tipoArtefactoId == other.tipoArtefactoId &&
          lenguajeId == other.lenguajeId &&
          frameworkId == other.frameworkId &&
          arquitecturaId == other.arquitecturaId &&
          ormId == other.ormId &&
          baseDatosId == other.baseDatosId &&
          tipoReporteId == other.tipoReporteId &&
          tipoXmlId == other.tipoXmlId &&
          versionGenerador == other.versionGenerador &&
          desde == other.desde &&
          hasta == other.hasta;

  @override
  int get hashCode => Object.hash(
    page,
    search,
    tipoArtefactoId,
    lenguajeId,
    frameworkId,
    arquitecturaId,
    ormId,
    baseDatosId,
    tipoReporteId,
    tipoXmlId,
    versionGenerador,
    desde,
    hasta,
  );
}
