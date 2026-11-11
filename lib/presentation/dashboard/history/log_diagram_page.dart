// Visor del diagrama de una generación (WebView) + descarga nativa.
//
// El lienzo se carga del sitio web en modo `view_only=true`, por lo que no
// necesita sesión: el snapshot sale de `GET /logs/public/:id`. La descarga,
// en cambio, se hace desde Flutter con la cookie de Dio.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:mobile/core/config/app_config.dart';
import 'package:mobile/core/files/download_saver.dart';
import 'package:mobile/data/models/log_models.dart';
import 'package:mobile/data/models/saved_download.dart';
import 'package:mobile/presentation/dashboard/history/download/log_download_sheet.dart';
import 'package:mobile/presentation/dashboard/history/logs_providers.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LogDiagramPage extends ConsumerStatefulWidget {
  const LogDiagramPage({super.key, required this.log});

  final LogGeneracion log;

  @override
  ConsumerState<LogDiagramPage> createState() => _LogDiagramPageState();
}

class _LogDiagramPageState extends ConsumerState<LogDiagramPage> {
  WebViewController? _controller;
  bool _cargando = true;
  String? _error;
  bool _descargando = false;

  bool get _webViewSoportado =>
      Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

  String get _url => AppConfig.diagramaUrl(widget.log.id);

  @override
  void initState() {
    super.initState();
    if (_webViewSoportado) {
      _inicializarWebView();
    } else {
      _cargando = false;
    }
  }

  void _inicializarWebView() {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Theme.of(context).colorScheme.surface)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (!mounted) return;
            final listo = progress >= 100;
            if (_cargando != !listo) {
              setState(() => _cargando = !listo);
            }
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _cargando = false);
          },
          onWebResourceError: (error) {
            if (!mounted || !error.isForMainFrame.orTrue) return;
            setState(() {
              _cargando = false;
              _error = error.description;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(_url));

    setState(() {
      _controller = controller;
      _error = null;
    });
  }

  Future<void> _recargar() async {
    if (_controller == null) {
      _inicializarWebView();
      return;
    }
    setState(() {
      _error = null;
      _cargando = true;
    });
    await _controller!.reload();
  }

  Future<void> _descargar() async {
    if (_descargando) return;

    final detalle = await _obtenerDetalle();
    if (!mounted) return;

    setState(() => _descargando = true);
    try {
      final archivo = await LogDownloadSheet.mostrar(context, detalle: detalle);
      if (!mounted || archivo == null) return;
      _mostrarDescarga(archivo);
    } finally {
      if (mounted) setState(() => _descargando = false);
    }
  }

  /// Detalle con la configuración de BD guardada. Si el endpoint falla se usa
  /// lo que ya tenemos del historial.
  Future<LogDetalle> _obtenerDetalle() async {
    try {
      return await ref.read(logDetallePublicoProvider(widget.log.id).future);
    } catch (_) {
      return LogDetalle(log: widget.log);
    }
  }

  void _mostrarDescarga(SavedDownload archivo) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          archivo.usoUbicacionPredeterminada
              ? 'Guardado por defecto en ${archivo.ubicacion}/${archivo.nombre}'
              : 'Guardado en ${archivo.ubicacion}/${archivo.nombre}',
        ),
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: 'Abrir',
          onPressed: () async {
            final result = await DownloadSaver.abrir(archivo);
            if (!mounted || result.type == ResultType.done) return;
            messenger.showSnackBar(SnackBar(content: Text(result.message)));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.log.proyectoNombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.log.tipoArtefacto?.nombre ?? 'Diagrama',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Recargar',
            onPressed: _recargar,
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            tooltip: 'Descargar',
            onPressed: _descargando ? null : _descargar,
            icon: _descargando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download_rounded),
          ),
        ],
      ),
      floatingActionButton: _error == null && _webViewSoportado
          ? FloatingActionButton.extended(
              onPressed: _descargando ? null : _descargar,
              icon: const Icon(Icons.download_rounded),
              label: const Text('Descargar'),
            )
          : null,
      body: _cuerpo(),
    );
  }

  Widget _cuerpo() {
    if (!_webViewSoportado) {
      return _AvisoVisorNoSoportado(url: _url);
    }
    if (_error != null) {
      return _AvisoErrorVisor(
        mensaje: _error!,
        url: _url,
        onReintentar: _recargar,
      );
    }

    final controller = _controller;
    if (controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (_cargando)
          const Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }
}

class _AvisoErrorVisor extends StatelessWidget {
  const _AvisoErrorVisor({
    required this.mensaje,
    required this.url,
    required this.onReintentar,
  });

  final String mensaje;
  final String url;
  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 44, color: colorScheme.error),
            const SizedBox(height: 12),
            Text(
              'No se pudo cargar el diagrama',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 6),
            SelectableText(
              url,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onReintentar,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvisoVisorNoSoportado extends StatelessWidget {
  const _AvisoVisorNoSoportado({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.desktop_windows_outlined,
              size: 44,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'El visor embebido solo está disponible en Android, iOS y macOS',
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Puedes abrir el diagrama en el navegador:',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 6),
            SelectableText(
              url,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on bool? {
  /// `isForMainFrame` puede venir null en algunas plataformas.
  bool get orTrue => this ?? true;
}
