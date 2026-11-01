// Catálogos personales para filtros dinámicos (`GET /dashboard/mi-catalogos`).
// Misma forma que las distribuciones, pero sin campo raíz `total` y solo con
// los valores que el usuario ya utilizó.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/data/models/dashboard_tecnologias.dart';

part 'dashboard_catalogos.freezed.dart';
part 'dashboard_catalogos.g.dart';

@freezed
abstract class DashboardCatalogos with _$DashboardCatalogos {
  const factory DashboardCatalogos({
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
  }) = _DashboardCatalogos;

  factory DashboardCatalogos.fromJson(Map<String, dynamic> json) =>
      _$DashboardCatalogosFromJson(json);
}

extension DashboardCatalogosX on DashboardCatalogos {
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
