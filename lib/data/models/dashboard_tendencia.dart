// Dashboard Tendencia (Time Series) models
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_tendencia.freezed.dart';
part 'dashboard_tendencia.g.dart';

@freezed
abstract class DashboardTendencia with _$DashboardTendencia {
  const factory DashboardTendencia({
    @Default(0) int total,
    @Default('') String granularidad,
    @Default('') String desde,
    @Default('') String hasta,
    @Default([]) List<TimeSeriesPoint> serie,
  }) = _DashboardTendencia;

  factory DashboardTendencia.fromJson(Map<String, dynamic> json) =>
      _$DashboardTendenciaFromJson(json);
}

@freezed
abstract class TimeSeriesPoint with _$TimeSeriesPoint {
  const factory TimeSeriesPoint({
    @Default('') String periodo,
    @Default(0) int total,
    @Default(0) int backend,
    @Default(0) int frontend,
    @Default(0) int mobile,
  }) = _TimeSeriesPoint;

  factory TimeSeriesPoint.fromJson(Map<String, dynamic> json) =>
      _$TimeSeriesPointFromJson(json);
}