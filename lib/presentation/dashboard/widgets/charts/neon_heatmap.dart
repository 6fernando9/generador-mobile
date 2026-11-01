// Neon Heatmap for Actividad (Activity by Day × Hour)
//
// Mobile-first and fully responsive:
// - The grid always fits the available width (no horizontal scrolling).
// - Cells only encode intensity through color; the value is shown in a fixed
//   detail row below the grid on hover (desktop/web) or tap (mobile).
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/data/models/dashboard_actividad.dart';

class NeonHeatmap extends StatefulWidget {
  final DashboardActividad data;
  final ValueChanged<HeatmapCell>? onCellTap;

  const NeonHeatmap({super.key, required this.data, this.onCellTap});

  @override
  State<NeonHeatmap> createState() => _NeonHeatmapState();
}

class _NeonHeatmapState extends State<NeonHeatmap> {
  static const List<String> _diasCortos = [
    'Lun',
    'Mar',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
    'Dom',
  ];
  static const List<String> _diasIniciales = [
    'L',
    'M',
    'X',
    'J',
    'V',
    'S',
    'D',
  ];
  static const List<String> _diasLargos = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  /// El backend usa la numeración ISO (`1 = lunes … 6 = sábado, 0 = domingo`)
  /// y devuelve las celdas en este orden.
  static const List<int> _ordenSemana = [1, 2, 3, 4, 5, 6, 0];

  /// Convierte el `dia` del backend a índice de las listas de nombres.
  static int _indiceDia(int dia) => dia == 0 ? 6 : dia - 1;

  /// Gap between cells (half on each side via padding).
  static const double _gap = 2.0;

  HeatmapCell? _celdaActiva;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.data.heatmap.isEmpty) {
      return _buildEmptyState(context);
    }

    final maxValue = widget.data.heatmap
        .map((p) => p.total)
        .reduce((a, b) => a > b ? a : b);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width - 32;
        final compact = width < 400;
        final labelWidth = compact ? 30.0 : 40.0;

        // Cell box includes the gap; the inner square is `cell`.
        final cell = ((width - labelWidth) / 24 - _gap).clamp(8.0, 26.0);
        final box = cell + _gap;
        final gridWidth = labelWidth + 24 * box;
        final hourStep = _hourLabelStep(cell);

        // Lookup map built once per build (24 * 7 max entries).
        final values = <int, int>{
          for (final p in widget.data.heatmap) p.dia * 24 + p.hora: p.total,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actividad por Día y Hora',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total: ${widget.data.total} generaciones  •  Máx: $maxValue',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: SizedBox(
                width: gridWidth,
                child: Column(
                  children: [
                    _buildHourLabels(
                      hourStep: hourStep,
                      labelWidth: labelWidth,
                      box: box,
                      fontSize: compact ? 8.5 : 9.5,
                      colorScheme: colorScheme,
                    ),
                    for (final day in _ordenSemana)
                      _buildDayRow(
                        day: day,
                        label: compact
                            ? _diasIniciales[_indiceDia(day)]
                            : _diasCortos[_indiceDia(day)],
                        labelWidth: labelWidth,
                        box: box,
                        cell: cell,
                        maxValue: maxValue,
                        values: values,
                        isDark: isDark,
                        colorScheme: colorScheme,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            _buildLegend(maxValue, isDark, colorScheme),
            const SizedBox(height: 12),
            _buildDetalle(maxValue, isDark, colorScheme),
          ],
        );
      },
    );
  }

  /// Shows fewer hour labels when cells are narrow, so they never overlap.
  int _hourLabelStep(double cell) {
    if (cell < 13) return 6;
    if (cell < 20) return 3;
    return 2;
  }

  Widget _buildHourLabels({
    required int hourStep,
    required double labelWidth,
    required double box,
    required double fontSize,
    required ColorScheme colorScheme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: labelWidth),
        for (var hour = 0; hour < 24; hour++)
          SizedBox(
            width: box,
            height: 16,
            child: hour % hourStep == 0
                ? Center(
                    child: Text(
                      hour.toString().padLeft(2, '0'),
                      maxLines: 1,
                      style: GoogleFonts.inter(
                        fontSize: fontSize,
                        color: colorScheme.onSurface.withValues(alpha: 0.45),
                      ),
                    ),
                  )
                : null,
          ),
      ],
    );
  }

  Widget _buildDayRow({
    required int day,
    required String label,
    required double labelWidth,
    required double box,
    required double cell,
    required int maxValue,
    required Map<int, int> values,
    required bool isDark,
    required ColorScheme colorScheme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: labelWidth,
          height: box,
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
        for (var hour = 0; hour < 24; hour++)
          _buildCell(
            day: day,
            hour: hour,
            value: values[day * 24 + hour] ?? 0,
            cell: cell,
            box: box,
            maxValue: maxValue,
            isDark: isDark,
            colorScheme: colorScheme,
          ),
      ],
    );
  }

  Widget _buildCell({
    required int day,
    required int hour,
    required int value,
    required double cell,
    required double box,
    required int maxValue,
    required bool isDark,
    required ColorScheme colorScheme,
  }) {
    final intensity = maxValue > 0 ? value / maxValue : 0.0;
    final color = _heatColor(intensity, isDark);
    final isActive =
        _celdaActiva != null &&
        _celdaActiva!.day == day &&
        _celdaActiva!.hour == hour;
    final description =
        '${_diasLargos[_indiceDia(day)]} '
        '${hour.toString().padLeft(2, '0')}:00, $value generaciones';

    return Semantics(
      button: true,
      selected: isActive,
      label: description,
      child: SizedBox(
        width: box,
        height: box,
        child: Padding(
          padding: const EdgeInsets.all(_gap / 2),
          child: MouseRegion(
            onEnter: (_) =>
                _setActive(HeatmapCell(day: day, hour: hour, value: value)),
            onExit: (_) => _setActive(null),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                widget.onCellTap?.call(
                  HeatmapCell(day: day, hour: hour, value: value),
                );
                final same =
                    _celdaActiva?.day == day && _celdaActiva?.hour == hour;
                _setActive(
                  same ? null : HeatmapCell(day: day, hour: hour, value: value),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                  border: isActive
                      ? Border.all(
                          color: colorScheme.onSurface.withValues(alpha: 0.85),
                          width: 1.5,
                        )
                      : null,
                  boxShadow: isActive && value > 0
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.55),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setActive(HeatmapCell? cell) {
    if (!mounted) return;
    setState(() => _celdaActiva = cell);
  }

  /// Continuous cyan → magenta → purple ramp with a visible opacity floor, so
  /// intensity always reads as "stronger color = more usage".
  Color _heatColor(double intensity, bool isDark) {
    if (!intensity.isFinite || intensity <= 0) {
      return isDark
          ? Colors.grey.withValues(alpha: 0.12)
          : Colors.grey.withValues(alpha: 0.08);
    }

    final t = intensity.clamp(0.0, 1.0);
    final low = isDark ? NeonColors.cyanDark : NeonColors.cyanLight;
    final mid = isDark ? NeonColors.magentaDark : NeonColors.magentaLight;
    final high = isDark ? NeonColors.purpleDark : NeonColors.purpleLight;

    final base = t < 0.5
        ? Color.lerp(low, mid, t * 2)!
        : Color.lerp(mid, high, (t - 0.5) * 2)!;
    return base.withValues(alpha: 0.25 + 0.75 * t);
  }

  Widget _buildLegend(int maxValue, bool isDark, ColorScheme colorScheme) {
    final labelStyle = GoogleFonts.inter(
      fontSize: 10,
      color: colorScheme.onSurface.withValues(alpha: 0.6),
    );

    return Wrap(
      spacing: 10,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'Intensidad',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Text('Menos', style: labelStyle),
        Container(
          width: 96,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.25),
            ),
            gradient: LinearGradient(
              colors: [
                _heatColor(0.02, isDark),
                _heatColor(0.5, isDark),
                _heatColor(1, isDark),
              ],
            ),
          ),
        ),
        Text('Más', style: labelStyle),
        Text('Máx: $maxValue', style: labelStyle),
      ],
    );
  }

  Widget _buildDetalle(int maxValue, bool isDark, ColorScheme colorScheme) {
    final active = _celdaActiva;
    final percent = active != null && maxValue > 0
        ? (active.value / maxValue * 100).round()
        : 0;

    return Container(
      width: double.infinity,
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: active == null
          ? Row(
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  size: 18,
                  color: colorScheme.onSurface.withValues(alpha: 0.35),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Toca o pasa el cursor sobre una celda para ver el detalle',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_diasLargos[_indiceDia(active.day)]} '
                        '${active.hour.toString().padLeft(2, '0')}:00',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${active.value} generaciones',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$percent%',
                  style: GoogleFonts.orbitron(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _heatColor(active.value / maxValue, isDark),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.grid_on_rounded,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin datos de actividad',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Genera proyectos para ver tu mapa de actividad',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cell data for heatmap interaction.
class HeatmapCell {
  final int day; // 0-6 (Lun-Dom)
  final int hour; // 0-23
  final int value;

  const HeatmapCell({
    required this.day,
    required this.hour,
    required this.value,
  });
}
