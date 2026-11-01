// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_catalogos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardCatalogos _$DashboardCatalogosFromJson(Map<String, dynamic> json) =>
    _DashboardCatalogos(
      lenguajes:
          (json['lenguajes'] as List<dynamic>?)
              ?.map((e) => TechItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      frameworks:
          (json['frameworks'] as List<dynamic>?)
              ?.map((e) => TechItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      arquitecturas:
          (json['arquitecturas'] as List<dynamic>?)
              ?.map((e) => TechItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      orms:
          (json['orms'] as List<dynamic>?)
              ?.map((e) => TechItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      basesDatos:
          (json['bases_datos'] as List<dynamic>?)
              ?.map((e) => TechItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tiposArtefacto:
          (json['tipos_artefacto'] as List<dynamic>?)
              ?.map((e) => TechItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tiposReporte:
          (json['tipos_reporte'] as List<dynamic>?)
              ?.map((e) => TechItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tiposXml:
          (json['tipos_xml'] as List<dynamic>?)
              ?.map((e) => TechItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DashboardCatalogosToJson(_DashboardCatalogos instance) =>
    <String, dynamic>{
      'lenguajes': instance.lenguajes,
      'frameworks': instance.frameworks,
      'arquitecturas': instance.arquitecturas,
      'orms': instance.orms,
      'bases_datos': instance.basesDatos,
      'tipos_artefacto': instance.tiposArtefacto,
      'tipos_reporte': instance.tiposReporte,
      'tipos_xml': instance.tiposXml,
    };
