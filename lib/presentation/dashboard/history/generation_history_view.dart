// Historial personal de generaciones: búsqueda, filtros avanzados y paginación.
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile/data/models/log_models.dart';
import 'package:mobile/presentation/dashboard/history/advanced_log_filters_sheet.dart';
import 'package:mobile/presentation/dashboard/history/generation_log_card.dart';
import 'package:mobile/presentation/dashboard/history/logs_filters.dart';
import 'package:mobile/presentation/dashboard/history/logs_pagination_bar.dart';
import 'package:mobile/presentation/dashboard/history/logs_providers.dart';
import 'package:mobile/presentation/shared/widgets/neon_card.dart'
    show GlowCard;
import 'package:mobile/presentation/shared/widgets/neon_input.dart';
import 'package:mobile/presentation/shared/widgets/skeleton_base.dart';

class GenerationHistoryView extends ConsumerStatefulWidget {
  const GenerationHistoryView({super.key});

  @override
  ConsumerState<GenerationHistoryView> createState() =>
      _GenerationHistoryViewState();
}

class _GenerationHistoryViewState extends ConsumerState<GenerationHistoryView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(logsFiltrosProvider).search;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(logsFiltrosProvider.notifier).setSearch(value);
    });
  }

  void _buscarAhora(String value) {
    _debounce?.cancel();
    ref.read(logsFiltrosProvider.notifier).setSearch(value);
  }

  void _limpiarBusqueda() {
    _debounce?.cancel();
    _searchController.clear();
    ref.read(logsFiltrosProvider.notifier).setSearch('');
  }

  void _cambiarPagina(int page) {
    ref.read(logsFiltrosProvider.notifier).setPage(page);
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtros = ref.watch(logsFiltrosProvider);
    final async = ref.watch(misLogsProvider);
    final options = ref.watch(logFilterOptionsProvider).asData?.value;

    return Column(
      children: [
        _buildBusqueda(filtros),
        if (filtros.conFiltrosActivos) _buildChips(filtros, options),
        Expanded(
          child: async.when(
            loading: () => _buildLoading(),
            error: (error, _) => _buildError(error),
            data: (page) => page.items.isEmpty
                ? _buildVacio(filtros)
                : RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(misLogsProvider);
                      await ref.read(misLogsProvider.future);
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      itemCount: page.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, index) =>
                          GenerationLogCard(log: page.items[index]),
                    ),
                  ),
          ),
        ),
        if (async.hasValue && async.value!.items.isNotEmpty)
          LogsPaginationBar(
            currentPage: async.value!.meta.currentPage,
            totalPages: async.value!.meta.totalPages,
            totalItems: async.value!.meta.totalItems,
            onPageChanged: _cambiarPagina,
          ),
      ],
    );
  }

  Widget _buildBusqueda(LogsFiltros filtros) {
    final colorScheme = Theme.of(context).colorScheme;
    final activos = filtros.totalFiltrosActivos;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: NeonInput(
              label: 'Buscar',
              hint: 'Proyecto o rol…',
              controller: _searchController,
              textInputAction: TextInputAction.search,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: _limpiarBusqueda,
                      icon: const Icon(Icons.close_rounded, size: 18),
                      tooltip: 'Limpiar búsqueda',
                    ),
              onChanged: (value) {
                setState(() {});
                _onSearchChanged(value);
              },
              onSubmitted: _buscarAhora,
            ),
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Badge(
              isLabelVisible: activos > 0,
              label: Text('$activos'),
              child: IconButton.filledTonal(
                onPressed: () => AdvancedLogFiltersSheet.mostrar(context),
                tooltip: 'Filtros avanzados',
                icon: const Icon(Icons.tune_rounded),
                style: IconButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                  minimumSize: const Size(48, 48),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChips(LogsFiltros filtros, LogFilterOptions? options) {
    final formato = DateFormat('dd/MM/yy');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final entry in filtros.filtrosActivos)
              _chip(
                label:
                    '${entry.key.label}: '
                    '${_nombreDimension(options, entry.key, entry.value)}',
                onDeleted: () => ref
                    .read(logsFiltrosProvider.notifier)
                    .setFiltro(entry.key, null),
              ),
            if (filtros.tieneVersion)
              _chip(
                label: 'Versión: ${filtros.versionGenerador}',
                onDeleted: () =>
                    ref.read(logsFiltrosProvider.notifier).setVersion(''),
              ),
            if (filtros.tieneRango)
              _chip(
                label: _rangoTexto(filtros, formato),
                onDeleted: () =>
                    ref.read(logsFiltrosProvider.notifier).setRango(null),
              ),
            TextButton.icon(
              onPressed: () =>
                  ref.read(logsFiltrosProvider.notifier).limpiarFiltros(),
              icon: const Icon(Icons.cleaning_services_rounded, size: 15),
              label: const Text('Limpiar todo'),
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip({required String label, required VoidCallback onDeleted}) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputChip(
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(fontSize: 11),
      ),
      onDeleted: onDeleted,
      deleteIcon: const Icon(Icons.close_rounded, size: 15),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: colorScheme.primary.withValues(alpha: 0.08),
      side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.25)),
    );
  }

  String _rangoTexto(LogsFiltros filtros, DateFormat formato) {
    final desde = filtros.desde;
    final hasta = filtros.hasta;
    if (desde != null && hasta != null) {
      return '${formato.format(desde)} — ${formato.format(hasta)}';
    }
    if (desde != null) return 'Desde ${formato.format(desde)}';
    return 'Hasta ${formato.format(hasta!)}';
  }

  String _nombreDimension(
    LogFilterOptions? options,
    LogsFiltroCampo campo,
    int id,
  ) {
    for (final item in options?.itemsDe(campo) ?? const <LogDimensionRef>[]) {
      if (item.id == id) return item.nombre;
    }
    return '#$id';
  }

  Widget _buildLoading() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, _) => SkeletonBase(
        borderRadius: 16,
        child: Container(
          height: 112,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildVacio(LogsFiltros filtros) {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.history_toggle_off_rounded,
                  size: 52,
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 14),
                Text(
                  filtros.conFiltrosActivos || filtros.search.isNotEmpty
                      ? 'Sin coincidencias'
                      : 'Aún no tienes generaciones',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  filtros.conFiltrosActivos || filtros.search.isNotEmpty
                      ? 'Prueba con otros filtros o limpia la búsqueda.'
                      : 'Tus generaciones aparecerán aquí.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                if (filtros.conFiltrosActivos) ...[
                  const SizedBox(height: 14),
                  TextButton.icon(
                    onPressed: () =>
                        ref.read(logsFiltrosProvider.notifier).limpiarFiltros(),
                    icon: const Icon(Icons.cleaning_services_rounded, size: 16),
                    label: const Text('Limpiar filtros'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(Object error) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: GlowCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 44,
                color: colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                'No se pudo cargar el historial',
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _mensajeError(error),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: () => ref.invalidate(misLogsProvider),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _mensajeError(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      return error.message ?? 'Error de conexión';
    }
    return error.toString();
  }
}
