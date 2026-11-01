// Barra de paginación del historial (perPage fijo en 10).
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogsPaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final ValueChanged<int> onPageChanged;

  const LogsPaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final puedeAtras = currentPage > 1;
    final puedeAdelante = currentPage < totalPages;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: puedeAtras ? () => onPageChanged(currentPage - 1) : null,
            tooltip: 'Página anterior',
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  totalPages == 0
                      ? 'Sin resultados'
                      : 'Página $currentPage de $totalPages',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  '$totalItems ${totalItems == 1 ? 'registro' : 'registros'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: puedeAdelante
                ? () => onPageChanged(currentPage + 1)
                : null,
            tooltip: 'Página siguiente',
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}
