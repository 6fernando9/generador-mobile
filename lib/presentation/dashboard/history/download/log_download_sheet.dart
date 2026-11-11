// Modal "Descargar": elige entre regenerar el proyecto o una exportación.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/data/models/log_models.dart';
import 'package:mobile/data/models/saved_download.dart';
import 'package:mobile/presentation/dashboard/history/download/download_widgets.dart';
import 'package:mobile/presentation/dashboard/history/download/regenerar_proyecto_sheet.dart';
import 'package:mobile/presentation/dashboard/history/download/regenerar_reporte_sheet.dart';

enum _OpcionDescarga { proyecto, exportacion }

/// Abre la elección de descarga y encadena el modal correspondiente.
class LogDownloadSheet {
  const LogDownloadSheet._();

  /// Devuelve el archivo guardado, o null si el usuario canceló.
  static Future<SavedDownload?> mostrar(
    BuildContext context, {
    required LogDetalle detalle,
  }) async {
    final opcion = await showModalBottomSheet<_OpcionDescarga>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _SelectorDescarga(detalle: detalle),
    );

    if (opcion == null || !context.mounted) return null;

    return switch (opcion) {
      _OpcionDescarga.proyecto => RegenerarProyectoSheet.mostrar(
        context,
        detalle: detalle,
      ),
      _OpcionDescarga.exportacion => RegenerarReporteSheet.mostrar(
        context,
        detalle: detalle,
      ),
    };
  }
}

class _SelectorDescarga extends StatelessWidget {
  const _SelectorDescarga({required this.detalle});

  final LogDetalle detalle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final esReporte = detalle.log.tipoArtefacto?.nombreCode == 'reporte';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SheetEncabezado(
            icono: Icons.download_rounded,
            titulo: 'Descargar',
            subtitulo: detalle.log.proyectoNombre,
          ),
          const SizedBox(height: 8),
          _OpcionTarjeta(
            icono: Icons.archive_outlined,
            titulo: 'Regenerar proyecto',
            descripcion: esReporte
                ? 'Backend, frontend o mobile a partir del diagrama guardado (.zip).'
                : 'Genera el proyecto en backend, frontend o mobile (.zip).',
            color: colorScheme.primary,
            onTap: () => Navigator.of(context).pop(_OpcionDescarga.proyecto),
          ),
          const SizedBox(height: 12),
          _OpcionTarjeta(
            icono: Icons.table_chart_outlined,
            titulo: 'Regenerar exportación SQL',
            descripcion:
                'Script de base de datos desde el diagrama guardado (.sql).',
            color: colorScheme.tertiary,
            onTap: () => Navigator.of(context).pop(_OpcionDescarga.exportacion),
          ),
        ],
      ),
    );
  }
}

class _OpcionTarjeta extends StatelessWidget {
  const _OpcionTarjeta({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.color,
    required this.onTap,
  });

  final IconData icono;
  final String titulo;
  final String descripcion;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          color: color.withValues(alpha: 0.06),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color.withValues(alpha: 0.15),
              ),
              child: Icon(icono, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    descripcion,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
