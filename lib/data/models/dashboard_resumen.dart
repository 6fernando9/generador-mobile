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
    @JsonKey(name: 'semana_pasada') @Default(0) int semanaPasada,
    @Default(0) int mes,
    @JsonKey(name: 'mes_pasado') @Default(0) int mesPasado,
    @Default(0) int total,
    @Default(Deltas()) Deltas deltas,
  }) = _DashboardResumen;

  factory DashboardResumen.fromJson(Map<String, dynamic> json) =>
      _$DashboardResumenFromJson(json);
}

@freezed
abstract class Deltas with _$Deltas {
  const factory Deltas({double? hoy, double? semana, double? mes}) = _Deltas;

  factory Deltas.fromJson(Map<String, dynamic> json) => _$DeltasFromJson(json);
}
