// Filtros avanzados del historial: 8 catálogos + versión + rango de fechas.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile/data/models/log_models.dart';
import 'package:mobile/presentation/dashboard/history/logs_filters.dart';
import 'package:mobile/presentation/dashboard/history/logs_providers.dart';
import 'package:mobile/presentation/shared/widgets/neon_button.dart';

class AdvancedLogFiltersSheet extends ConsumerStatefulWidget {
  const AdvancedLogFiltersSheet({super.key, this.enDialogo = false});

  final bool enDialogo;

  /// Bottom sheet en móvil, diálogo en pantallas anchas.
  static Future<void> mostrar(BuildContext context) {
    final ancho = MediaQuery.sizeOf(context).width;
    if (ancho >= 700) {
      return showDialog<void>(
        context: context,
        builder: (_) => const AdvancedLogFiltersSheet(enDialogo: true),
      );
    }
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const AdvancedLogFiltersSheet(),
    );
  }

  @override
  ConsumerState<AdvancedLogFiltersSheet> createState() =>
      _AdvancedLogFiltersSheetState();
}

class _AdvancedLogFiltersSheetState
    extends ConsumerState<AdvancedLogFiltersSheet> {
  late LogsFiltros _draft;
  late final TextEditingController _versionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _draft = ref.read(logsFiltrosProvider);
    _versionController = TextEditingController(text: _draft.versionGenerador);
  }

  @override
  void dispose() {
    _versionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final optionsAsync = ref.watch(logFilterOptionsProvider);
    final options = optionsAsync.asData?.value;

    final contenido = Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _encabezado(),
        if (optionsAsync.isLoading) const LinearProgressIndicator(minHeight: 2),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final campo in LogsFiltroCampo.values) ...[
                    _dropdown(campo, options),
                    const SizedBox(height: 12),
                  ],
                  TextFormField(
                    controller: _versionController,
                    decoration: _decoracion(
                      context,
                      label: 'Versión del generador',
                      hint: 'Ej. 1.0.0',
                      icon: Icons.tag_rounded,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _selectorFechas(context),
                  if (optionsAsync.hasError) ...[
                    const SizedBox(height: 12),
                    _errorCatalogos(context),
                  ],
                ],
              ),
            ),
          ),
        ),
        _pieAcciones(context),
      ],
    );

    if (widget.enDialogo) {
      final alto = MediaQuery.sizeOf(context).height * 0.8;
      return Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SizedBox(height: alto.clamp(320.0, 680.0), child: contenido),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.82,
        child: contenido,
      ),
    );
  }

  Widget _encabezado() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          Icon(Icons.tune_rounded, color: colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Filtros avanzados',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }

  Widget _dropdown(LogsFiltroCampo campo, LogFilterOptions? options) {
    final items = options?.itemsDe(campo) ?? const <LogDimensionRef>[];
    if (items.isEmpty) return const SizedBox.shrink();

    final valor = _draft.idDe(campo);
    final existe = items.any((item) => item.id == valor);

    return DropdownButtonFormField<int>(
      key: ValueKey('${campo.name}-${valor ?? 'todos'}'),
      initialValue: existe ? valor : null,
      isExpanded: true,
      decoration: _decoracion(context, label: campo.label),
      hint: Text('Cualquiera', overflow: TextOverflow.ellipsis),
      items: [
        for (final item in items)
          DropdownMenuItem(
            value: item.id,
            child: Text(item.nombre, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (value) {
        _draft = _draft.conFiltro(campo, value);
        setState(() {});
      },
    );
  }

  Widget _selectorFechas(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formato = DateFormat('dd/MM/yyyy');
    final rango = _draft.desde != null && _draft.hasta != null
        ? '${formato.format(_draft.desde!)} — ${formato.format(_draft.hasta!)}'
        : 'Cualquier fecha';

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: _elegirRango,
      child: InputDecorator(
        decoration:
            _decoracion(
              context,
              label: 'Rango de fechas',
              icon: Icons.date_range_rounded,
            ).copyWith(
              suffixIcon: _draft.tieneRango
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _draft = _draft.copyWith(desde: null, hasta: null);
                        });
                      },
                      icon: const Icon(Icons.close_rounded, size: 18),
                      tooltip: 'Quitar fechas',
                    )
                  : null,
            ),
        child: Text(
          rango,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            color: _draft.tieneRango
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Future<void> _elegirRango() async {
    final ahora = DateTime.now();
    final inicial = _draft.desde != null && _draft.hasta != null
        ? DateTimeRange(start: _draft.desde!, end: _draft.hasta!)
        : null;
    final rango = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(ahora.year, ahora.month, ahora.day),
      initialDateRange: inicial,
      helpText: 'Selecciona el rango',
      saveText: 'Aplicar',
    );
    if (rango == null || !mounted) return;
    setState(() {
      _draft = _draft.copyWith(
        desde: DateTime(rango.start.year, rango.start.month, rango.start.day),
        hasta: DateTime(
          rango.end.year,
          rango.end.month,
          rango.end.day,
          23,
          59,
          59,
          999,
        ),
      );
    });
  }

  Widget _errorCatalogos(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            'No se pudieron cargar los catálogos.',
            style: GoogleFonts.inter(fontSize: 12, color: colorScheme.error),
          ),
        ),
        TextButton(
          onPressed: () => ref.invalidate(logFilterOptionsProvider),
          child: const Text('Reintentar'),
        ),
      ],
    );
  }

  Widget _pieAcciones(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant
                .withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: NeonButton(
              label: 'Limpiar',
              icon: Icons.cleaning_services_rounded,
              style: NeonButtonStyle.outline,
              isFullWidth: true,
              onPressed: () {
                setState(() {
                  _draft = _draft.limpiarFiltros();
                  _versionController.clear();
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: NeonButton(
              label: 'Aplicar',
              icon: Icons.check_rounded,
              isFullWidth: true,
              onPressed: _aplicar,
            ),
          ),
        ],
      ),
    );
  }

  void _aplicar() {
    ref
        .read(logsFiltrosProvider.notifier)
        .aplicar(_draft.copyWith(versionGenerador: _versionController.text));
    Navigator.pop(context);
  }

  InputDecoration _decoracion(
    BuildContext context, {
    required String label,
    String? hint,
    IconData? icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final borde = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    );
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, size: 18) : null,
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      border: borde,
      enabledBorder: borde,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      isDense: true,
    );
  }
}
