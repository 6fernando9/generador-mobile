// Dashboard Resumen (KPIs) models
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_resumen.freezed.dart';
part 'dashboard_resumen.g.dart';

@freezed
abstract class DashboardResumen with _$DashboardResumen {
  const factory DashboardResumen({
    @Default(0) int hoy,
    @Default(0) int ayer,
    @Default(0) int semana,
    @Default(0) int semanaPasada,
    @Default(0) int mes,
    @Default(0) int mesPasado,
    @Default(0) int total,
    @Default(Deltas()) Deltas deltas,
  }) = _DashboardResumen;

  factory DashboardResumen.fromJson(Map<String, dynamic> json) =>
      _$DashboardResumenFromJson(json);
}

@freezed
abstract class Deltas with _$Deltas {
  const factory Deltas({
    @Default(0.0) double hoy,
    @Default(0.0) double semana,
    @Default(0.0) double mes,
  }) = _Deltas;

  factory Deltas.fromJson(Map<String, dynamic> json) =>
      _$DeltasFromJson(json);
}