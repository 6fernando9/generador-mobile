import 'dart:async';
import 'dart:math';

import 'package:flutter_edge_ai/flutter_edge_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/ai/assistant_engine.dart';
import 'package:mobile/core/ai/assistant_knowledge.dart';
import 'package:mobile/core/auth/entitlements.dart';
import 'package:mobile/core/export/report_exporter.dart';
import 'package:mobile/core/files/download_saver.dart';
import 'package:mobile/core/report/report_coordinator.dart';
import 'package:mobile/core/report/report_intent_parser.dart';
import 'package:mobile/core/storage/local_database.dart';
import 'package:mobile/data/models/chat_models.dart';
import 'package:mobile/data/models/report_models.dart';
import 'package:mobile/data/models/saved_download.dart';
import 'package:open_filex/open_filex.dart';
import 'package:mobile/presentation/auth/auth_wrapper.dart';

enum AssistantSetupStatus {
  comprobando,
  noInstalado,
  descargando,
  verificando,
  listo,
  error,
}

class ChatState {
  final AssistantSetupStatus setup;
  final int progreso;
  final String? setupError;

  final List<ChatConversation> conversaciones;
  final String? conversacionId;
  final List<ChatMessage> mensajes;

  final bool generando;
  final String borradorAsistente;
  final String? errorEnvio;

  final bool offline;
  final bool puedeReportes;

  const ChatState({
    this.setup = AssistantSetupStatus.comprobando,
    this.progreso = 0,
    this.setupError,
    this.conversaciones = const [],
    this.conversacionId,
    this.mensajes = const [],
    this.generando = false,
    this.borradorAsistente = '',
    this.errorEnvio,
    this.offline = false,
    this.puedeReportes = false,
  });

  ChatState copyWith({
    AssistantSetupStatus? setup,
    int? progreso,
    Object? setupError = _unset,
    List<ChatConversation>? conversaciones,
    Object? conversacionId = _unset,
    List<ChatMessage>? mensajes,
    bool? generando,
    String? borradorAsistente,
    Object? errorEnvio = _unset,
    bool? offline,
    bool? puedeReportes,
  }) {
    return ChatState(
      setup: setup ?? this.setup,
      progreso: progreso ?? this.progreso,
      setupError: identical(setupError, _unset)
          ? this.setupError
          : setupError as String?,
      conversaciones: conversaciones ?? this.conversaciones,
      conversacionId: identical(conversacionId, _unset)
          ? this.conversacionId
          : conversacionId as String?,
      mensajes: mensajes ?? this.mensajes,
      generando: generando ?? this.generando,
      borradorAsistente: borradorAsistente ?? this.borradorAsistente,
      errorEnvio: identical(errorEnvio, _unset)
          ? this.errorEnvio
          : errorEnvio as String?,
      offline: offline ?? this.offline,
      puedeReportes: puedeReportes ?? this.puedeReportes,
    );
  }

  bool get modeloListo => setup == AssistantSetupStatus.listo;
}

const Object _unset = Object();

final chatControllerProvider = NotifierProvider<ChatController, ChatState>(
  ChatController.new,
);

class ChatController extends Notifier<ChatState> {
  final AssistantEngine _engine = AssistantEngine.instance;
  final ReportCoordinator _reports = ReportCoordinator();
  final Random _random = Random();

  InferenceChat? _chat;
  CancelToken? _cancelToken;
  bool _initialized = false;
  String? _sessionUserId;
  bool _autoDownloadAttempted = false;

  String get _currentUserId {
    final user = ref.read(authControllerProvider).user;
    return user?.id?.toString() ?? user?.username ?? 'unknown';
  }

  @override
  ChatState build() {
    ref.onDispose(() {
      _cancelToken?.cancel('Pantalla cerrada');
      _chat?.close();
      _chat = null;
    });
    return const ChatState();
  }

  Future<void> initialize() async {
    final userId = _currentUserId;

    // Al cambiar de cuenta se descarta todo el estado en memoria. La base ya
    // filtra por usuario, pero el chat del modelo y los mensajes visibles
    // también deben quedar limpios.
    if (_initialized && _sessionUserId == userId) return;

    if (_sessionUserId != null && _sessionUserId != userId) {
      await _closeChat();
      _autoDownloadAttempted = false;
      state = const ChatState();
    }

    _initialized = true;
    _sessionUserId = userId;

    _syncPermissions();
    await _loadConversations();
    await _checkModel();
  }

  void _syncPermissions() {
    final auth = ref.read(authControllerProvider);
    state = state.copyWith(
      offline: auth.offline,
      puedeReportes: auth.user?.puedeReportes ?? false,
    );
  }

  Future<void> _loadConversations() async {
    try {
      final userId = _currentUserId;
      final conversaciones = await LocalDatabase.instance.listConversations(
        userId,
      );
      if (conversaciones.isEmpty) {
        final conversation = await _createConversation(userId);
        state = state.copyWith(
          conversaciones: [conversation],
          conversacionId: conversation.id,
          mensajes: const [],
        );
        return;
      }
      final actual = conversaciones.first;
      final mensajes = await LocalDatabase.instance.listMessages(
        userId,
        actual.id,
      );
      state = state.copyWith(
        conversaciones: conversaciones,
        conversacionId: actual.id,
        mensajes: mensajes,
      );
    } catch (_) {
      state = state.copyWith(
        errorEnvio: 'No se pudo abrir el historial local.',
      );
    }
  }

  Future<ChatConversation> _createConversation(String userId) async {
    final now = DateTime.now();
    final conversation = ChatConversation(
      id: _id(),
      titulo: 'Nueva conversación',
      creadaEn: now,
      actualizadaEn: now,
    );
    await LocalDatabase.instance.insertConversation(conversation, userId);
    return conversation;
  }

  Future<void> _checkModel() async {
    state = state.copyWith(
      setup: AssistantSetupStatus.comprobando,
      setupError: null,
    );
    try {
      await _engine.initialize();
      final installed = await _engine.isInstalled();
      if (!installed) {
        state = state.copyWith(setup: AssistantSetupStatus.noInstalado);
        // La descarga arranca sola: el usuario no tiene que pulsar nada.
        if (!_autoDownloadAttempted) {
          _autoDownloadAttempted = true;
          unawaited(descargarModelo());
        }
        return;
      }
      state = state.copyWith(setup: AssistantSetupStatus.verificando);
      await _engine.verifyInstalled();
      state = state.copyWith(setup: AssistantSetupStatus.listo);
    } catch (e) {
      state = state.copyWith(
        setup: AssistantSetupStatus.error,
        setupError: _friendlyError(e),
      );
    }
  }

  Future<void> reintentarSetup() {
    _autoDownloadAttempted = false;
    return _checkModel();
  }

  Future<void> descargarModelo() async {
    if (state.setup == AssistantSetupStatus.descargando) return;
    state = state.copyWith(
      setup: AssistantSetupStatus.descargando,
      progreso: 0,
      setupError: null,
    );
    _cancelToken = CancelToken();
    try {
      await _engine.download(
        cancelToken: _cancelToken,
        onProgress: (percent) {
          if (!ref.mounted) return;
          state = state.copyWith(progreso: percent);
        },
      );
      if (!ref.mounted) return;
      state = state.copyWith(setup: AssistantSetupStatus.listo, progreso: 100);
    } on DownloadCancelledException {
      if (!ref.mounted) return;
      state = state.copyWith(
        setup: AssistantSetupStatus.noInstalado,
        progreso: 0,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        setup: AssistantSetupStatus.error,
        setupError: _friendlyError(e),
      );
    } finally {
      _cancelToken = null;
    }
  }

  void cancelarDescarga() {
    _cancelToken?.cancel('Descarga cancelada por el usuario');
  }

  Future<void> nuevaConversacion() async {
    await _closeChat();
    final userId = _currentUserId;
    final conversation = await _createConversation(userId);
    final conversaciones = await LocalDatabase.instance.listConversations(
      userId,
    );
    state = state.copyWith(
      conversaciones: conversaciones,
      conversacionId: conversation.id,
      mensajes: const [],
      errorEnvio: null,
      borradorAsistente: '',
    );
  }

  Future<void> seleccionarConversacion(String id) async {
    if (id == state.conversacionId || state.generando) return;
    await _closeChat();
    final userId = _currentUserId;
    final mensajes = await LocalDatabase.instance.listMessages(userId, id);
    await LocalDatabase.instance.touchConversation(userId, id);
    final conversaciones = await LocalDatabase.instance.listConversations(
      userId,
    );
    state = state.copyWith(
      conversaciones: conversaciones,
      conversacionId: id,
      mensajes: mensajes,
      errorEnvio: null,
      borradorAsistente: '',
    );
  }

  Future<void> eliminarConversacion(String id) async {
    final userId = _currentUserId;
    await LocalDatabase.instance.deleteConversation(userId, id);
    final conversaciones = await LocalDatabase.instance.listConversations(
      userId,
    );
    if (id == state.conversacionId) {
      await _closeChat();
      if (conversaciones.isEmpty) {
        final conversation = await _createConversation(userId);
        state = state.copyWith(
          conversaciones: [conversation],
          conversacionId: conversation.id,
          mensajes: const [],
        );
        return;
      }
      final siguiente = conversaciones.first;
      final mensajes = await LocalDatabase.instance.listMessages(
        userId,
        siguiente.id,
      );
      state = state.copyWith(
        conversaciones: conversaciones,
        conversacionId: siguiente.id,
        mensajes: mensajes,
      );
      return;
    }
    state = state.copyWith(conversaciones: conversaciones);
  }

  Future<void> enviar(String texto) async {
    final contenido = texto.trim();
    if (contenido.isEmpty || state.generando) return;

    _syncPermissions();
    final conversationId = state.conversacionId;
    if (conversationId == null) return;
    final userId = _currentUserId;

    final userMessage = ChatMessage(
      id: _id(),
      conversacionId: conversationId,
      rol: ChatRole.user,
      contenido: contenido,
      creadoEn: DateTime.now(),
    );
    await LocalDatabase.instance.insertMessage(userMessage, userId);
    await LocalDatabase.instance.touchConversation(
      userId,
      conversationId,
      titulo: _tituloDesde(contenido),
      actualizadaEn: userMessage.creadoEn,
    );
    final conversaciones = await LocalDatabase.instance.listConversations(
      userId,
    );

    state = state.copyWith(
      mensajes: [...state.mensajes, userMessage],
      conversaciones: conversaciones,
      generando: true,
      borradorAsistente: '',
      errorEnvio: null,
    );

    final intent = ReportIntentParser.parse(contenido);
    if (await _responderConsultaRegeneraciones(
      contenido,
      conversationId,
      userId,
    )) {
      return;
    }
    if (intent != null) {
      await _responderReporte(intent, conversationId, userId);
      return;
    }

    await _responderConModelo(conversationId, contenido, userMessage.id);
  }

  Future<bool> _responderConsultaRegeneraciones(
    String contenido,
    String conversationId,
    String userId,
  ) async {
    final consulta = _normalizarConsulta(contenido);
    final mencionaArchivo = RegExp(r'\b(archivo|zip|sql|proyecto|regener)\w*\b')
        .hasMatch(consulta);
    final preguntaUbicacion = RegExp(r'\b(donde|ubicacion|ruta)\w*\b')
        .hasMatch(consulta);
    final preguntaGuardado = RegExp(r'\b(guard|descarg)\w*\b')
        .hasMatch(consulta);
    final preguntaAbrir = RegExp(r'\b(abr|encuentr|buscar|busco)\w*\b')
        .hasMatch(consulta);
    if (!((preguntaUbicacion && (mencionaArchivo || preguntaGuardado)) ||
        (preguntaAbrir && mencionaArchivo))) {
      return false;
    }

    final historial = await LocalDatabase.instance.listSavedDownloads(userId);
    if (historial.isEmpty) {
      await _guardarAsistente(
        conversationId,
        'Todavía no hay regeneraciones guardadas en este dispositivo. '
        'Al regenerar un proyecto ZIP o un SQL puedes elegir dónde guardarlo; '
        'si cierras el selector, KrakenDraw lo guarda en su carpeta '
        'predeterminada.',
      );
      return true;
    }

    final sql = RegExp(r'\b(sql|script|base de datos)\b').hasMatch(consulta);
    final zip = RegExp(r'\b(zip|proyecto|backend|frontend|mobile)\b')
        .hasMatch(consulta);
    var opciones = historial;
    if (sql) {
      opciones = historial.where((item) => item.extension == 'sql').toList();
    } else if (zip) {
      opciones = historial.where((item) => item.extension == 'zip').toList();
    }

    final archivo =
        _buscarRegeneracion(opciones, consulta) ??
        (opciones.isEmpty ? null : opciones.first);
    if (archivo == null) {
      final solicitado = sql ? 'SQL' : 'ZIP';
      await _guardarAsistente(
        conversationId,
        'No encuentro regeneraciones $solicitado recientes en este dispositivo. '
        'El historial local conserva las últimas 20 descargas de esta cuenta.',
      );
      return true;
    }

    final texto =
        'Encontré ${archivo.nombre} (${archivo.tipo}). '
        'Se guardó en ${archivo.ubicacion}/${archivo.nombre}. '
        'Puedes abrirlo desde aquí o desde esa ubicación en este dispositivo.';
    await _guardarAsistente(
      conversationId,
      texto,
      metadata: {'regeneracion_id': archivo.id},
    );
    return true;
  }

  SavedDownload? _buscarRegeneracion(
    List<SavedDownload> opciones,
    String consulta,
  ) {
    if (opciones.isEmpty) return null;
    for (final archivo in opciones) {
      final base = archivo.nombre.toLowerCase().replaceAll(
        RegExp(r'\.(zip|sql)$'),
        '',
      );
      if (base.isNotEmpty && consulta.contains(_normalizarConsulta(base))) {
        return archivo;
      }
    }

    const ignoradas = {
      'donde',
      'esta',
      'quedo',
      'guarde',
      'guardado',
      'descargue',
      'archivo',
      'proyecto',
      'ultimo',
      'ultima',
      'abrir',
      'encuentro',
      'busco',
      'por',
      'favor',
      'el',
      'la',
      'los',
      'las',
      'un',
      'una',
      'de',
      'del',
      'mi',
      'mis',
      'sql',
      'zip',
      'regeneracion',
      'regeneraciones',
      'descarga',
    };
    final palabras = consulta
        .split(RegExp(r'[^a-z0-9]+'))
        .where((palabra) => palabra.length >= 4 && !ignoradas.contains(palabra))
        .toList();
    SavedDownload? mejor;
    var puntajeMejor = 0;
    for (final archivo in opciones) {
      final nombre = _normalizarConsulta(archivo.nombre);
      final puntaje = palabras.where(nombre.contains).length;
      if (puntaje > puntajeMejor) {
        puntajeMejor = puntaje;
        mejor = archivo;
      }
    }
    return mejor;
  }

  String _normalizarConsulta(String texto) {
    const conAcentos = 'áéíóúüñ';
    const sinAcentos = 'aeiouun';
    var salida = texto.toLowerCase();
    for (var i = 0; i < conAcentos.length; i++) {
      salida = salida.replaceAll(conAcentos[i], sinAcentos[i]);
    }
    return salida.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  Future<void> abrirRegeneracion(String id) async {
    try {
      final archivo = await LocalDatabase.instance.getSavedDownload(
        _currentUserId,
        id,
      );
      if (archivo == null) {
        state = state.copyWith(
          errorEnvio: 'Esta regeneración ya no está en el historial local.',
        );
        return;
      }
      final resultado = await DownloadSaver.abrir(archivo);
      if (resultado.type != ResultType.done) {
        final mensaje = switch (resultado.type) {
          ResultType.fileNotFound =>
            'El archivo ya no está disponible en su ubicación guardada.',
          ResultType.noAppToOpen =>
            'No hay una aplicación instalada para abrir este archivo.',
          ResultType.permissionDenied =>
            'El sistema no permitió acceder al archivo.',
          ResultType.error => 'El sistema no pudo abrir el archivo.',
          ResultType.done => resultado.message,
        };
        state = state.copyWith(errorEnvio: mensaje);
      }
    } catch (error) {
      state = state.copyWith(
        errorEnvio: 'No se pudo abrir el archivo: ${_friendlyError(error)}',
      );
    }
  }

  Future<void> _responderReporte(
    ReportIntent intent,
    String conversationId,
    String userId,
  ) async {
    final auth = ref.read(authControllerProvider);
    final permitido = await Entitlements.puedeReportes(
      perfil: auth.user,
      offline: auth.offline,
    );

    if (!permitido) {
      await _guardarAsistente(
        conversationId,
        'Los reportes dinámicos están disponibles solo con el plan Pro. '
        'Puedes seguir usando el dashboard y el historial, y consultar tu plan '
        'en Perfil. Si crees que es un error, revisa tu suscripción en el '
        'panel web de Kraken Draw.',
      );
      return;
    }

    try {
      final result = await _reports.consultar(
        intent,
        permitido: permitido,
        offline: auth.offline,
        userId: userId,
      );

      final partes = <String>[result.textoCuerpo];
      for (final extra in intent.extras) {
        try {
          final adicional = await _reports.consultar(
            ReportIntent(
              metrica: extra.metrica,
              categoria: extra.categoria,
              rango: intent.rango,
              descripcion: extra.metrica,
              topN: intent.topN,
              comparar: intent.comparar,
            ),
            permitido: permitido,
            offline: auth.offline,
            userId: userId,
          );
          partes.add(adicional.textoCuerpo);
        } catch (_) {
          partes.add(
            'No pude obtener la parte "${extra.metrica}" del reporte.',
          );
        }
      }

      final texto = '${partes.join('\n\n')}\n\n${result.sello}';

      await _guardarAsistente(
        conversationId,
        texto,
        tipo: ChatMessageKind.report,
        metadata: {
          'reporte_clave': result.clave,
          'metrica': result.intent.metrica,
          'categoria': result.intent.categoria,
          'top_n': result.intent.topN,
          'descripcion': result.intent.descripcion,
          'generado_en': result.reporte.generadoEn.toIso8601String(),
          'desde_cache': result.desdeCache,
          'rango': result.reporte.rango.toJson(),
          'texto': texto,
        },
      );
    } on ReportAccessDeniedException {
      await _guardarAsistente(
        conversationId,
        'El servidor indicó que tu cuenta no tiene acceso a reportes. '
        'Verifica tu plan Pro en el panel web de Kraken Draw.',
      );
    } on ReportOfflineNoCacheException {
      await _guardarAsistente(
        conversationId,
        'No hay datos guardados para ese período. Para generar este reporte '
        'necesitas conexión a internet.',
      );
    } catch (e) {
      await _guardarAsistente(
        conversationId,
        'No pude obtener el reporte. Revisa tu conexión e inténtalo de nuevo. '
        '${_friendlyError(e)}',
      );
    }
  }

  Future<void> _responderConModelo(
    String conversationId,
    String contenido,
    String userMessageId,
  ) async {
    if (state.setup != AssistantSetupStatus.listo) {
      await _guardarAsistente(
        conversationId,
        'El modelo local todavía no está disponible. Se está descargando; '
        'en cuanto termine podrás conversar sin conexión. También puedes '
        'pedir un reporte mientras tanto.',
      );
      return;
    }

    try {
      final chat = await _obtenerChat(
        conversationId,
        excludeMessageId: userMessageId,
      );

      // flutter_edge_ai exige preparar el turno del usuario antes de generar.
      // Sin esta línea el modelo nunca recibe la pregunta actual.
      await chat.addQueryChunk(Message.text(text: contenido, isUser: true));

      final buffer = StringBuffer();
      final stream = chat.generateChatResponseAsync();
      await for (final response in stream) {
        if (!ref.mounted) break;
        if (response is TextResponse) {
          buffer.write(response.token);
          state = state.copyWith(borradorAsistente: buffer.toString());
        }
      }
      final texto = buffer.toString().trim();
      if (!ref.mounted) return;
      state = state.copyWith(borradorAsistente: '');
      await _guardarAsistente(
        conversationId,
        texto.isEmpty
            ? 'No pude generar una respuesta. Intenta reformular la pregunta.'
            : texto,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(borradorAsistente: '');
      await _guardarAsistente(
        conversationId,
        'No pude completar la respuesta local. ${_friendlyError(e)}',
      );
    }
  }

  Future<InferenceChat> _obtenerChat(
    String conversationId, {
    String? excludeMessageId,
  }) async {
    final existing = _chat;
    if (existing != null) return existing;

    final systemPrompt = await AssistantKnowledge.systemPrompt();
    final chat = await _engine.openChat(systemInstruction: systemPrompt);

    // Replay corto del historial para dar contexto. Se excluye el mensaje
    // actual porque se añade justo después como turno del usuario.
    final userId = _currentUserId;
    final previos = await LocalDatabase.instance.listMessages(
      userId,
      conversationId,
      limit: 9,
    );
    for (final message in previos) {
      if (message.id == excludeMessageId) continue;
      if (message.contenido.trim().isEmpty) continue;
      await chat.addQueryChunk(
        Message.text(text: message.contenido, isUser: message.esUsuario),
      );
    }

    _chat = chat;
    return chat;
  }

  Future<void> _closeChat() async {
    final chat = _chat;
    _chat = null;
    if (chat != null) {
      try {
        await chat.close();
      } catch (_) {}
    }
  }

  Future<void> detenerGeneracion() async {
    try {
      await _chat?.stopGeneration();
    } catch (_) {}
  }

  Future<void> _guardarAsistente(
    String conversationId,
    String contenido, {
    ChatMessageKind tipo = ChatMessageKind.text,
    Map<String, dynamic>? metadata,
  }) async {
    final userId = _currentUserId;
    final message = ChatMessage(
      id: _id(),
      conversacionId: conversationId,
      rol: ChatRole.assistant,
      contenido: contenido,
      tipo: tipo,
      metadata: metadata,
      creadoEn: DateTime.now(),
    );
    await LocalDatabase.instance.insertMessage(message, userId);
    await LocalDatabase.instance.touchConversation(userId, conversationId);
    if (!ref.mounted) return;
    state = state.copyWith(
      mensajes: [...state.mensajes, message],
      generando: false,
      borradorAsistente: '',
    );
  }

  void limpiarError() {
    state = state.copyWith(errorEnvio: null);
  }

  Future<void> exportarReporte(ChatMessage message, String formato) async {
    final clave = message.reporteClave;
    if (clave == null) return;
    final cached = await LocalDatabase.instance.getReport(clave);
    if (cached == null) {
      state = state.copyWith(
        errorEnvio: 'El reporte ya no está en la caché local.',
      );
      return;
    }
    final metadata = message.metadata ?? const {};
    final rangoJson = metadata['rango'];
    final rango = rangoJson is Map
        ? ReportRange(
            desde:
                DateTime.tryParse('${rangoJson['desde']}') ??
                cached.rango.desde,
            hasta:
                DateTime.tryParse('${rangoJson['hasta']}') ??
                cached.rango.hasta,
            tz: '${rangoJson['tz'] ?? cached.rango.tz}',
          )
        : cached.rango;
    final intent = ReportIntent(
      metrica: cached.metrica,
      categoria: cached.categoria,
      rango: rango,
      descripcion: '${metadata['descripcion'] ?? 'Reporte'}',
      topN: metadata['top_n'] as int?,
    );
    final result = ReportResult(
      intent: intent,
      reporte: cached.toReporte(),
      desdeCache: metadata['desde_cache'] == true,
      textoPersonalizado: metadata['texto'] as String?,
    );

    try {
      if (formato == 'pdf') {
        final file = await ReportExporter.buildPdf(
          result: result,
          username:
              ref.read(authControllerProvider).user?.username ?? 'Usuario',
        );
        await ReportExporter.shareFile(file);
      } else {
        final file = await ReportExporter.buildExcel(result);
        await ReportExporter.shareFile(file);
      }
    } catch (e) {
      state = state.copyWith(errorEnvio: 'No se pudo exportar: $e');
    }
  }

  String _id() =>
      '${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(1 << 20)}';

  String _tituloDesde(String texto) {
    final limpio = texto.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (limpio.length <= 44) return limpio;
    return '${limpio.substring(0, 44)}…';
  }

  String _friendlyError(Object error) {
    final text = error.toString();
    if (text.contains('No space left')) {
      return 'No hay espacio suficiente en el dispositivo.';
    }
    if (text.contains('SocketException') || text.contains('network')) {
      return 'Sin conexión a internet.';
    }
    if (text.length > 240) return '${text.substring(0, 240)}…';
    return text;
  }
}
