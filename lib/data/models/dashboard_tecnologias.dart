// Dashboard Tecnologías (Distributions) models
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_tecnologias.freezed.dart';
part 'dashboard_tecnologias.g.dart';

/// Vistas que expone el backend para las distribuciones tecnológicas.
enum DashboardTecnologiaVista {
  total('Total'),
  proyecto('Proyecto'),
  reporte('Reporte');

  const DashboardTecnologiaVista(this.label);

  final String label;

  /// Dimensiones que devuelve cada endpoint (y que se pueden filtrar).
  List<TecnologiaCategoria> get categorias => switch (this) {
    DashboardTecnologiaVista.total => const [
      TecnologiaCategoria.lenguajes,
      TecnologiaCategoria.frameworks,
      TecnologiaCategoria.arquitecturas,
      TecnologiaCategoria.orms,
      TecnologiaCategoria.basesDatos,
      TecnologiaCategoria.tiposArtefacto,
      TecnologiaCategoria.tiposReporte,
      TecnologiaCategoria.tiposXml,
    ],
    DashboardTecnologiaVista.proyecto => const [
      TecnologiaCategoria.lenguajes,
      TecnologiaCategoria.frameworks,
      TecnologiaCategoria.arquitecturas,
      TecnologiaCategoria.orms,
      TecnologiaCategoria.basesDatos,
      TecnologiaCategoria.tiposArtefacto,
    ],
    DashboardTecnologiaVista.reporte => const [
      TecnologiaCategoria.tiposReporte,
      TecnologiaCategoria.tiposXml,
      TecnologiaCategoria.basesDatos,
      TecnologiaCategoria.tiposArtefacto,
    ],
  };
}

/// Dimensión tecnológica. `apiKey` coincide con el query param del backend.
enum TecnologiaCategoria {
  lenguajes('lenguajes', 'Lenguajes'),
  frameworks('frameworks', 'Frameworks'),
  arquitecturas('arquitecturas', 'Arquitecturas'),
  orms('orms', 'ORMs'),
  basesDatos('bases_datos', 'Bases de Datos'),
  tiposArtefacto('tipos_artefacto', 'Artefactos'),
  tiposReporte('tipos_reporte', 'Tipos de Reporte'),
  tiposXml('tipos_xml', 'Formatos XML');

  const TecnologiaCategoria(this.apiKey, this.label);

  final String apiKey;
  final String label;
}

@freezed
abstract class DashboardTecnologias with _$DashboardTecnologias {
  const factory DashboardTecnologias({
    @Default(0) int total,
    @Default([]) List<TechItem> lenguajes,
    @Default([]) List<TechItem> frameworks,
    @Default([]) List<TechItem> arquitecturas,
    @Default([]) List<TechItem> orms,
    @JsonKey(name: 'bases_datos') @Default([]) List<TechItem> basesDatos,
    @JsonKey(name: 'tipos_artefacto')
    @Default([])
    List<TechItem> tiposArtefacto,
    @JsonKey(name: 'tipos_reporte') @Default([]) List<TechItem> tiposReporte,
    @JsonKey(name: 'tipos_xml') @Default([]) List<TechItem> tiposXml,
  }) = _DashboardTecnologias;

  factory DashboardTecnologias.fromJson(Map<String, dynamic> json) =>
      _$DashboardTecnologiasFromJson(json);
}

extension DashboardTecnologiasX on DashboardTecnologias {
  List<TechItem> itemsDe(TecnologiaCategoria categoria) => switch (categoria) {
    TecnologiaCategoria.lenguajes => lenguajes,
    TecnologiaCategoria.frameworks => frameworks,
    TecnologiaCategoria.arquitecturas => arquitecturas,
    TecnologiaCategoria.orms => orms,
    TecnologiaCategoria.basesDatos => basesDatos,
    TecnologiaCategoria.tiposArtefacto => tiposArtefacto,
    TecnologiaCategoria.tiposReporte => tiposReporte,
    TecnologiaCategoria.tiposXml => tiposXml,
  };
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
