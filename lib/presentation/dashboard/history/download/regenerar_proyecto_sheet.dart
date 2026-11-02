// Modal de regeneración de proyecto (ZIP) desde el snapshot de un log.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/files/download_saver.dart';
import 'package:mobile/data/models/generacion_models.dart';
import 'package:mobile/data/models/log_models.dart';
import 'package:mobile/presentation/dashboard/history/download/download_providers.dart';
import 'package:mobile/presentation/dashboard/history/download/download_widgets.dart';
import 'package:mobile/presentation/dashboard/history/logs_providers.dart';
import 'package:mobile/presentation/shared/widgets/neon_button.dart';

/// Regenera backend / frontend / mobile a partir del diagrama guardado.
class RegenerarProyectoSheet extends ConsumerStatefulWidget {
  const RegenerarProyectoSheet({super.key, required this.detalle});

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
      builder: (_) => RegenerarProyectoSheet(detalle: detalle),
    );
  }

  @override
  ConsumerState<RegenerarProyectoSheet> createState() =>
      _RegenerarProyectoSheetState();
}

class _RegenerarProyectoSheetState
    extends ConsumerState<RegenerarProyectoSheet> {
  OpcionesGeneracion? _opciones;
  bool _cargando = true;
  String? _errorCarga;

  int? _tipoId;
  int? _lenguajeId;
  int? _frameworkId;
  int? _ormId;
  int? _arquitecturaId;
  int? _baseDatosId;

  late final TextEditingController _host;
  late final TextEditingController _nombreBd;
  late final TextEditingController _usuario;
  late final TextEditingController _password;
  late final TextEditingController _puerto;

  bool _generando = false;
  String? _errorGeneracion;

  @override
  void initState() {
    super.initState();
    final config = widget.detalle.databaseConfiguration;
    _host = TextEditingController(text: config?.host ?? '');
    _nombreBd = TextEditingController(text: config?.name ?? '');
    _usuario = TextEditingController(text: config?.user ?? '');
    _password = TextEditingController(text: config?.password ?? '');
    _puerto = TextEditingController(text: config?.port ?? '5432');
    _cargarOpciones();
  }

  @override
  void dispose() {
    _host.dispose();
    _nombreBd.dispose();
    _usuario.dispose();
    _password.dispose();
    _puerto.dispose();
    super.dispose();
  }

  Future<void> _cargarOpciones() async {
    setState(() {
      _cargando = true;
      _errorCarga = null;
    });
    try {
      final opciones = await ref.read(generacionServiceProvider).opciones();
      if (!mounted) return;
      setState(() {
        _opciones = opciones;
        _cargando = false;
      });
      _seleccionarTipoInicial();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _errorCarga = mensajeDeError(error);
      });
    }
  }

  void _seleccionarTipoInicial() {
    final opciones = _opciones;
    if (opciones == null || opciones.tiposArtefacto.isEmpty) return;

    final log = widget.detalle.log;
    final tipo = opciones.tiposArtefacto.firstWhere(
      (t) => t.id == log.tipoArtefactoId,
      orElse: () => opciones.tiposArtefacto.first,
    );
    _cambiarTipo(tipo.id);
  }

  void _cambiarTipo(int? id) {
    final opciones = _opciones;
    if (opciones == null || opciones.tiposArtefacto.isEmpty) return;

    final tipo = _tipoPorId(id) ?? opciones.tiposArtefacto.first;
    final log = widget.detalle.log;

    final lenguaje = _buscar(
      tipo.lenguajes,
      log.lenguajeId,
      unicoSiSoloHayUno: true,
    );
    final framework = _buscar(
      lenguaje?.frameworks ?? const <OpcionFramework>[],
      log.frameworkId,
      unicoSiSoloHayUno: true,
    );
    final orm = tipo.requiere.orm
        ? _buscar(
            framework?.orms ?? const <OpcionDimension>[],
            log.ormId,
            unicoSiSoloHayUno: true,
          )
        : null;
    final arquitectura = tipo.requiere.arquitectura
        ? _buscar(
            tipo.arquitecturas,
            log.arquitecturaId,
            unicoSiSoloHayUno: true,
          )
        : null;
    final baseDatos = tipo.requiere.baseDatos
        ? _buscar(
            opciones.basesDatosDestino,
            log.baseDatosId,
            unicoSiSoloHayUno: true,
          )
        : null;

    setState(() {
      _tipoId = tipo.id;
      _lenguajeId = lenguaje?.id;
      _frameworkId = framework?.id;
      _ormId = orm?.id;
      _arquitecturaId = arquitectura?.id;
      _baseDatosId = baseDatos?.id;
      _errorGeneracion = null;
    });
  }

  T? _buscar<T extends OpcionDimension>(
    List<T> items,
    int? id, {
    bool unicoSiSoloHayUno = false,
  }) {
    if (items.isEmpty) return null;
    for (final item in items) {
      if (item.id == id) return item;
    }
    return unicoSiSoloHayUno && items.length == 1 ? items.first : null;
  }

  OpcionTipoArtefacto? get _tipo => _tipoPorId(_tipoId);

  OpcionTipoArtefacto? _tipoPorId(int? id) {
    final opciones = _opciones;
    if (opciones == null) return null;
    for (final tipo in opciones.tiposArtefacto) {
      if (tipo.id == id) return tipo;
    }
    return null;
  }

  OpcionLenguaje? get _lenguaje {
    final tipo = _tipo;
    if (tipo == null) return null;
    for (final lenguaje in tipo.lenguajes) {
      if (lenguaje.id == _lenguajeId) return lenguaje;
    }
    return null;
  }

  OpcionLenguaje? _lenguajePorId(int? id) {
    final tipo = _tipo;
    if (tipo == null) return null;
    for (final lenguaje in tipo.lenguajes) {
      if (lenguaje.id == id) return lenguaje;
    }
    return null;
  }

  OpcionFramework? _frameworkPorId(int? id) {
    final lenguaje = _lenguaje;
    if (lenguaje == null) return null;
    for (final framework in lenguaje.frameworks) {
      if (framework.id == id) return framework;
    }
    return null;
  }

  OpcionFramework? get _framework {
    final lenguaje = _lenguaje;
    if (lenguaje == null) return null;
    for (final framework in lenguaje.frameworks) {
      if (framework.id == _frameworkId) return framework;
    }
    return null;
  }

  String? _validar() {
    final tipo = _tipo;
    if (tipo == null) return 'Selecciona un tipo de artefacto';
    if (_lenguajeId == null) return 'Selecciona un lenguaje';
    if (_frameworkId == null) return 'Selecciona un framework';
    if (tipo.requiere.orm && _ormId == null) return 'Selecciona un ORM';
    if (tipo.requiere.arquitectura && _arquitecturaId == null) {
      return 'Selecciona una arquitectura';
    }
    if (tipo.requiere.baseDatos && _baseDatosId == null) {
      return 'Selecciona una base de datos destino';
    }
    return null;
  }

  Future<void> _generar() async {
    final tipo = _tipo;
    if (tipo == null) return;

    final error = _validar();
    if (error != null) {
      setState(() => _errorGeneracion = error);
      return;
    }

    setState(() {
      _generando = true;
      _errorGeneracion = null;
    });

    try {
      final archivo = await ref
          .read(logsServiceProvider)
          .regenerarProyecto(
            widget.detalle.log.id,
            databaseConfiguration: tipo.requiere.baseDatos
                ? DatabaseConfiguration(
                    host: _host.text.trim(),
                    name: _nombreBd.text.trim(),
                    user: _usuario.text.trim(),
                    password: _password.text,
                    port: _puerto.text.trim(),
                  )
                : null,
            tipoArtefactoId: tipo.id,
            lenguajeId: _lenguajeId,
            frameworkId: _frameworkId,
            ormId: tipo.requiere.orm ? _ormId : null,
            arquitecturaId: tipo.requiere.arquitectura ? _arquitecturaId : null,
            baseDatosId: tipo.requiere.baseDatos ? _baseDatosId : null,
          );

      final sufijo = tipo.nombreCode.trim().isEmpty
          ? tipo.nombre
          : tipo.nombreCode;
      final nombre =
          archivo.nombreSugerido ??
          DownloadSaver.nombreSeguro(
            '${widget.detalle.log.proyectoNombre}-$sufijo',
            extension: 'zip',
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
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SheetEncabezado(
            icono: Icons.archive_outlined,
            titulo: 'Regenerar proyecto',
            subtitulo: widget.detalle.log.proyectoNombre,
          ),
          if (_cargando) const LinearProgressIndicator(minHeight: 2),
          Expanded(child: _contenido()),
          _pie(),
        ],
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
    if (opciones == null || opciones.tiposArtefacto.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No hay opciones de generación disponibles.'),
      );
    }

    final tipo = _tipo ?? opciones.tiposArtefacto.first;
    final lenguaje = _lenguaje;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _selectorTipo(opciones),
          const SizedBox(height: 16),
          CampoDropdown(
            label: 'Lenguaje',
            icono: Icons.code_rounded,
            valor: _lenguajeId,
            items: [
              for (final l in tipo.lenguajes)
                (id: l.id, nombre: l.nombre),
            ],
            onChanged: (value) => setState(() {
              _lenguajeId = value;
              final lenguaje = _lenguajePorId(value);
              _frameworkId = lenguaje != null && lenguaje.frameworks.length == 1
                  ? lenguaje.frameworks.first.id
                  : null;
              final framework = _frameworkPorId(_frameworkId);
              _ormId = framework != null && framework.orms.length == 1
                  ? framework.orms.first.id
                  : null;
            }),
          ),
          const SizedBox(height: 12),
          CampoDropdown(
            label: 'Framework',
            icono: Icons.widgets_outlined,
            valor: _frameworkId,
            items: [
              for (final f in lenguaje?.frameworks ?? const <OpcionFramework>[])
                (id: f.id, nombre: f.nombre),
            ],
            onChanged: (value) => setState(() {
              _frameworkId = value;
              final framework = _frameworkPorId(value);
              _ormId = framework != null && framework.orms.length == 1
                  ? framework.orms.first.id
                  : null;
            }),
          ),
          if (tipo.requiere.orm) ...[
            const SizedBox(height: 12),
            CampoDropdown(
              label: 'ORM',
              icono: Icons.storage_rounded,
              valor: _ormId,
              items: [
                for (final o in _framework?.orms ?? const <OpcionDimension>[])
                  (id: o.id, nombre: o.nombre),
              ],
              onChanged: (value) => setState(() => _ormId = value),
            ),
          ],
          if (tipo.requiere.arquitectura) ...[
            const SizedBox(height: 12),
            CampoDropdown(
              label: 'Arquitectura',
              icono: Icons.account_tree_outlined,
              valor: _arquitecturaId,
              items: [
                for (final a in tipo.arquitecturas)
                  (id: a.id, nombre: a.nombre),
              ],
              onChanged: (value) => setState(() => _arquitecturaId = value),
            ),
          ],
          if (tipo.requiere.baseDatos) ...[
            const SizedBox(height: 12),
            CampoDropdown(
              label: 'Base de datos destino',
              icono: Icons.dns_outlined,
              valor: _baseDatosId,
              items: [
                for (final bd in opciones.basesDatosDestino)
                  (id: bd.id, nombre: bd.nombre),
              ],
              onChanged: (value) => setState(() => _baseDatosId = value),
            ),
            const SizedBox(height: 20),
            _tituloSeccion('Configuración de la base de datos'),
            const SizedBox(height: 4),
            Text(
              'Se usa solo para regenerar la descarga; puedes modificarla.',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _host,
              decoration: decoracionCampo(
                context,
                label: 'Host',
                hint: 'localhost',
                icon: Icons.dns_rounded,
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nombreBd,
              decoration: decoracionCampo(
                context,
                label: 'Base de datos',
                hint: 'nombre_db',
                icon: Icons.storage_outlined,
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _usuario,
              decoration: decoracionCampo(
                context,
                label: 'Usuario',
                hint: 'usuario',
                icon: Icons.person_outline_rounded,
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: decoracionCampo(
                context,
                label: 'Contraseña',
                hint: '••••••',
                icon: Icons.lock_outline_rounded,
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _puerto,
              keyboardType: TextInputType.number,
              decoration: decoracionCampo(
                context,
                label: 'Puerto',
                hint: '5432',
                icon: Icons.numbers_rounded,
              ),
              textInputAction: TextInputAction.done,
            ),
          ],
          if (_errorGeneracion != null) ...[
            const SizedBox(height: 16),
            SheetError(mensaje: _errorGeneracion!),
          ],
        ],
      ),
    );
  }

  Widget _selectorTipo(OpcionesGeneracion opciones) {
    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tipo in opciones.tiposArtefacto)
          ChoiceChip(
            label: Text(tipo.nombre),
            selected: tipo.id == _tipoId,
            onSelected: _generando ? null : (_) => _cambiarTipo(tipo.id),
            selectedColor: colorScheme.primary.withValues(alpha: 0.2),
            labelStyle: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: tipo.id == _tipoId
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
      ],
    );
  }

  Widget _tituloSeccion(String titulo) {
    return Text(
      titulo,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
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
