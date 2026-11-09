import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_edge_ai/flutter_edge_ai.dart';
import 'package:flutter_edge_ai_mediapipe/flutter_edge_ai_mediapipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'assistant_model_manifest.dart';

/// Error de instalación/verificación del modelo local con un mensaje apto
/// para mostrar al usuario.
class AssistantModelException implements Exception {
  final String message;
  const AssistantModelException(this.message);

  @override
  String toString() => message;
}

/// Fachada única del motor de IA local.
///
/// Responsabilidades:
/// - registrar el motor MediaPipe una sola vez,
/// - instalar/verificar/descargar el `.task`,
/// - cargar el modelo activo y abrir chats,
/// - liberar memoria al salir.
class AssistantEngine {
  AssistantEngine._();

  static final AssistantEngine instance = AssistantEngine._();

  static const String _verifiedKey = 'assistant_model_verified_signature';

  bool _initialized = false;
  bool _verificationChecked = false;
  InferenceModel? _model;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;
    await FlutterEdgeAi.initialize(
      inferenceEngines: const [MediaPipeEngine()],
    );
    _initialized = true;
  }

  Future<bool> isInstalled() async {
    if (!_initialized) return false;
    try {
      return await FlutterEdgeAi.isModelInstalled(
        AssistantModelManifest.modelId,
      );
    } catch (_) {
      return false;
    }
  }

  /// Instala el modelo si hace falta y verifica su SHA-256.
  ///
  /// [onProgress] recibe 0..100. La descarga se detiene con [cancelToken].
  Future<void> download({
    required void Function(int percent) onProgress,
    CancelToken? cancelToken,
  }) async {
    await initialize();

    // El builder marca el modelo como activo al terminar.
    final installation = await FlutterEdgeAi.installModel(
      modelType: ModelType.qwen,
      fileType: ModelFileType.task,
    )
        .fromNetwork(
          AssistantModelManifest.url,
          filename: AssistantModelManifest.fileName,
          expectedSize: AssistantModelManifest.sizeBytes,
        )
        .withProgress((progress) => onProgress(progress.clamp(0, 100)))
        .withCancelToken(cancelToken ?? CancelToken())
        .install();

    debugPrint('Modelo instalado: ${installation.modelId}');
    await _verifyChecksum(force: true);
    onProgress(100);
  }

  /// Comprueba el SHA-256 del archivo instalado.
  ///
  /// La primera vez de cada versión del archivo se calcula sobre 1.5 GB; en
  /// arranques posteriores se reutiliza la firma (tamaño + mtime) guardada.
  Future<void> verifyInstalled({bool force = false}) async {
    await initialize();
    if (!await isInstalled()) {
      throw const AssistantModelException(
        'El modelo del asistente no está descargado.',
      );
    }
    await _verifyChecksum(force: force);
  }

  Future<void> _verifyChecksum({required bool force}) async {
    if (_verificationChecked && !force) return;

    final path = await FlutterEdgeAi.getModelPath(
      AssistantModelManifest.fileName,
    );
    final file = File(path);
    if (!await file.exists()) {
      throw const AssistantModelException(
        'No se encontró el archivo del modelo tras la instalación.',
      );
    }

    final stat = await file.stat();
    final signature =
        '${stat.size}|${stat.modified.millisecondsSinceEpoch}|'
        '${AssistantModelManifest.sha256}';

    if (!force) {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString(_verifiedKey) == signature) {
        _verificationChecked = true;
        return;
      }
    }

    final digest = await sha256.bind(file.openRead()).first;
    if (digest.toString() != AssistantModelManifest.sha256) {
      await FlutterEdgeAi.uninstallModel(AssistantModelManifest.modelId);
      _verificationChecked = false;
      throw const AssistantModelException(
        'El archivo del modelo está dañado o incompleto. '
        'Vuelve a descargarlo.',
      );
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_verifiedKey, signature);
    _verificationChecked = true;
  }

  /// Carga (o reutiliza) el modelo activo. La primera carga puede tardar
  /// varios segundos y consume ~2 GB de RAM.
  Future<InferenceModel> load() async {
    await initialize();
    final current = _model;
    if (current != null) return current;

    final model = await FlutterEdgeAi.getActiveModel(
      maxTokens: AssistantModelManifest.maxTokens,
    );
    _model = model;
    return model;
  }

  /// Abre una conversación independiente con las instrucciones del sistema.
  Future<InferenceChat> openChat({String? systemInstruction}) async {
    final model = await load();
    return model.openChat(
      systemInstruction: systemInstruction,
      maxOutputTokens: AssistantModelManifest.maxOutputTokens,
      temperature: 0.35,
      topK: 20,
      topP: 0.9,
      randomSeed: DateTime.now().millisecondsSinceEpoch & 0x7fffffff,
    );
  }

  /// Libera el modelo de la memoria. El archivo permanece instalado.
  Future<void> unload() async {
    final model = _model;
    _model = null;
    if (model != null) {
      try {
        await model.close();
      } catch (_) {}
    }
  }

  /// Elimina el modelo instalado y la firma de verificación.
  Future<void> delete() async {
    await initialize();
    await unload();
    try {
      await FlutterEdgeAi.uninstallModel(AssistantModelManifest.modelId);
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_verifiedKey);
    _verificationChecked = false;
  }
}
