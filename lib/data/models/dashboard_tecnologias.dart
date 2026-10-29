// Dashboard Tecnologías (Distributions) models
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_tecnologias.freezed.dart';
part 'dashboard_tecnologias.g.dart';

@freezed
abstract class DashboardTecnologias with _$DashboardTecnologias {
  const factory DashboardTecnologias({
    @Default(0) int total,
    @Default([]) List<TechItem> lenguajes,
    @Default([]) List<TechItem> frameworks,
    @Default([]) List<TechItem> arquitecturas,
    @Default([]) List<TechItem> orms,
    @Default([]) List<TechItem> basesDatos,
    @Default([]) List<TechItem> tiposArtefacto,
  }) = _DashboardTecnologias;

  factory DashboardTecnologias.fromJson(Map<String, dynamic> json) =>
      _$DashboardTecnologiasFromJson(json);
}

@freezed
abstract class TechItem with _$TechItem {
  const factory TechItem({
    @Default(0) int id,
    @Default('') String nombre,
    @JsonKey(name: 'nombre_code') @Default('') String nombreCode,
    String? icono,
    @JsonKey(name: 'icono_tipo') String? iconoTipo,
    @Default(0) int total,
    @Default(0.0) double porcentaje,
  }) = _TechItem;

  factory TechItem.fromJson(Map<String, dynamic> json) =>
      _$TechItemFromJson(json);
}