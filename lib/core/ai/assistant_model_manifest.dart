// Manifiesto del modelo local del asistente Kraken.
//
// El .task de MediaPipe se descarga en el primer uso: no se empaqueta en el
// APK. Los valores de tamaño y SHA-256 fueron verificados en la Fase 0.
class AssistantModelManifest {
  const AssistantModelManifest._();

  /// Nombre con el que flutter_edge_ai instala el archivo.
  static const String fileName =
      'Qwen2.5-1.5B-Instruct_multi-prefill-seq_q8_ekv4096.task';

  /// `modelId` que usa flutter_edge_ai (nombre sin extensión).
  static const String modelId =
      'Qwen2.5-1.5B-Instruct_multi-prefill-seq_q8_ekv4096';

  static const String displayName = 'Qwen 2.5 1.5B Instruct (q8)';

  static const String url =
      'https://huggingface.co/litert-community/Qwen2.5-1.5B-Instruct/resolve/'
      '2f23bacf8ec78b83dfcd7271c5cb25777b1be5e0/'
      'Qwen2.5-1.5B-Instruct_multi-prefill-seq_q8_ekv4096.task';

  static const int sizeBytes = 1598556720;

  static const String sha256 =
      '82968d0a6c3872cf016fdbcfc591571605f4c7fd2b0f64d2533df502cc6596b3';

  /// Ventana de contexto total (entrada + salida). El archivo declara 4096;
  /// 2048 deja margen para el prompt del sistema y el historial reciente.
  static const int maxTokens = 4096;

  static const int maxOutputTokens = 1024;

  static String get sizeLabel {
    final gb = sizeBytes / (1024 * 1024 * 1024);
    return '${gb.toStringAsFixed(2)} GB';
  }
}
