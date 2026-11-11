// Guardado, historial local y apertura de archivos regenerados.
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:mobile/core/storage/local_database.dart';
import 'package:mobile/data/models/saved_download.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

/// Guarda bytes en una ubicación elegida o en la carpeta predeterminada.
class DownloadSaver {
  const DownloadSaver._();

  static Future<SavedDownload> guardar({
    required List<int> bytes,
    required String nombreArchivo,
    required String userId,
  }) async {
    final nombre = nombreSeguro(
      nombreArchivo,
      extension: _extension(nombreArchivo),
    );
    var nombreGuardado = nombre;
    final extension = _extension(nombre);
    final predeterminado = await _directorioDestino();
    String? rutaDestino;
    var ubicacion = '';
    var usaPredeterminado = false;
    var copiaInterna = false;

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final ruta = await FlutterFileDialog.saveFile(
          params: SaveFileDialogParams(
            data: Uint8List.fromList(bytes),
            fileName: nombre,
            mimeTypesFilter: [
              extension == 'zip' ? 'application/zip' : 'text/plain',
            ],
          ),
        );
        if (ruta != null && ruta.isNotEmpty) {
          nombreGuardado = _nombreDesdeRuta(ruta, nombre);
          ubicacion = _ubicacionMovil(ruta, nombreGuardado);
          // SAF y Files pueden devolver referencias que no son rutas de Dart.
          // La copia privada mantiene disponible la acción Abrir.
          rutaDestino = await _guardarCopiaLocal(bytes, nombreGuardado);
          copiaInterna = true;
        }
      } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        await predeterminado.create(recursive: true);
        final seleccion = await getSaveLocation(
          suggestedName: nombre,
          initialDirectory: predeterminado.path,
          acceptedTypeGroups: [
            XTypeGroup(label: extension.toUpperCase(), extensions: [extension]),
          ],
        );
        if (seleccion != null) {
          final archivo = File(seleccion.path);
          await archivo.parent.create(recursive: true);
          await archivo.writeAsBytes(bytes, flush: true);
          rutaDestino = archivo.path;
          nombreGuardado = _nombreDesdeRuta(archivo.path, nombre);
          ubicacion = archivo.parent.path;
        }
      }
    } catch (error) {
      debugPrint('No se pudo guardar en la ubicación elegida: $error');
    }

    if (rutaDestino == null) {
      usaPredeterminado = true;
      final archivo = await _guardarPredeterminado(
        predeterminado,
        nombre,
        bytes,
      );
      rutaDestino = archivo.path;
      nombreGuardado = _nombreDesdeRuta(archivo.path, nombre);
      ubicacion = archivo.parent.path;
    }

    final saved = SavedDownload(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nombre: nombreGuardado,
      extension: _extension(nombreGuardado),
      ubicacion: ubicacion,
      rutaLocal: rutaDestino,
      creadoEn: DateTime.now(),
      usoUbicacionPredeterminada: usaPredeterminado,
      copiaInterna: copiaInterna,
    );

    try {
      final antiguas = await LocalDatabase.instance.recordSavedDownload(
        saved,
        userId,
      );
      for (final ruta in antiguas) {
        if (ruta != saved.rutaLocal) {
          final archivo = File(ruta);
          if (await archivo.exists()) await archivo.delete();
        }
      }
    } catch (error) {
      // El archivo ya quedó guardado; un fallo de SQLite no debe ocultarlo.
      debugPrint('No se pudo registrar la regeneración local: $error');
    }

    return saved;
  }

  static Future<OpenResult> abrir(SavedDownload archivo) async {
    final local = File(archivo.rutaLocal);
    if (!await local.exists()) {
      return OpenResult(
        type: ResultType.fileNotFound,
        message: 'No se encontró el archivo guardado en este dispositivo.',
      );
    }
    return OpenFilex.open(local.path);
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

  static String _extension(String nombre) {
    final index = nombre.lastIndexOf('.');
    return index < 0 ? 'bin' : nombre.substring(index + 1).toLowerCase();
  }

  static Future<String> _guardarCopiaLocal(
    List<int> bytes,
    String nombre,
  ) async {
    final support = await getApplicationSupportDirectory();
    final directorio = Directory('${support.path}/regeneraciones');
    await directorio.create(recursive: true);
    final archivo = File(
      '${directorio.path}/'
      '${DateTime.now().microsecondsSinceEpoch}_$nombre',
    );
    await archivo.writeAsBytes(bytes, flush: true);
    return archivo.path;
  }

  static Future<File> _guardarEn(
    Directory directorio,
    String nombre,
    List<int> bytes,
  ) async {
    await directorio.create(recursive: true);
    var archivo = File('${directorio.path}/$nombre');
    var sufijo = 2;
    while (await archivo.exists()) {
      final index = nombre.lastIndexOf('.');
      final base = index < 0 ? nombre : nombre.substring(0, index);
      final extension = index < 0 ? '' : nombre.substring(index);
      archivo = File('${directorio.path}/$base ($sufijo)$extension');
      sufijo++;
    }
    await archivo.writeAsBytes(bytes, flush: true);
    return archivo;
  }

  static Future<File> _guardarPredeterminado(
    Directory directorio,
    String nombre,
    List<int> bytes,
  ) async {
    try {
      return await _guardarEn(directorio, nombre, bytes);
    } catch (error) {
      final documentos = await getApplicationDocumentsDirectory();
      final alternativa = Directory('${documentos.path}/downloads');
      if (alternativa.path == directorio.path) rethrow;
      debugPrint('No se pudo guardar en Descargas: $error');
      return _guardarEn(alternativa, nombre, bytes);
    }
  }

  static String _nombreDesdeRuta(String ruta, String sugerido) {
    final rutaNormalizada = _decodificar(ruta).replaceAll('\\', '/');
    final segmento = rutaNormalizada.split('/').last;
    return segmento.contains('.') ? segmento : sugerido;
  }

  static String _ubicacionMovil(String ruta, String nombre) {
    if (Platform.isAndroid) {
      final decodificada = _decodificar(ruta);
      final marcador = decodificada.lastIndexOf('/document/');
      final referencia = marcador >= 0
          ? decodificada.substring(marcador + '/document/'.length)
          : decodificada;
      final separador = referencia.indexOf(':');
      if (separador >= 0) {
        final volumen = referencia.substring(0, separador);
        final carpeta = referencia.substring(separador + 1);
        final segmentos = carpeta.split('/');
        if (segmentos.isNotEmpty && segmentos.last == nombre) {
          segmentos.removeLast();
        }
        final raiz = volumen == 'primary' ? 'Almacenamiento interno' : volumen;
        return segmentos.isEmpty ? raiz : '$raiz/${segmentos.join('/')}';
      }
      return 'Ubicación seleccionada';
    }
    return 'Archivos · ubicación elegida';
  }

  static String _decodificar(String valor) {
    try {
      return Uri.decodeComponent(valor);
    } on FormatException {
      return valor;
    }
  }

  static Future<Directory> _directorioDestino() async {
    try {
      final descargas = await getDownloadsDirectory();
      if (descargas != null) return descargas;
    } catch (error) {
      debugPrint('getDownloadsDirectory no disponible: $error');
    }

    final documentos = await getApplicationDocumentsDirectory();
    return Directory('${documentos.path}/downloads');
  }
}
