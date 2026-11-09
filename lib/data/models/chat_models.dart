import 'dart:convert';

enum ChatRole {
  user('user'),
  assistant('assistant'),
  system('system');

  const ChatRole(this.value);
  final String value;

  static ChatRole fromValue(String value) => ChatRole.values.firstWhere(
    (r) => r.value == value,
    orElse: () => ChatRole.assistant,
  );
}

enum ChatMessageKind {
  text('texto'),
  report('reporte');

  const ChatMessageKind(this.value);
  final String value;

  static ChatMessageKind fromValue(String value) =>
      ChatMessageKind.values.firstWhere(
        (k) => k.value == value,
        orElse: () => ChatMessageKind.text,
      );
}

class ChatConversation {
  final String id;
  final String titulo;
  final DateTime creadaEn;
  final DateTime actualizadaEn;

  const ChatConversation({
    required this.id,
    required this.titulo,
    required this.creadaEn,
    required this.actualizadaEn,
  });
}

class ChatMessage {
  final String id;
  final String conversacionId;
  final ChatRole rol;
  final String contenido;
  final ChatMessageKind tipo;
  final Map<String, dynamic>? metadata;
  final DateTime creadoEn;

  /// Solo para mensajes optimistas que todavía no se guardaron.
  final bool pendiente;

  const ChatMessage({
    required this.id,
    required this.conversacionId,
    required this.rol,
    required this.contenido,
    this.tipo = ChatMessageKind.text,
    this.metadata,
    required this.creadoEn,
    this.pendiente = false,
  });

  bool get esUsuario => rol == ChatRole.user;
  bool get esReporte => tipo == ChatMessageKind.report;

  ChatMessage copyWith({
    String? contenido,
    ChatMessageKind? tipo,
    Map<String, dynamic>? metadata,
    bool? pendiente,
  }) {
    return ChatMessage(
      id: id,
      conversacionId: conversacionId,
      rol: rol,
      contenido: contenido ?? this.contenido,
      tipo: tipo ?? this.tipo,
      metadata: metadata ?? this.metadata,
      creadoEn: creadoEn,
      pendiente: pendiente ?? this.pendiente,
    );
  }

  String? get reporteClave => metadata?['reporte_clave'] as String?;

  Map<String, dynamic> toMap() => {
    'id': id,
    'conversacion_id': conversacionId,
    'rol': rol.value,
    'contenido': contenido,
    'tipo': tipo.value,
    'metadata': metadata == null ? null : jsonEncode(metadata),
    'creado_en': creadoEn.millisecondsSinceEpoch,
  };

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    final rawMetadata = map['metadata'] as String?;
    Map<String, dynamic>? metadata;
    if (rawMetadata != null && rawMetadata.isNotEmpty) {
      try {
        metadata = jsonDecode(rawMetadata) as Map<String, dynamic>;
      } catch (_) {
        metadata = null;
      }
    }
    return ChatMessage(
      id: map['id'] as String,
      conversacionId: map['conversacion_id'] as String,
      rol: ChatRole.fromValue(map['rol'] as String? ?? 'assistant'),
      contenido: map['contenido'] as String? ?? '',
      tipo: ChatMessageKind.fromValue(map['tipo'] as String? ?? 'texto'),
      metadata: metadata,
      creadoEn: DateTime.fromMillisecondsSinceEpoch(
        map['creado_en'] as int? ?? 0,
      ),
    );
  }
}
