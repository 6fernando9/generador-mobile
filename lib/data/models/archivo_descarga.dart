// Resultado binario de una descarga (ZIP / SQL / XML).
class ArchivoDescarga {
  final List<int> bytes;

  /// Nombre sugerido por `Content-Disposition`, si el backend lo envía.
  final String? nombreSugerido;

  const ArchivoDescarga({required this.bytes, this.nombreSugerido});

  int get tamano => bytes.length;
}
