/// Referencia local a una regeneración que se puede volver a abrir.
class SavedDownload {
  const SavedDownload({
    required this.id,
    required this.nombre,
    required this.extension,
    required this.ubicacion,
    required this.rutaLocal,
    required this.creadoEn,
    this.usoUbicacionPredeterminada = false,
    this.copiaInterna = false,
  });

  final String id;
  final String nombre;
  final String extension;
  final String ubicacion;
  final String rutaLocal;
  final DateTime creadoEn;
  final bool usoUbicacionPredeterminada;
  final bool copiaInterna;

  String get tipo => extension.toLowerCase() == 'sql' ? 'SQL' : 'proyecto ZIP';

  Map<String, Object?> toMap(String userId) => {
    'id': id,
    'user_id': userId,
    'nombre': nombre,
    'extension': extension,
    'ubicacion': ubicacion,
    'ruta_local': rutaLocal,
    'creado_en': creadoEn.millisecondsSinceEpoch,
    'predeterminado': usoUbicacionPredeterminada ? 1 : 0,
    'copia_interna': copiaInterna ? 1 : 0,
  };

  factory SavedDownload.fromMap(Map<String, Object?> map) => SavedDownload(
    id: map['id'] as String,
    nombre: map['nombre'] as String,
    extension: map['extension'] as String,
    ubicacion: map['ubicacion'] as String,
    rutaLocal: map['ruta_local'] as String,
    creadoEn: DateTime.fromMillisecondsSinceEpoch(map['creado_en'] as int),
    usoUbicacionPredeterminada: map['predeterminado'] == 1,
    copiaInterna: map['copia_interna'] == 1,
  );
}
