// Piezas compartidas por los modales de descarga/regeneración del historial.
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Mensaje legible a partir de un error de red o del backend.
String mensajeDeError(Object error) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    final extra = error.error;
    if (extra is Map && extra['message'] != null) {
      return extra['message'].toString();
    }
    return error.message ?? 'Error de conexión';
  }
  return error.toString();
}

/// Decoración de campos con el estilo del resto de la app.
InputDecoration decoracionCampo(
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

/// Encabezado estándar de los bottom sheets.
class SheetEncabezado extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String? subtitulo;

  const SheetEncabezado({
    super.key,
    required this.icono,
    required this.titulo,
    this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (subtitulo != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitulo!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }
}

/// Banner de error reutilizable dentro de los sheets.
class SheetError extends StatelessWidget {
  final String mensaje;
  final VoidCallback? onReintentar;

  const SheetError({super.key, required this.mensaje, this.onReintentar});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: colorScheme.error, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              mensaje,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: colorScheme.error,
              ),
            ),
          ),
          if (onReintentar != null)
            TextButton(
              onPressed: onReintentar,
              child: const Text('Reintentar'),
            ),
        ],
      ),
    );
  }
}

/// Dropdown de catálogo con el estilo de la app.
class CampoDropdown extends StatelessWidget {
  final String label;
  final IconData? icono;
  final int? valor;
  final List<({int id, String nombre})> items;
  final ValueChanged<int?> onChanged;
  final String? hint;
  final bool habilitado;

  const CampoDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.valor,
    this.icono,
    this.hint,
    this.habilitado = true,
  });

  @override
  Widget build(BuildContext context) {
    final existe = items.any((item) => item.id == valor);
    return DropdownButtonFormField<int>(
      key: ValueKey('$label-${valor ?? 'null'}-${items.length}'),
      initialValue: existe ? valor : null,
      isExpanded: true,
      decoration: decoracionCampo(context, label: label, icon: icono),
      hint: Text(hint ?? 'Selecciona...', overflow: TextOverflow.ellipsis),
      items: [
        for (final item in items)
          DropdownMenuItem(
            value: item.id,
            child: Text(item.nombre, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: habilitado && items.isNotEmpty
          ? (value) => onChanged(value)
          : null,
    );
  }
}
