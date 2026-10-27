// Metrics cards for dashboard
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/neon_card.dart';

// Provider for dashboard metrics
final dashboardMetricsProvider = FutureProvider<List<DashboardMetric>>((ref) async {
  // TODO: Fetch from API
  // final response = await ApiClient.instance.dio.get(ApiEndpoints.dashboardResumen);
  // return DashboardMetric.fromJsonList(response.data);
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    DashboardMetric(
      title: 'Generaciones Hoy',
      value: '12',
      subtitle: '+2 respecto a ayer',
      icon: Icons.show_chart_rounded,
      color: 'cyan',
    ),
    DashboardMetric(
      title: 'Esta Semana',
      value: '45',
      subtitle: '+5 respecto a la semana anterior',
      icon: Icons.show_chart_rounded,
      color: 'magenta',
    ),
    DashboardMetric(
      title: 'Este Mes',
      value: '156',
      subtitle: '+12 respecto al mes anterior',
      icon: Icons.show_chart_rounded,
      color: 'purple',
    ),
    DashboardMetric(
      title: 'Total',
      value: '1.243',
      subtitle: 'generaciones totales',
      icon: Icons.insights_rounded,
      color: 'green',
    ),
  ];
});

/// Dashboard metric model
class DashboardMetric {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final String color;

  const DashboardMetric({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  // factory DashboardMetric.fromJson(Map<String, dynamic> json) {
  //   return DashboardMetric(
  //     title: json['title'] ?? '',
  //     value: json['value']?.toString() ?? '0',
  //     subtitle: json['subtitle'] ?? '',
  //     icon: IconData(json['icon'] ?? Icons.show_chart.codePoint, fontFamily: 'MaterialIcons'),
  //     color: json['color'] ?? 'cyan',
  //   );
  // }
}