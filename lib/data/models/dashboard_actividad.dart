// Dashboard Actividad (Heatmap) models
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_actividad.freezed.dart';
part 'dashboard_actividad.g.dart';

@freezed
abstract class DashboardActividad with _$DashboardActividad {
  const factory DashboardActividad({
    @Default(0) int total,
    @Default([]) List<DayOfWeekStat> porDiaSemana,
    @Default([]) List<HourStat> porHora,
    @Default([]) List<HeatmapPoint> heatmap,
  }) = _DashboardActividad;

  factory DashboardActividad.fromJson(Map<String, dynamic> json) =>
      _$DashboardActividadFromJson(json);
}

@freezed
abstract class DayOfWeekStat with _$DayOfWeekStat {
  const factory DayOfWeekStat({
    @Default(0) int dia,
    @Default('') String nombre,
    @Default(0) int total,
  }) = _DayOfWeekStat;

  factory DayOfWeekStat.fromJson(Map<String, dynamic> json) =>
      _$DayOfWeekStatFromJson(json);
}

@freezed
abstract class HourStat with _$HourStat {
  const factory HourStat({
    @Default(0) int hora,
    @Default(0) int total,
  }) = _HourStat;

  factory HourStat.fromJson(Map<String, dynamic> json) =>
      _$HourStatFromJson(json);
}

@freezed
abstract class HeatmapPoint with _$HeatmapPoint {
  const factory HeatmapPoint({
    @Default(0) int dia,
    @Default(0) int hora,
    @Default(0) int total,
  }) = _HeatmapPoint;

  factory HeatmapPoint.fromJson(Map<String, dynamic> json) =>
      _$HeatmapPointFromJson(json);
}