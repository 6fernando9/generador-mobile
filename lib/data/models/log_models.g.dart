// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LogDimensionRef _$LogDimensionRefFromJson(Map<String, dynamic> json) =>
    _LogDimensionRef(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      nombreCode: json['nombre_code'] as String? ?? '',
      icono: json['icono'] as String?,
      iconoTipo: json['icono_tipo'] as String?,
    );

Map<String, dynamic> _$LogDimensionRefToJson(_LogDimensionRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'nombre_code': instance.nombreCode,
      'icono': instance.icono,
      'icono_tipo': instance.iconoTipo,
    };

_LogProyectoRef _$LogProyectoRefFromJson(Map<String, dynamic> json) =>
    _LogProyectoRef(
      id: json['id'] as String? ?? '',
      nombre: json['nombre'] as String? ?? '',
    );

Map<String, dynamic> _$LogProyectoRefToJson(_LogProyectoRef instance) =>
    <String, dynamic>{'id': instance.id, 'nombre': instance.nombre};

_LogUsuarioRef _$LogUsuarioRefFromJson(Map<String, dynamic> json) =>
    _LogUsuarioRef(
      id: (json['id'] as num?)?.toInt() ?? 0,
      username: json['username'] as String? ?? '',
      profileIcon: json['profile_icon'] as String?,
      profileIconTipo: json['profile_icon_tipo'] as String?,
    );

Map<String, dynamic> _$LogUsuarioRefToJson(_LogUsuarioRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'profile_icon': instance.profileIcon,
      'profile_icon_tipo': instance.profileIconTipo,
    };

_LogGeneracion _$LogGeneracionFromJson(
  Map<String, dynamic> json,
) => _LogGeneracion(
  id: json['id'] as String? ?? '',
  proyectoId: json['proyecto_id'] as String? ?? '',
  usuarioId: (json['usuario_id'] as num?)?.toInt() ?? 0,
  rolId: (json['rol_id'] as num?)?.toInt() ?? 0,
  rolMomentoCode: json['rol_momento_code'] as String? ?? '',
  tipoArtefactoId: (json['tipo_artefacto_id'] as num?)?.toInt(),
  lenguajeId: (json['lenguaje_id'] as num?)?.toInt(),
  frameworkId: (json['framework_id'] as num?)?.toInt(),
  arquitecturaId: (json['arquitectura_id'] as num?)?.toInt(),
  ormId: (json['orm_id'] as num?)?.toInt(),
  baseDatosId: (json['base_datos_id'] as num?)?.toInt(),
  tipoReporteId: (json['tipo_reporte_id'] as num?)?.toInt(),
  tipoXmlId: (json['tipo_xml_id'] as num?)?.toInt(),
  versionGenerador: json['version_generador'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  tipoArtefacto: json['tipo_artefacto'] == null
      ? null
      : LogDimensionRef.fromJson(
          json['tipo_artefacto'] as Map<String, dynamic>,
        ),
  lenguaje: json['lenguaje'] == null
      ? null
      : LogDimensionRef.fromJson(json['lenguaje'] as Map<String, dynamic>),
  framework: json['framework'] == null
      ? null
      : LogDimensionRef.fromJson(json['framework'] as Map<String, dynamic>),
  arquitectura: json['arquitectura'] == null
      ? null
      : LogDimensionRef.fromJson(json['arquitectura'] as Map<String, dynamic>),
  orm: json['orm'] == null
      ? null
      : LogDimensionRef.fromJson(json['orm'] as Map<String, dynamic>),
  baseDatos: json['base_datos'] == null
      ? null
      : LogDimensionRef.fromJson(json['base_datos'] as Map<String, dynamic>),
  tipoReporte: json['tipo_reporte'] == null
      ? null
      : LogDimensionRef.fromJson(json['tipo_reporte'] as Map<String, dynamic>),
  tipoXml: json['tipo_xml'] == null
      ? null
      : LogDimensionRef.fromJson(json['tipo_xml'] as Map<String, dynamic>),
  proyecto: json['proyecto'] == null
      ? null
      : LogProyectoRef.fromJson(json['proyecto'] as Map<String, dynamic>),
  usuario: json['usuario'] == null
      ? null
      : LogUsuarioRef.fromJson(json['usuario'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LogGeneracionToJson(_LogGeneracion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'proyecto_id': instance.proyectoId,
      'usuario_id': instance.usuarioId,
      'rol_id': instance.rolId,
      'rol_momento_code': instance.rolMomentoCode,
      'tipo_artefacto_id': instance.tipoArtefactoId,
      'lenguaje_id': instance.lenguajeId,
      'framework_id': instance.frameworkId,
      'arquitectura_id': instance.arquitecturaId,
      'orm_id': instance.ormId,
      'base_datos_id': instance.baseDatosId,
      'tipo_reporte_id': instance.tipoReporteId,
      'tipo_xml_id': instance.tipoXmlId,
      'version_generador': instance.versionGenerador,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'tipo_artefacto': instance.tipoArtefacto,
      'lenguaje': instance.lenguaje,
      'framework': instance.framework,
      'arquitectura': instance.arquitectura,
      'orm': instance.orm,
      'base_datos': instance.baseDatos,
      'tipo_reporte': instance.tipoReporte,
      'tipo_xml': instance.tipoXml,
      'proyecto': instance.proyecto,
      'usuario': instance.usuario,
    };

_LogFilterOptions _$LogFilterOptionsFromJson(Map<String, dynamic> json) =>
    _LogFilterOptions(
      tiposArtefacto:
          (json['tipos_artefacto'] as List<dynamic>?)
              ?.map((e) => LogDimensionRef.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lenguajes:
          (json['lenguajes'] as List<dynamic>?)
              ?.map((e) => LogDimensionRef.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      frameworks:
          (json['frameworks'] as List<dynamic>?)
              ?.map((e) => LogDimensionRef.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      arquitecturas:
          (json['arquitecturas'] as List<dynamic>?)
              ?.map((e) => LogDimensionRef.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      orms:
          (json['orms'] as List<dynamic>?)
              ?.map((e) => LogDimensionRef.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      basesDatos:
          (json['bases_datos'] as List<dynamic>?)
              ?.map((e) => LogDimensionRef.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tiposReporte:
          (json['tipos_reporte'] as List<dynamic>?)
              ?.map((e) => LogDimensionRef.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tiposXml:
          (json['tipos_xml'] as List<dynamic>?)
              ?.map((e) => LogDimensionRef.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$LogFilterOptionsToJson(_LogFilterOptions instance) =>
    <String, dynamic>{
      'tipos_artefacto': instance.tiposArtefacto,
      'lenguajes': instance.lenguajes,
      'frameworks': instance.frameworks,
      'arquitecturas': instance.arquitecturas,
      'orms': instance.orms,
      'bases_datos': instance.basesDatos,
      'tipos_reporte': instance.tiposReporte,
      'tipos_xml': instance.tiposXml,
    };

_PaginatedLogs _$PaginatedLogsFromJson(Map<String, dynamic> json) =>
    _PaginatedLogs(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => LogGeneracion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginatedLogsToJson(_PaginatedLogs instance) =>
    <String, dynamic>{'items': instance.items, 'meta': instance.meta};
