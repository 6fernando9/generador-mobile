// Modal de regeneración de exportación (SQL por ahora) desde un log.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/files/download_saver.dart';
import 'package:mobile/data/models/exportacion_models.dart';
import 'package:mobile/data/models/log_models.dart';
import 'package:mobile/presentation/dashboard/history/download/download_providers.dart';
import 'package:mobile/presentation/dashboard/history/download/download_widgets.dart';
import 'package:mobile/presentation/dashboard/history/logs_providers.dart';
import 'package:mobile/presentation/shared/widgets/neon_button.dart';

/// Regenera la exportación SQL/XML del diagrama guardado.
class RegenerarReporteSheet extends ConsumerStatefulWidget {
  const RegenerarReporteSheet({super.key, required this.detalle});

  final LogDetalle detalle;

  /// Abre el modal y devuelve el archivo guardado, o null si se canceló.
  static Future<File?> mostrar(
    BuildContext context, {
    required LogDetalle detalle,
  }) {
    return showModalBottomSheet<File>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => RegenerarReporteSheet(detalle: detalle),
    );
  }

  @override
  ConsumerState<RegenerarReporteSheet> createState() =>
      _RegenerarReporteSheetState();
}

class _RegenerarReporteSheetState extends ConsumerState<RegenerarReporteSheet> {
  OpcionesExportacion? _opciones;
  bool _cargando = true;
  String? _errorCarga;

  int? _tipoReporteId;
  int? _baseDatosDestinoId;
  late final TextEditingController _nombreBd;

  bool _generando = false;
  String? _errorGeneracion;

  @override
  void initState() {
    super.initState();
    _nombreBd = TextEditingController(
      text: widget.detalle.log.proyectoNombre,
    );
    _cargarOpciones();
  }

  @override
  void dispose() {
    _nombreBd.dispose();
    super.dispose();
  }

  /// Por ahora solo se ofrecen reportes SQL.
  bool _esSql(TipoReporteOpcion tipo) =>
      tipo.nombreCode.toLowerCase() == 'sql';

  Future<void> _cargarOpciones() async {
    setState(() {
      _cargando = true;
      _errorCarga = null;
    });
    try {
      final opciones = await ref.read(exportacionServiceProvider).opciones();
      if (!mounted) return;
      setState(() {
        _opciones = opciones;
        _cargando = false;
      });
      _seleccionarInicial(opciones);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _errorCarga = mensajeDeError(error);
      });
    }
  }

  void _seleccionarInicial(OpcionesExportacion opciones) {
    final tipos = _tiposReporte(opciones);
    if (tipos.isEmpty) return;

    final log = widget.detalle.log;
    final tipo = tipos.firstWhere(
      (t) => t.id == log.tipoReporteId,
      orElse: () => tipos.first,
    );
    setState(() {
      _tipoReporteId = tipo.id;
      _baseDatosDestinoId = _baseDestinoInicial(tipo, log.baseDatosId);
    });
  }

  int? _baseDestinoInicial(TipoReporteOpcion tipo, int? baseDatosId) {
    if (tipo.hijas.isEmpty) return null;
    for (final hija in tipo.hijas) {
      if (hija.id == baseDatosId) return hija.id;
    }
    for (final hija in tipo.hijas) {
      if (hija.nombreCode.toLowerCase() == 'postgresql') return hija.id;
    }
    return tipo.hijas.length == 1 ? tipo.hijas.first.id : null;
  }

  List<TipoReporteOpcion> _tiposReporte(OpcionesExportacion opciones) {
    final tipos = <TipoReporteOpcion>[];
    for (final artefacto in opciones.tiposArtefacto) {
      for (final tipo in artefacto.tiposReporte) {
        if (_esSql(tipo)) tipos.add(tipo);
      }
    }
    return tipos;
  }

  TipoReporteOpcion? get _tipoReporte {
    final opciones = _opciones;
    if (opciones == null) return null;
    for (final tipo in _tiposReporte(opciones)) {
      if (tipo.id == _tipoReporteId) return tipo;
    }
    return null;
  }

  Future<void> _generar() async {
    final tipo = _tipoReporte;
    if (tipo == null) {
      setState(() => _errorGeneracion = 'Selecciona un tipo de reporte');
      return;
    }
    if (_baseDatosDestinoId == null) {
      setState(
        () => _errorGeneracion = 'Selecciona una base de datos destino',
      );
      return;
    }

    setState(() {
      _generando = true;
      _errorGeneracion = null;
    });

    try {
      final archivo = await ref
          .read(logsServiceProvider)
          .regenerarReporte(
            widget.detalle.log.id,
            tipoReporteId: tipo.id,
            baseDatosDestinoId: _baseDatosDestinoId,
            dbName: _nombreBd.text,
          );

      final nombre =
          archivo.nombreSugerido ??
          DownloadSaver.nombreSeguro(
            _nombreBd.text.trim().isEmpty
                ? widget.detalle.log.proyectoNombre
                : _nombreBd.text,
            extension: 'sql',
          );
      final guardado = await DownloadSaver.guardar(
        bytes: archivo.bytes,
        nombreArchivo: nombre,
      );

      if (!mounted) return;
      Navigator.of(context).pop(guardado);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _generando = false;
        _errorGeneracion = mensajeDeError(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.62,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SheetEncabezado(
              icono: Icons.table_chart_outlined,
              titulo: 'Regenerar exportación SQL',
              subtitulo: widget.detalle.log.proyectoNombre,
            ),
            if (_cargando) const LinearProgressIndicator(minHeight: 2),
            Expanded(child: _contenido()),
            _pie(),
          ],
        ),
      ),
    );
  }

  Widget _contenido() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorCarga != null) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SheetError(mensaje: _errorCarga!, onReintentar: _cargarOpciones),
      );
    }

    final opciones = _opciones;
    final tipos = opciones == null
        ? const <TipoReporteOpcion>[]
        : _tiposReporte(opciones);
    if (tipos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No hay tipos de reporte SQL disponibles.'),
      );
    }

    final tipo = _tipoReporte ?? tipos.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CampoDropdown(
            label: 'Tipo de reporte',
            icono: Icons.description_outlined,
            valor: tipo.id,
            items: [
              for (final t in tipos) (id: t.id, nombre: t.nombre),
            ],
            onChanged: (value) => setState(() {
              _tipoReporteId = value;
              final elegido = _tipoReporte;
              _baseDatosDestinoId = elegido == null
                  ? null
                  : _baseDestinoInicial(elegido, null);
            }),
          ),
          const SizedBox(height: 12),
          CampoDropdown(
            label: 'Base de datos destino',
            icono: Icons.dns_outlined,
            valor: _baseDatosDestinoId,
            items: [
              for (final hija in tipo.hijas)
                (id: hija.id, nombre: hija.nombre),
            ],
            onChanged: (value) => setState(() => _baseDatosDestinoId = value),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nombreBd,
            decoration: decoracionCampo(
              context,
              label: 'Nombre de la base de datos',
              hint: 'nombre_db',
              icon: Icons.storage_outlined,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _generar(),
          ),
          const SizedBox(height: 8),
          Text(
            'El archivo se genera desde el diagrama guardado de esta generación.',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          if (_errorGeneracion != null) ...[
            const SizedBox(height: 16),
            SheetError(mensaje: _errorGeneracion!),
          ],
        ],
      ),
    );
  }

  Widget _pie() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: NeonButton(
        label: 'Regenerar y descargar',
        icon: Icons.download_rounded,
        isFullWidth: true,
        isLoading: _generando,
        onPressed: _cargando || _errorCarga != null ? null : _generar,
      ),
    );
  }
}
