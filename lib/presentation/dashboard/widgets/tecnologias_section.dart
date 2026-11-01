// Tecnologías section: card + 3 vistas (Total/Proyecto/Reporte) + pie chart +
// leyenda con iconos + selector de elementos a renderizar.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/data/models/dashboard_catalogos.dart';
import 'package:mobile/data/models/dashboard_tecnologias.dart';
import 'package:mobile/presentation/dashboard/dashboard_providers.dart';
import 'package:mobile/presentation/dashboard/widgets/charts/neon_donut_chart.dart';
import 'package:mobile/presentation/dashboard/widgets/tech_icon.dart';
import 'package:mobile/presentation/shared/widgets/neon_card.dart'
    show GlowCard;

class TecnologiasSection extends ConsumerWidget {
  const TecnologiasSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final vista = ref.watch(tecnologiaVistaProvider);
    final categoriaGuardada = ref.watch(tecnologiaCategoriaProvider);
    final categorias = vista.categorias;
    final categoria = categorias.contains(categoriaGuardada)
        ? categoriaGuardada
        : categorias.first;

    final async = ref.watch(dashboardTecnologiasAutoProvider);
    final catalogAsync = ref.watch(dashboardCatalogosProvider);
    final filtros = ref.watch(tecnologiaFiltrosProvider);
    final seleccion = filtros[vista]?[categoria.apiKey] ?? const <int>{};
    final neon = NeonColors.getNeon('cyan', isDark);

    final catalogoItems =
        catalogAsync.asData?.value.itemsDe(categoria) ?? const <TechItem>[];

    return GlowCard(
      glowColor: neon.withValues(alpha: 0.18),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _VistaTabs(
            vista: vista,
            isDark: isDark,
            onChanged: (value) {
              ref.read(tecnologiaVistaProvider.notifier).setVista(value);
            },
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final item in categorias)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _CategoriaChip(
                      label: item.label,
                      selected: item == categoria,
                      isDark: isDark,
                      onTap: () => ref
                          .read(tecnologiaCategoriaProvider.notifier)
                          .setCategoria(item),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          async.when(
            loading: () => _buildLoading(context),
            error: (error, _) => _buildError(context, ref, error),
            data: (data) {
              final items = data.itemsDe(categoria);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    '${data.total} generaciones en ${vista.label.toLowerCase()}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (items.isEmpty)
                    _buildEmpty(context)
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final chartSize = (constraints.maxWidth * 0.62).clamp(
                          150.0,
                          240.0,
                        );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: NeonDonutChart(
                                data: items,
                                title: '',
                                glowColor: neon,
                                size: chartSize,
                                maxItems: items.length,
                                showLegend: false,
                              ),
                            ),
                            const SizedBox(height: 12),
                            for (final item in items)
                              _LeyendaItem(
                                item: item,
                                categoria: categoria,
                                isDark: isDark,
                              ),
                          ],
                        );
                      },
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (seleccion.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            ref
                                .read(tecnologiaFiltrosProvider.notifier)
                                .setSeleccion(vista, categoria, <int>{});
                          },
                          child: const Text('Quitar filtros'),
                        ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: catalogoItems.isEmpty
                            ? null
                            : () => _abrirSelector(
                                context: context,
                                ref: ref,
                                vista: vista,
                                categoria: categoria,
                                items: catalogoItems,
                                seleccion: seleccion,
                              ),
                        icon: const Icon(Icons.tune_rounded, size: 18),
                        label: Text(
                          'Ver todos${seleccion.isEmpty ? '' : ' (${seleccion.length})'}',
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _abrirSelector({
    required BuildContext context,
    required WidgetRef ref,
    required DashboardTecnologiaVista vista,
    required TecnologiaCategoria categoria,
    required List<TechItem> items,
    required Set<int> seleccion,
  }) async {
    final result = await showDialog<Set<int>>(
      context: context,
      builder: (_) => _SeleccionTecnologiaDialog(
        titulo: 'Seleccionar ${categoria.label.toLowerCase()}',
        items: items,
        seleccion: seleccion,
        apiKey: categoria.apiKey,
      ),
    );

    if (result != null) {
      ref
          .read(tecnologiaFiltrosProvider.notifier)
          .setSeleccion(vista, categoria, result);
    }
  }

  Widget _buildLoading(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 40,
            color: Colors.redAccent.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 8),
          Text(
            'No se pudieron cargar las tecnologías',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$error',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => ref.invalidate(dashboardTecnologiasAutoProvider),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(
            Icons.donut_large_rounded,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 10),
          Text(
            'Sin datos para este período',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _VistaTabs extends StatelessWidget {
  final DashboardTecnologiaVista vista;
  final bool isDark;
  final ValueChanged<DashboardTecnologiaVista> onChanged;

  const _VistaTabs({
    required this.vista,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final neon = NeonColors.getNeon('cyan', isDark);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          for (final option in DashboardTecnologiaVista.values)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(option),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: option == vista
                        ? neon.withValues(alpha: isDark ? 0.22 : 0.14)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: option == vista
                          ? neon.withValues(alpha: 0.55)
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    option.label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: option == vista
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: option == vista
                          ? neon
                          : colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoriaChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const _CategoriaChip({
    required this.label,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final neon = NeonColors.getNeon('magenta', isDark);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: selected
                ? neon.withValues(alpha: isDark ? 0.2 : 0.12)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? neon.withValues(alpha: 0.5)
                  : colorScheme.outlineVariant.withValues(alpha: 0.25),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected
                  ? neon
                  : colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}

class _LeyendaItem extends StatelessWidget {
  final TechItem item;
  final TecnologiaCategoria categoria;
  final bool isDark;

  const _LeyendaItem({
    required this.item,
    required this.categoria,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final neon = NeonColors.getNeon('cyan', isDark);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.18),
          ),
        ),
      ),
      child: Row(
        children: [
          TechIcon(
            icono: item.icono,
            iconoTipo: item.iconoTipo,
            size: 22,
            color: neon,
            fallback: iconoFallbackCategoria(categoria.apiKey),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.85),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${item.total}',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 52,
            child: Text(
              '${item.porcentaje.toStringAsFixed(1)}%',
              textAlign: TextAlign.right,
              style: GoogleFonts.orbitron(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: neon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeleccionTecnologiaDialog extends StatefulWidget {
  final String titulo;
  final List<TechItem> items;
  final Set<int> seleccion;
  final String apiKey;

  const _SeleccionTecnologiaDialog({
    required this.titulo,
    required this.items,
    required this.seleccion,
    required this.apiKey,
  });

  @override
  State<_SeleccionTecnologiaDialog> createState() =>
      _SeleccionTecnologiaDialogState();
}

class _SeleccionTecnologiaDialogState
    extends State<_SeleccionTecnologiaDialog> {
  late Set<int> _seleccion;

  @override
  void initState() {
    super.initState();
    _seleccion = Set<int>.from(widget.seleccion);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final neon = NeonColors.getNeon(
      'cyan',
      Theme.of(context).brightness == Brightness.dark,
    );
    final fallback = iconoFallbackCategoria(widget.apiKey);

    return AlertDialog(
      title: Text(
        widget.titulo,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
      ),
      content: SizedBox(
        width: 360,
        child: widget.items.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No hay opciones disponibles para este período.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              )
            : ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.55,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    final checked = _seleccion.contains(item.id);
                    return CheckboxListTile(
                      value: checked,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: neon,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _seleccion.add(item.id);
                          } else {
                            _seleccion.remove(item.id);
                          }
                        });
                      },
                      secondary: TechIcon(
                        icono: item.icono,
                        iconoTipo: item.iconoTipo,
                        size: 22,
                        color: neon,
                        fallback: fallback,
                      ),
                      title: Text(
                        item.nombre,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        '${item.total} usos',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => setState(_seleccion.clear),
          child: const Text('Limpiar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_seleccion),
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}
