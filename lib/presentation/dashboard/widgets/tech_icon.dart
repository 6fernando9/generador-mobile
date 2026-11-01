// Renders a backend icon for a technology/catalog item.
//
// The backend sends `icono` + `icono_tipo`:
// - `upload` / `url` → remote image (usually SVG hosted in Floci/S3)
// - `icono`          → identifier from the icon catalog (Lucide names)
// - `none`           → no icon
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/core/network/api_client.dart';

class TechIcon extends StatelessWidget {
  final String? icono;
  final String? iconoTipo;
  final double size;
  final Color? color;
  final IconData fallback;

  const TechIcon({
    super.key,
    required this.icono,
    required this.iconoTipo,
    this.size = 20,
    this.color,
    this.fallback = Icons.extension_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    final value = icono?.trim();
    if (value == null || value.isEmpty || iconoTipo == 'none') {
      return _fallbackIcon(effectiveColor);
    }

    final tipo = iconoTipo ?? (value.startsWith('http') ? 'url' : 'icono');
    if (tipo == 'upload' || tipo == 'url' || value.startsWith('http')) {
      return _buildImage(value, effectiveColor);
    }

    return Icon(_materialIcon(value), size: size, color: effectiveColor);
  }

  Widget _fallbackIcon(Color color) => Icon(fallback, size: size, color: color);

  Widget _buildImage(String rawUrl, Color color) {
    String url;
    try {
      url = ApiClient.instance.buildImageUrl(rawUrl);
    } catch (_) {
      url = rawUrl;
    }

    final fallbackWidget = _fallbackIcon(color);
    final isSvg = url.toLowerCase().contains('.svg');

    if (isSvg) {
      return SvgPicture.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => SizedBox(width: size, height: size),
        errorBuilder: (context, error, stackTrace) => fallbackWidget,
      );
    }

    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => fallbackWidget,
    );
  }

  /// Best-effort mapping of the backend Lucide icon names to Material icons.
  IconData _materialIcon(String name) {
    return switch (name.toLowerCase()) {
      'go' || 'golang' => Icons.code_rounded,
      'java' => Icons.coffee_rounded,
      'typescript' || 'javascript' => Icons.javascript_rounded,
      'dart' => Icons.flutter_dash_rounded,
      'c#' || 'csharp' || 'csharp#' => Icons.tag_rounded,
      'python' => Icons.terminal_rounded,
      'spring' || 'spring_boot' => Icons.eco_rounded,
      'react' => Icons.science_rounded,
      'angular' => Icons.change_history_rounded,
      'vue' => Icons.hexagon_outlined,
      'flutter' => Icons.phone_android_rounded,
      'express' => Icons.bolt_rounded,
      'gin' => Icons.sports_bar_rounded,
      'dotnet' || '.net_core' => Icons.window_rounded,
      'fastapi' => Icons.rocket_launch_rounded,
      'flask' => Icons.science_outlined,
      'mvc' => Icons.account_tree_rounded,
      'ddd' => Icons.hub_rounded,
      'hibernate' => Icons.ac_unit_rounded,
      'prisma' => Icons.change_circle_rounded,
      'efcore' || 'entity_framework_core' => Icons.storage_rounded,
      'gorm' => Icons.dataset_rounded,
      'postgresql' || 'mysql' || 'sqlserver' || 'sqlite' => Icons.dns_rounded,
      'sql' => Icons.table_chart_rounded,
      'xml' => Icons.data_object_rounded,
      'server' => Icons.dns_rounded,
      'globe' => Icons.language_rounded,
      'smartphone' => Icons.smartphone_rounded,
      'file-text' => Icons.description_rounded,
      'database' => Icons.storage_rounded,
      'cpu' => Icons.memory_rounded,
      'shapes' => Icons.category_rounded,
      _ => fallback,
    };
  }
}

/// Fallback icon for a technology dimension.
IconData iconoFallbackCategoria(String apiKey) => switch (apiKey) {
  'lenguajes' => Icons.code_rounded,
  'frameworks' => Icons.web_rounded,
  'arquitecturas' => Icons.account_tree_rounded,
  'orms' => Icons.storage_rounded,
  'bases_datos' => Icons.dns_rounded,
  'tipos_artefacto' => Icons.category_rounded,
  'tipos_reporte' => Icons.description_rounded,
  'tipos_xml' => Icons.data_object_rounded,
  _ => Icons.extension_rounded,
};
