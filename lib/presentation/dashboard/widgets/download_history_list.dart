// Download history list for dashboard
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/neon_card.dart';
import '../../shared/widgets/skeleton_base.dart';

// Provider for download history
final downloadHistoryProvider = FutureProvider<DownloadHistoryResponse>((ref) async {
  // TODO: Fetch from API
  // final response = await ApiClient.instance.dio.get(
  //   ApiEndpoints.logs,
  //   queryParameters: {'page': 1, 'perPage': 10},
  // );
  // return DownloadHistoryResponse.fromJson(response.data);
  await Future.delayed(const Duration(milliseconds: 500));
  return DownloadHistoryResponse(
    items: [
      DownloadHistoryItem(
        id: '1',
        artifactType: 'Flutter MVC',
        projectName: 'E-commerce App',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'completed',
      ),
      DownloadHistoryItem(
        id: '2',
        artifactType: 'Spring Boot DDD',
        projectName: 'API Gateway',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: 'completed',
      ),
      DownloadHistoryItem(
        id: '3',
        artifactType: 'Express Prisma',
        projectName: 'Auth Service',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        status: 'failed',
      ),
      DownloadHistoryItem(
        id: '4',
        artifactType: 'Flutter Clean',
        projectName: 'Dashboard App',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        status: 'completed',
      ),
      DownloadHistoryItem(
        id: '5',
        artifactType: 'React TypeScript',
        projectName: 'Admin Panel',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        status: 'completed',
      ),
    ],
    totalItems: 5,
    totalPages: 1,
    currentPage: 1,
    pageSize: 10,
  );
});

/// Download history item model
class DownloadHistoryItem {
  final String id;
  final String artifactType;
  final String projectName;
  final DateTime createdAt;
  final String status;

  const DownloadHistoryItem({
    required this.id,
    required this.artifactType,
    required this.projectName,
    required this.createdAt,
    required this.status,
  });
}

/// Download history response model
class DownloadHistoryResponse {
  final List<DownloadHistoryItem> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;

  const DownloadHistoryResponse({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  });
}

/// Download history list widget
class DownloadHistoryList extends ConsumerWidget {
  const DownloadHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(downloadHistoryProvider);

    return historyAsync.when(
      data: (response) {
        if (response.items.isEmpty) {
          return _buildEmptyState(context);
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: response.items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) => _buildHistoryItem(context, response.items[index]),
        );
      },
      loading: () => const HistoryListSkeleton(itemCount: 5),
      error: (error, _) => _buildErrorState(context, error.toString()),
    );
  }

  Widget _buildHistoryItem(BuildContext context, DownloadHistoryItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = item.status == 'completed';
    final isFailed = item.status == 'failed';

    Color statusColor;
    IconData statusIcon;

    if (isCompleted) {
      statusColor = Colors.greenAccent;
      statusIcon = Icons.check_circle_rounded;
    } else if (isFailed) {
      statusColor = Colors.redAccent;
      statusIcon = Icons.error_rounded;
    } else {
      statusColor = Colors.amber;
      statusIcon = Icons.hourglass_empty_rounded;
    }

    return GlowCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Artifact type icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getArtifactIcon(item.artifactType),
              color: colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.artifactType,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.projectName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(item.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                ),
              ],
            ),
          ),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, color: statusColor, size: 14),
                const SizedBox(width: 4),
                Text(
                  isCompleted ? 'Completado' : (isFailed ? 'Fallido' : 'Pendiente'),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GlowCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.download_outlined,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin historial de descargas',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tus generaciones aparecerán aquí',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final colorScheme = Theme.of(context).colorScheme;

    return GlowCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar historial',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getArtifactIcon(String artifactType) {
    if (artifactType.toLowerCase().contains('flutter')) return Icons.flutter_dash_rounded;
    if (artifactType.toLowerCase().contains('spring')) return Icons.code_rounded;
    if (artifactType.toLowerCase().contains('express')) return Icons.web_rounded;
    if (artifactType.toLowerCase().contains('react')) return Icons.web_asset_rounded;
    if (artifactType.toLowerCase().contains('prisma')) return Icons.storage_rounded;
    return Icons.code_rounded;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return 'Hace ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'Hace ${diff.inHours} h';
    } else if (diff.inDays < 7) {
      return 'Hace ${diff.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}