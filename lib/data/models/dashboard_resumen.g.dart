// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_resumen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardResumen _$DashboardResumenFromJson(Map<String, dynamic> json) =>
    _DashboardResumen(
      hoy: (json['hoy'] as num?)?.toInt() ?? 0,
      ayer: (json['ayer'] as num?)?.toInt() ?? 0,
      semana: (json['semana'] as num?)?.toInt() ?? 0,
      semanaPasada: (json['semana_pasada'] as num?)?.toInt() ?? 0,
      mes: (json['mes'] as num?)?.toInt() ?? 0,
      mesPasado: (json['mes_pasado'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      deltas: json['deltas'] == null
          ? const Deltas()
          : Deltas.fromJson(json['deltas'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashboardResumenToJson(_DashboardResumen instance) =>
    <String, dynamic>{
      'hoy': instance.hoy,
      'ayer': instance.ayer,
      'semana': instance.semana,
      'semana_pasada': instance.semanaPasada,
      'mes': instance.mes,
      'mes_pasado': instance.mesPasado,
      'total': instance.total,
      'deltas': instance.deltas,
    };

_Deltas _$DeltasFromJson(Map<String, dynamic> json) => _Deltas(
  hoy: (json['hoy'] as num?)?.toDouble(),
  semana: (json['semana'] as num?)?.toDouble(),
  mes: (json['mes'] as num?)?.toDouble(),
);

Map<String, dynamic> _$DeltasToJson(_Deltas instance) => <String, dynamic>{
  'hoy': instance.hoy,
  'semana': instance.semana,
  'mes': instance.mes,
};
