// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_actividad.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardActividad _$DashboardActividadFromJson(Map<String, dynamic> json) =>
    _DashboardActividad(
      total: (json['total'] as num?)?.toInt() ?? 0,
      porDiaSemana:
          (json['porDiaSemana'] as List<dynamic>?)
              ?.map((e) => DayOfWeekStat.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      porHora:
          (json['porHora'] as List<dynamic>?)
              ?.map((e) => HourStat.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      heatmap:
          (json['heatmap'] as List<dynamic>?)
              ?.map((e) => HeatmapPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DashboardActividadToJson(_DashboardActividad instance) =>
    <String, dynamic>{
      'total': instance.total,
      'porDiaSemana': instance.porDiaSemana,
      'porHora': instance.porHora,
      'heatmap': instance.heatmap,
    };

_DayOfWeekStat _$DayOfWeekStatFromJson(Map<String, dynamic> json) =>
    _DayOfWeekStat(
      dia: (json['dia'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DayOfWeekStatToJson(_DayOfWeekStat instance) =>
    <String, dynamic>{
      'dia': instance.dia,
      'nombre': instance.nombre,
      'total': instance.total,
    };

_HourStat _$HourStatFromJson(Map<String, dynamic> json) => _HourStat(
  hora: (json['hora'] as num?)?.toInt() ?? 0,
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$HourStatToJson(_HourStat instance) => <String, dynamic>{
  'hora': instance.hora,
  'total': instance.total,
};

_HeatmapPoint _$HeatmapPointFromJson(Map<String, dynamic> json) =>
    _HeatmapPoint(
      dia: (json['dia'] as num?)?.toInt() ?? 0,
      hora: (json['hora'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$HeatmapPointToJson(_HeatmapPoint instance) =>
    <String, dynamic>{
      'dia': instance.dia,
      'hora': instance.hora,
      'total': instance.total,
    };
