// Catálogos de exportación (`GET /exportar/opciones`).
//
// Estructura: tipos_artefacto[] → tipos_reporte[] (SQL, XML) → hijas[]
// (bases de datos destino para SQL, tipos de XML para XML).
import 'package:mobile/data/models/generacion_models.dart'
    show OpcionDimension;

/// Tipo de reporte exportable, con sus opciones hijas.
class TipoReporteOpcion extends OpcionDimension {
  final List<OpcionDimension> hijas;

  const TipoReporteOpcion({
    required super.id,
    required super.nombre,
    super.nombreCode,
    super.icono,
    super.iconoTipo,
    this.hijas = const [],
  });

  factory TipoReporteOpcion.fromJson(Map<String, dynamic> json) {
    final base = OpcionDimension.fromJson(json);
    return TipoReporteOpcion(
      id: base.id,
      nombre: base.nombre,
      nombreCode: base.nombreCode,
      icono: base.icono,
      iconoTipo: base.iconoTipo,
      hijas: _lista(json['hijas'])
          .map((e) => OpcionDimension.fromJson(e))
          .toList(growable: false),
    );
  }
}

/// Tipo de artefacto exportable, agrupando los tipos de reporte.
class TipoArtefactoExportacion extends OpcionDimension {
  final List<TipoReporteOpcion> tiposReporte;

  const TipoArtefactoExportacion({
    required super.id,
    required super.nombre,
    super.nombreCode,
    super.icono,
    super.iconoTipo,
    this.tiposReporte = const [],
  });

  factory TipoArtefactoExportacion.fromJson(Map<String, dynamic> json) {
    final base = OpcionDimension.fromJson(json);
    return TipoArtefactoExportacion(
      id: base.id,
      nombre: base.nombre,
      nombreCode: base.nombreCode,
      icono: base.icono,
      iconoTipo: base.iconoTipo,
      tiposReporte: _lista(json['tipos_reporte'])
          .map((e) => TipoReporteOpcion.fromJson(e))
          .toList(growable: false),
    );
  }
}

/// Respuesta completa de `/exportar/opciones`.
class OpcionesExportacion {
  final List<TipoArtefactoExportacion> tiposArtefacto;

  const OpcionesExportacion({this.tiposArtefacto = const []});

  factory OpcionesExportacion.fromJson(Map<String, dynamic> json) {
    return OpcionesExportacion(
      tiposArtefacto: _lista(json['tipos_artefacto'])
          .map((e) => TipoArtefactoExportacion.fromJson(e))
          .toList(growable: false),
    );
  }
}

List<Map<String, dynamic>> _lista(dynamic value) {
  if (value is! List) return const [];
  return value.whereType<Map<String, dynamic>>().toList(growable: false);
}
