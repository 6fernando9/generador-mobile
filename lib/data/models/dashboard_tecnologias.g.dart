// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_tecnologias.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardTecnologias _$DashboardTecnologiasFromJson(
  Map<String, dynamic> json,
) => _DashboardTecnologias(
  total: (json['total'] as num?)?.toInt() ?? 0,
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
      (json['basesDatos'] as List<dynamic>?)
          ?.map((e) => TechItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  tiposArtefacto:
      (json['tiposArtefacto'] as List<dynamic>?)
          ?.map((e) => TechItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$DashboardTecnologiasToJson(
  _DashboardTecnologias instance,
) => <String, dynamic>{
  'total': instance.total,
  'lenguajes': instance.lenguajes,
  'frameworks': instance.frameworks,
  'arquitecturas': instance.arquitecturas,
  'orms': instance.orms,
  'basesDatos': instance.basesDatos,
  'tiposArtefacto': instance.tiposArtefacto,
};

_TechItem _$TechItemFromJson(Map<String, dynamic> json) => _TechItem(
  id: (json['id'] as num?)?.toInt() ?? 0,
  nombre: json['nombre'] as String? ?? '',
  nombreCode: json['nombre_code'] as String? ?? '',
  icono: json['icono'] as String?,
  iconoTipo: json['icono_tipo'] as String?,
  total: (json['total'] as num?)?.toInt() ?? 0,
  porcentaje: (json['porcentaje'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$TechItemToJson(_TechItem instance) => <String, dynamic>{
  'id': instance.id,
  'nombre': instance.nombre,
  'nombre_code': instance.nombreCode,
  'icono': instance.icono,
  'icono_tipo': instance.iconoTipo,
  'total': instance.total,
  'porcentaje': instance.porcentaje,
};
