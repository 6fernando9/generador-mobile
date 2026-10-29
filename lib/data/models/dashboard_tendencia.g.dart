// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_tendencia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardTendencia _$DashboardTendenciaFromJson(Map<String, dynamic> json) =>
    _DashboardTendencia(
      total: (json['total'] as num?)?.toInt() ?? 0,
      granularidad: json['granularidad'] as String? ?? '',
      desde: json['desde'] as String? ?? '',
      hasta: json['hasta'] as String? ?? '',
      serie:
          (json['serie'] as List<dynamic>?)
              ?.map((e) => TimeSeriesPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DashboardTendenciaToJson(_DashboardTendencia instance) =>
    <String, dynamic>{
      'total': instance.total,
      'granularidad': instance.granularidad,
      'desde': instance.desde,
      'hasta': instance.hasta,
      'serie': instance.serie,
    };

_TimeSeriesPoint _$TimeSeriesPointFromJson(Map<String, dynamic> json) =>
    _TimeSeriesPoint(
      periodo: json['periodo'] as String? ?? '',
      total: (json['total'] as num?)?.toInt() ?? 0,
      backend: (json['backend'] as num?)?.toInt() ?? 0,
      frontend: (json['frontend'] as num?)?.toInt() ?? 0,
      mobile: (json['mobile'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TimeSeriesPointToJson(_TimeSeriesPoint instance) =>
    <String, dynamic>{
      'periodo': instance.periodo,
      'total': instance.total,
      'backend': instance.backend,
      'frontend': instance.frontend,
      'mobile': instance.mobile,
    };
