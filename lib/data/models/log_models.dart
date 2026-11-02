// Modelos del historial personal de generaciones (`GET /logs/mis-logs`).
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/data/models/common_models.dart';
import 'package:mobile/data/models/generacion_models.dart'
    show DatabaseConfiguration;

part 'log_models.freezed.dart';
part 'log_models.g.dart';

/// Referencia a una dimensión tecnológica del log.
@freezed
abstract class LogDimensionRef with _$LogDimensionRef {
  const factory LogDimensionRef({
    @Default(0) int id,
    @Default('') String nombre,
    @JsonKey(name: 'nombre_code') @Default('') String nombreCode,
    String? icono,
    @JsonKey(name: 'icono_tipo') String? iconoTipo,
  }) = _LogDimensionRef;

  factory LogDimensionRef.fromJson(Map<String, dynamic> json) =>
      _$LogDimensionRefFromJson(json);
}

@freezed
abstract class LogProyectoRef with _$LogProyectoRef {
  const factory LogProyectoRef({
    @Default('') String id,
    @Default('') String nombre,
  }) = _LogProyectoRef;

  factory LogProyectoRef.fromJson(Map<String, dynamic> json) =>
      _$LogProyectoRefFromJson(json);
}

@freezed
abstract class LogUsuarioRef with _$LogUsuarioRef {
  const factory LogUsuarioRef({
    @Default(0) int id,
    @Default('') String username,
    @JsonKey(name: 'profile_icon') String? profileIcon,
    @JsonKey(name: 'profile_icon_tipo') String? profileIconTipo,
  }) = _LogUsuarioRef;

  factory LogUsuarioRef.fromJson(Map<String, dynamic> json) =>
      _$LogUsuarioRefFromJson(json);
}

/// Una generación registrada en el historial del usuario.
@freezed
abstract class LogGeneracion with _$LogGeneracion {
  const factory LogGeneracion({
    @Default('') String id,
    @JsonKey(name: 'proyecto_id') @Default('') String proyectoId,
    @JsonKey(name: 'usuario_id') @Default(0) int usuarioId,
    @JsonKey(name: 'rol_id') @Default(0) int rolId,
    @JsonKey(name: 'rol_momento_code') @Default('') String rolMomentoCode,
    @JsonKey(name: 'tipo_artefacto_id') int? tipoArtefactoId,
    @JsonKey(name: 'lenguaje_id') int? lenguajeId,
    @JsonKey(name: 'framework_id') int? frameworkId,
    @JsonKey(name: 'arquitectura_id') int? arquitecturaId,
    @JsonKey(name: 'orm_id') int? ormId,
    @JsonKey(name: 'base_datos_id') int? baseDatosId,
    @JsonKey(name: 'tipo_reporte_id') int? tipoReporteId,
    @JsonKey(name: 'tipo_xml_id') int? tipoXmlId,
    @JsonKey(name: 'version_generador') String? versionGenerador,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'tipo_artefacto') LogDimensionRef? tipoArtefacto,
    LogDimensionRef? lenguaje,
    LogDimensionRef? framework,
    LogDimensionRef? arquitectura,
    LogDimensionRef? orm,
    @JsonKey(name: 'base_datos') LogDimensionRef? baseDatos,
    @JsonKey(name: 'tipo_reporte') LogDimensionRef? tipoReporte,
    @JsonKey(name: 'tipo_xml') LogDimensionRef? tipoXml,
    LogProyectoRef? proyecto,
    LogUsuarioRef? usuario,
  }) = _LogGeneracion;

  factory LogGeneracion.fromJson(Map<String, dynamic> json) =>
      _$LogGeneracionFromJson(json);
}

extension LogGeneracionX on LogGeneracion {
  /// Nombre del proyecto con fallback cuando el backend no lo incluye.
  String get proyectoNombre {
    final nombre = proyecto?.nombre.trim() ?? '';
    return nombre.isEmpty ? 'Proyecto sin nombre' : nombre;
  }

  /// Dimensiones presentes, en el orden en que se muestran como chips.
  List<LogDimensionRef> get dimensiones => [
    tipoArtefacto,
    lenguaje,
    framework,
    arquitectura,
    orm,
    baseDatos,
    tipoReporte,
    tipoXml,
  ].whereType<LogDimensionRef>().toList();
}

/// Detalle de una generación (`GET /logs/:id` o `/logs/public/:id`).
///
/// El endpoint público no requiere autenticación y es el que alimenta el
/// visor WebView; el autenticado se usa para operaciones del usuario.
class LogDetalle {
  final LogGeneracion log;
  final DatabaseConfiguration? databaseConfiguration;
  final Map<String, dynamic>? diagramaSnapshot;

  const LogDetalle({
    required this.log,
    this.databaseConfiguration,
    this.diagramaSnapshot,
  });

  factory LogDetalle.fromJson(Map<String, dynamic> json) {
    final snapshot = json['diagrama_snapshot'];
    final config = json['database_configuration'];
    return LogDetalle(
      log: LogGeneracion.fromJson(json),
      databaseConfiguration: config is Map<String, dynamic>
          ? DatabaseConfiguration.fromJson(config)
          : null,
      diagramaSnapshot: snapshot is Map<String, dynamic> ? snapshot : null,
    );
  }

  /// La generación no tiene nodos ni aristas guardadas.
  bool get sinDiagrama {
    final nodes = diagramaSnapshot?['nodes'];
    final edges = diagramaSnapshot?['edges'];
    final n = nodes is List ? nodes.length : 0;
    final e = edges is List ? edges.length : 0;
    return n == 0 && e == 0;
  }
}

/// Catálogos para los filtros avanzados (`/logs/mis-logs/filter-options`).
@freezed
abstract class LogFilterOptions with _$LogFilterOptions {
  const factory LogFilterOptions({
    @JsonKey(name: 'tipos_artefacto')
    @Default([])
    List<LogDimensionRef> tiposArtefacto,
    @Default([]) List<LogDimensionRef> lenguajes,
    @Default([]) List<LogDimensionRef> frameworks,
    @Default([]) List<LogDimensionRef> arquitecturas,
    @Default([]) List<LogDimensionRef> orms,
    @JsonKey(name: 'bases_datos') @Default([]) List<LogDimensionRef> basesDatos,
    @JsonKey(name: 'tipos_reporte')
    @Default([])
    List<LogDimensionRef> tiposReporte,
    @JsonKey(name: 'tipos_xml') @Default([]) List<LogDimensionRef> tiposXml,
  }) = _LogFilterOptions;

  factory LogFilterOptions.fromJson(Map<String, dynamic> json) =>
      _$LogFilterOptionsFromJson(json);
}

/// Página de logs personales.
@freezed
abstract class PaginatedLogs with _$PaginatedLogs {
  const factory PaginatedLogs({
    @Default([]) List<LogGeneracion> items,
    required PaginationMeta meta,
  }) = _PaginatedLogs;

  factory PaginatedLogs.fromJson(Map<String, dynamic> json) =>
      _$PaginatedLogsFromJson(json);
}
