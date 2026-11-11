import 'package:flutter/material.dart';

import 'package:mobile/core/theme/neon_colors.dart';

/// Displays the KrakenDraw brand image without changing its aspect ratio.
class KrakenLogoImage extends StatelessWidget {
  const KrakenLogoImage({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(width * 0.25);
    final borderWidth = (width * 0.018).clamp(1.0, 2.5).toDouble();

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        color: const Color(0xFF10121D),
        borderRadius: borderRadius,
        border: Border.all(
          color: NeonColors.cyanDark.withValues(alpha: 0.85),
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: NeonColors.glowCyanDark,
            blurRadius: width * 0.3,
            spreadRadius: width * 0.035,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width * 0.21),
        child: Image.asset(
          'assets/kraken_logo_trans.png',
          width: width,
          height: height,
          fit: BoxFit.cover,
          semanticLabel: 'Logo de KrakenDraw',
        ),
      ),
    );
  }
}
