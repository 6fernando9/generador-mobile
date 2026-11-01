// Card de una generación del historial personal.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile/data/models/log_models.dart';
import 'package:mobile/presentation/dashboard/widgets/tech_icon.dart';
import 'package:mobile/presentation/shared/widgets/neon_card.dart'
    show GlowCard;

class GenerationLogCard extends StatelessWidget {
  final LogGeneracion log;

  const GenerationLogCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tipo = log.tipoArtefacto;
    final dimensiones = log.dimensiones
        .where((d) => d.id != tipo?.id)
        .toList(growable: false);

    return GlowCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(14),
      animate: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ArtifactIcon(tipo: tipo),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.proyectoNombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _subtitulo(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                if (dimensiones.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final dimension in dimensiones)
                        _DimensionChip(dimension: dimension),
                    ],
                  ),
                ],
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _MetaItem(
                      icon: Icons.schedule_rounded,
                      label: _fecha(log.createdAt),
                    ),
                    if (log.rolMomentoCode.trim().isNotEmpty)
                      _MetaItem(
                        icon: Icons.verified_user_outlined,
                        label: _capitalizar(log.rolMomentoCode),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () {},
            tooltip: 'Ver detalle',
            icon: const Icon(Icons.visibility_rounded, size: 20),
            color: colorScheme.primary,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  String _subtitulo() {
    final tipo = log.tipoArtefacto?.nombre.trim();
    final version = log.versionGenerador?.trim();
    final partes = [
      if (tipo != null && tipo.isNotEmpty) tipo,
      if (version != null && version.isNotEmpty) 'v$version',
    ];
    return partes.isEmpty ? 'Generación' : partes.join('  •  ');
  }

  static String _fecha(DateTime? value) {
    if (value == null) return 'Fecha desconocida';
    return DateFormat('dd/MM/yyyy • HH:mm').format(value.toLocal());
  }

  static String _capitalizar(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}

class _ArtifactIcon extends StatelessWidget {
  final LogDimensionRef? tipo;

  const _ArtifactIcon({required this.tipo});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.25)),
      ),
      alignment: Alignment.center,
      child: TechIcon(
        icono: tipo?.icono,
        iconoTipo: tipo?.iconoTipo,
        size: 22,
        color: colorScheme.primary,
      ),
    );
  }
}

class _DimensionChip extends StatelessWidget {
  final LogDimensionRef dimension;

  const _DimensionChip({required this.dimension});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TechIcon(
            icono: dimension.icono,
            iconoTipo: dimension.iconoTipo,
            size: 12,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fallback: Icons.extension_rounded,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              dimension.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 13,
          color: colorScheme.onSurface.withValues(alpha: 0.45),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ),
      ],
    );
  }
}
