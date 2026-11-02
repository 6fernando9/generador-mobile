// Guardado de archivos descargados (ZIP / SQL / XML) y apertura con la app
// del sistema.
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

/// Guarda bytes en disco y permite abrirlos.
class DownloadSaver {
  const DownloadSaver._();

  /// Guarda el archivo y devuelve su ruta absoluta.
  ///
  /// Usa el directorio de descargas del sistema cuando existe (escritorio) y
  /// cae a un subdirectorio `downloads` dentro de los documentos de la app
  /// (Android/iOS), que es accesible vía FileProvider por `open_filex`.
  static Future<File> guardar({
    required List<int> bytes,
    required String nombreArchivo,
  }) async {
    final directorio = await _directorioDestino();
    final archivo = File('${directorio.path}/$nombreArchivo');
    await archivo.writeAsBytes(bytes, flush: true);
    return archivo;
  }

  /// Abre el archivo con la aplicación asociada del sistema.
  static Future<OpenResult> abrir(File archivo) {
    return OpenFilex.open(archivo.path);
  }

  /// Nombre seguro para el sistema de archivos.
  static String nombreSeguro(String nombre, {required String extension}) {
    final base = nombre
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '-')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final sinExtension = base.toLowerCase().endsWith('.$extension')
        ? base.substring(0, base.length - extension.length - 1)
        : base;
    final limpio = sinExtension.isEmpty ? 'archivo' : sinExtension;
    return '$limpio.$extension';
  }

  static Future<Directory> _directorioDestino() async {
    try {
      final descargas = await getDownloadsDirectory();
      if (descargas != null) {
        await descargas.create(recursive: true);
        return descargas;
      }
    } catch (e) {
      debugPrint('getDownloadsDirectory no disponible: $e');
    }

    final documentos = await getApplicationDocumentsDirectory();
    final directorio = Directory('${documentos.path}/downloads');
    await directorio.create(recursive: true);
    return directorio;
  }
}
