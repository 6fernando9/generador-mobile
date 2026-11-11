// Asistente local de Kraken Draw: chat de uso/términos y reportes Pro.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:mobile/core/ai/assistant_model_manifest.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/data/models/chat_models.dart';
import 'package:mobile/main.dart' show AppBottomNavBar;
import 'package:mobile/presentation/auth/auth_wrapper.dart';
import 'package:mobile/presentation/chat/chat_controller.dart';
import 'package:mobile/presentation/shared/widgets/neon_background.dart';
import 'package:mobile/presentation/shared/widgets/neon_button.dart';
import 'package:mobile/presentation/shared/widgets/neon_card.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final FocusNode _focus = FocusNode();
  final SpeechToText _speech = SpeechToText();

  bool _listening = false;
  int _lastMessageCount = 0;

  static final DateFormat _hora = DateFormat('HH:mm');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatControllerProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _speech.cancel();
    _input.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatControllerProvider);
    final auth = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;

    ref.listen(chatControllerProvider, (previous, next) {
      if (previous == null) return;
      if (next.errorEnvio != null &&
          next.errorEnvio != previous.errorEnvio &&
          mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorEnvio!),
            backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final totalItems = state.mensajes.length + (state.generando ? 1 : 0);
    if (totalItems != _lastMessageCount) {
      _lastMessageCount = totalItems;
      _scheduleScroll();
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Asistente Kraken',
              style: GoogleFonts.orbitron(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StatusDot(
                  color: state.modeloListo
                      ? NeonColors.getNeon('green', isDark)
                      : Colors.orangeAccent,
                ),
                const SizedBox(width: 4),
                Text(
                  state.modeloListo
                      ? (auth.offline ? 'Local · sin conexión' : 'IA local')
                      : 'Modelo pendiente',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
                if (auth.offline) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.cloud_off_rounded,
                    size: 11,
                    color: Colors.orangeAccent.withValues(alpha: 0.9),
                  ),
                ],
              ],
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Conversaciones',
            icon: const Icon(Icons.forum_outlined),
            onPressed: () => _openHistory(context, state),
          ),
          IconButton(
            tooltip: 'Nueva conversación',
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: state.generando
                ? null
                : () => ref
                      .read(chatControllerProvider.notifier)
                      .nuevaConversacion(),
          ),
        ],
      ),
      body: NeonBackground(
        showParticles: false,
        animationDuration: const Duration(seconds: 10),
        child: SafeArea(
          child: Column(
            children: [
              if (state.setup != AssistantSetupStatus.listo)
                _SetupBanner(state: state, primary: primary),
              Expanded(
                child: state.mensajes.isEmpty && !state.generando
                    ? _Welcome(state: state, onSuggestion: _enviarSugerencia)
                    : ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                        itemCount: totalItems,
                        itemBuilder: (context, index) {
                          if (index < state.mensajes.length) {
                            final message = state.mensajes[index];
                            return _MessageBubble(
                              message: message,
                              hora: _hora.format(message.creadoEn),
                              onExport: (formato) => ref
                                  .read(chatControllerProvider.notifier)
                                  .exportarReporte(message, formato),
                            );
                          }
                          return _DraftBubble(
                            texto: state.borradorAsistente,
                            generando: state.generando,
                          );
                        },
                      ),
              ),
              _InputBar(
                controller: _input,
                focusNode: _focus,
                generando: state.generando,
                modeloListo: state.modeloListo,
                escuchando: _listening,
                onSend: _enviar,
                onStop: () => ref
                    .read(chatControllerProvider.notifier)
                    .detenerGeneracion(),
                onMic: _toggleListening,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  void _scheduleScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _enviar() async {
    final texto = _input.text.trim();
    if (texto.isEmpty) return;
    _input.clear();
    await ref.read(chatControllerProvider.notifier).enviar(texto);
  }

  Future<void> _enviarSugerencia(String texto) async {
    _input.text = texto;
    _input.selection = TextSelection.collapsed(offset: texto.length);
    await _enviar();
  }

  Future<void> _toggleListening() async {
    if (_listening) {
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }

    final disponible = await _speech.initialize(
      onStatus: (status) {
        if (!mounted) return;
        if (status == 'done' || status == 'notListening') {
          setState(() => _listening = false);
        }
      },
      onError: (error) {
        if (!mounted) return;
        setState(() => _listening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo usar el micrófono: ${error.errorMsg}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );

    if (!disponible) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El reconocimiento de voz no está disponible en este dispositivo.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _listening = true);
    await _speech.listen(
      onResult: (result) {
        if (!mounted) return;
        _input.text = result.recognizedWords;
        _input.selection = TextSelection.collapsed(offset: _input.text.length);
        if (result.finalResult) {
          setState(() => _listening = false);
        }
      },
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.dictation,
        pauseFor: const Duration(seconds: 4),
        listenFor: const Duration(seconds: 60),
      ),
    );
  }

  void _openHistory(BuildContext context, ChatState state) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Conversaciones',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ref
                              .read(chatControllerProvider.notifier)
                              .nuevaConversacion();
                        },
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Nueva'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.55,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.conversaciones.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final conversation = state.conversaciones[index];
                        final activa = conversation.id == state.conversacionId;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            activa
                                ? Icons.chat_bubble_rounded
                                : Icons.chat_bubble_outline_rounded,
                            color: activa
                                ? colorScheme.primary
                                : colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          title: Text(
                            conversation.titulo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontWeight: activa
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          subtitle: Text(
                            _hora.format(conversation.actualizadaEn),
                            style: GoogleFonts.inter(fontSize: 11),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            ref
                                .read(chatControllerProvider.notifier)
                                .seleccionarConversacion(conversation.id);
                          },
                          trailing: IconButton(
                            tooltip: 'Eliminar',
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 20,
                            ),
                            onPressed: () async {
                              await ref
                                  .read(chatControllerProvider.notifier)
                                  .eliminarConversacion(conversation.id);
                              if (context.mounted) Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 6),
        ],
      ),
    );
  }
}

class _SetupBanner extends ConsumerWidget {
  const _SetupBanner({required this.state, required this.primary});

  final ChatState state;
  final Color primary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(chatControllerProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    Widget content;
    switch (state.setup) {
      case AssistantSetupStatus.comprobando:
      case AssistantSetupStatus.verificando:
        content = Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                state.setup == AssistantSetupStatus.verificando
                    ? 'Verificando la integridad del modelo local…'
                    : 'Comprobando el modelo local…',
                style: GoogleFonts.inter(fontSize: 13),
              ),
            ),
          ],
        );
        break;
      case AssistantSetupStatus.noInstalado:
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.download_rounded, color: primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Preparando el modelo local',
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'La descarga de ${AssistantModelManifest.sizeLabel} inicia '
              'automáticamente. Se recomienda Wi-Fi. Puedes seguir usando el '
              'dashboard, el historial y los reportes mientras tanto.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 10),
            NeonButton(
              label: 'Descargar ahora',
              icon: Icons.cloud_download_rounded,
              style: NeonButtonStyle.primary,
              isFullWidth: true,
              onPressed: controller.descargarModelo,
            ),
            const SizedBox(height: 6),
            Text(
              'Los reportes no necesitan el modelo.',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        );
        break;
      case AssistantSetupStatus.descargando:
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Descargando modelo… ${state.progreso}%',
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: controller.cancelarDescarga,
                  child: const Text('Cancelar'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: state.progreso <= 0 ? null : state.progreso / 100,
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Mantén la app abierta. La descarga se puede reanudar.',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ],
        );
        break;
      case AssistantSetupStatus.error:
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.redAccent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No se pudo preparar el modelo',
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              state.setupError ?? 'Error desconocido',
              style: GoogleFonts.inter(fontSize: 12),
            ),
            const SizedBox(height: 10),
            NeonButton(
              label: 'Reintentar',
              icon: Icons.refresh_rounded,
              style: NeonButtonStyle.outline,
              isFullWidth: true,
              onPressed: controller.reintentarSetup,
            ),
          ],
        );
        break;
      case AssistantSetupStatus.listo:
        content = const SizedBox.shrink();
        break;
    }

    if (state.setup == AssistantSetupStatus.listo) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: GlowCard(
        glowColor: primary,
        padding: const EdgeInsets.all(14),
        child: content,
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({required this.state, required this.onSuggestion});

  final ChatState state;
  final Future<void> Function(String) onSuggestion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;

    final sugerencias = <String>[
      '¿Cómo genero un proyecto desde Kraken Draw?',
      '¿Qué datos personales guarda Kraken Draw?',
      '¿Dónde configuro usuarios y permisos?',
      if (state.puedeReportes) 'Lenguajes más usados este mes',
      if (state.puedeReportes) '¿Cuántas generaciones hice ayer?',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: primary.withValues(alpha: 0.12),
                  border: Border.all(color: primary.withValues(alpha: 0.35)),
                ),
                child: Icon(Icons.smart_toy_rounded, color: primary, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Hola, soy Kraken',
                  style: GoogleFonts.orbitron(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(duration: 350.ms),
          const SizedBox(height: 14),
          Text(
            'Te ayudo con el uso de la app, los términos y la privacidad. '
            '${state.puedeReportes ? 'También puedo generar reportes de tus métricas.' : 'Los reportes dinámicos requieren plan Pro.'}',
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.5,
              color: colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.modeloListo
                ? 'El asistente funciona en tu dispositivo, incluso sin internet.'
                : 'Descarga el modelo local para chatear sin internet. Los reportes funcionan sin el modelo.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Prueba con',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sugerencias
                .map(
                  (texto) => ActionChip(
                    avatar: Icon(
                      texto.toLowerCase().contains('reporte') ||
                              texto.toLowerCase().contains('generaciones') ||
                              texto.toLowerCase().contains('lenguajes')
                          ? Icons.insights_rounded
                          : Icons.help_outline_rounded,
                      size: 16,
                      color: primary,
                    ),
                    label: Text(texto, style: GoogleFonts.inter(fontSize: 12)),
                    onPressed: () => onSuggestion(texto),
                    side: BorderSide(color: primary.withValues(alpha: 0.25)),
                    backgroundColor: primary.withValues(alpha: 0.06),
                  ),
                )
                .toList(),
          ).animate().fadeIn(duration: 400.ms, delay: 120.ms),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.hora,
    required this.onExport,
  });

  final ChatMessage message;
  final String hora;
  final void Function(String formato) onExport;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = message.esUsuario;
    final primary = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;
    final reportColor = NeonColors.getNeon('green', isDark);

    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.82,
      ),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 9),
      decoration: BoxDecoration(
        color: user
            ? primary.withValues(alpha: isDark ? 0.22 : 0.16)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(user ? 16 : 4),
          bottomRight: Radius.circular(user ? 4 : 16),
        ),
        border: Border.all(
          color: user
              ? primary.withValues(alpha: 0.4)
              : colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.esReporte) ...[
            Row(
              children: [
                Icon(Icons.insights_rounded, size: 15, color: reportColor),
                const SizedBox(width: 6),
                Text(
                  'Reporte personal',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: reportColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          SelectableText(
            message.contenido,
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.45,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: user
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Text(
                hora,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: colorScheme.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
          if (message.esReporte) ...[
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => onExport('pdf'),
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 17),
                  label: Text('PDF', style: GoogleFonts.inter(fontSize: 12)),
                ),
                TextButton.icon(
                  onPressed: () => onExport('xlsx'),
                  icon: const Icon(Icons.table_view_outlined, size: 17),
                  label: Text('Excel', style: GoogleFonts.inter(fontSize: 12)),
                ),
              ],
            ),
          ],
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: user
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!user) ...[
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 8, top: 2),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(Icons.smart_toy_rounded, size: 16, color: primary),
            ),
          ],
          Flexible(
            child: bubble
                .animate()
                .fadeIn(duration: 180.ms)
                .slideY(begin: 0.08, end: 0, duration: 180.ms),
          ),
        ],
      ),
    );
  }
}

class _DraftBubble extends StatelessWidget {
  const _DraftBubble({required this.texto, required this.generando});

  final String texto;
  final bool generando;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(right: 8, top: 2),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(Icons.smart_toy_rounded, size: 16, color: primary),
          ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.82,
              ),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.9,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(16),
                ),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (texto.isNotEmpty)
                    Flexible(
                      child: Text(
                        texto,
                        style: GoogleFonts.inter(fontSize: 14, height: 1.45),
                      ),
                    )
                  else
                    Text(
                      generando ? 'Pensando' : '',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 12,
                    height: 16,
                    child: _BlinkingCursor(color: primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor({required this.color});

  final Color color;

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 2,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.generando,
    required this.modeloListo,
    required this.escuchando,
    required this.onSend,
    required this.onStop,
    required this.onMic,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool generando;
  final bool modeloListo;
  final bool escuchando;
  final VoidCallback onSend;
  final VoidCallback onStop;
  final VoidCallback onMic;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.96),
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 44),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: escuchando
                      ? primary.withValues(alpha: 0.6)
                      : colorScheme.outlineVariant.withValues(alpha: 0.6),
                ),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) {
                  if (!generando) onSend();
                },
                style: GoogleFonts.inter(fontSize: 14),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: escuchando
                      ? 'Escuchando…'
                      : modeloListo
                      ? 'Escribe o dicta tu pregunta'
                      : 'Pregunta o pide un reporte',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13,
                    color: colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          IconButton.filledTonal(
            tooltip: escuchando ? 'Detener dictado' : 'Dictar',
            onPressed: onMic,
            icon: Icon(
              escuchando ? Icons.stop_circle_outlined : Icons.mic_none_rounded,
            ),
          ),
          const SizedBox(width: 4),
          if (generando)
            IconButton.filled(
              tooltip: 'Detener respuesta',
              onPressed: onStop,
              icon: const Icon(Icons.stop_rounded),
            )
          else
            IconButton.filled(
              tooltip: 'Enviar',
              onPressed: onSend,
              icon: const Icon(Icons.send_rounded),
            ),
        ],
      ),
    );
  }
}
