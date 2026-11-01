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

/// Claves de artefacto que expone `porTipo` en `GET /dashboard/mi-tendencia`.
/// El backend puede añadir nuevas en el futuro, por eso se conserva el mapa.
const List<String> kTendenciaTipos = [
  'backend',
  'frontend',
  'mobile',
  'reporte',
];

@freezed
abstract class TimeSeriesPoint with _$TimeSeriesPoint {
  const factory TimeSeriesPoint({
    @Default('') String periodo,
    @Default(0) int total,
    @Default(<String, int>{}) Map<String, int> porTipo,
  }) = _TimeSeriesPoint;

  factory TimeSeriesPoint.fromJson(Map<String, dynamic> json) =>
      _$TimeSeriesPointFromJson(json);
}

extension TimeSeriesPointX on TimeSeriesPoint {
  int valorTipo(String tipo) => porTipo[tipo] ?? 0;

  int get backend => valorTipo('backend');
  int get frontend => valorTipo('frontend');
  int get mobile => valorTipo('mobile');
  int get reporte => valorTipo('reporte');
}
