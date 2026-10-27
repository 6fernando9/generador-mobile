// Membership history list for dashboard
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/neon_card.dart';
import '../../shared/widgets/skeleton_base.dart';

// Provider for membership history
final membershipHistoryProvider = FutureProvider<MembershipHistoryResponse>((ref) async {
  // TODO: Fetch from API
  // final response = await ApiClient.instance.dio.get(ApiEndpoints.pagosHistorial);
  // return MembershipHistoryResponse.fromJson(response.data);
  await Future.delayed(const Duration(milliseconds: 500));
  return MembershipHistoryResponse(
    items: [
      MembershipHistoryItem(
        id: '1',
        planName: 'Premium Mensual',
        amount: 29.99,
        currency: 'USD',
        status: 'completed',
        paidAt: DateTime.now().subtract(const Duration(days: 5)),
        paymentMethod: 'Stripe',
      ),
      MembershipHistoryItem(
        id: '2',
        planName: 'Premium Mensual',
        amount: 29.99,
        currency: 'USD',
        status: 'completed',
        paidAt: DateTime.now().subtract(const Duration(days: 35)),
        paymentMethod: 'Stripe',
      ),
      MembershipHistoryItem(
        id: '3',
        planName: 'Premium Anual',
        amount: 299.99,
        currency: 'USD',
        status: 'completed',
        paidAt: DateTime.now().subtract(const Duration(days: 400)),
        paymentMethod: 'Stripe',
      ),
      MembershipHistoryItem(
        id: '4',
        planName: 'Premium Mensual',
        amount: 29.99,
        currency: 'USD',
        status: 'failed',
        paidAt: DateTime.now().subtract(const Duration(days: 450)),
        paymentMethod: 'Stripe',
      ),
    ],
    totalItems: 4,
    totalPages: 1,
    currentPage: 1,
    pageSize: 10,
  );
});

/// Membership history item model
class MembershipHistoryItem {
  final String id;
  final String planName;
  final double amount;
  final String currency;
  final String status;
  final DateTime paidAt;
  final String paymentMethod;

  const MembershipHistoryItem({
    required this.id,
    required this.planName,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paidAt,
    required this.paymentMethod,
  });
}

/// Membership history response model
class MembershipHistoryResponse {
  final List<MembershipHistoryItem> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;

  const MembershipHistoryResponse({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  });
}

/// Membership history list widget
class MembershipHistoryList extends ConsumerWidget {
  const MembershipHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(membershipHistoryProvider);

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
          itemBuilder: (_, index) => _buildMembershipItem(context, response.items[index]),
        );
      },
      loading: () => const MembershipCardSkeleton(),
      error: (error, _) => _buildErrorState(context, error.toString()),
    );
  }

  Widget _buildMembershipItem(BuildContext context, MembershipHistoryItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = item.status == 'completed';
    final isFailed = item.status == 'failed';

    Color statusColor;
    IconData statusIcon;
    String statusLabel;

    if (isCompleted) {
      statusColor = Colors.greenAccent;
      statusIcon = Icons.check_circle_rounded;
      statusLabel = 'Pagado';
    } else if (isFailed) {
      statusColor = Colors.redAccent;
      statusIcon = Icons.cancel_rounded;
      statusLabel = 'Fallido';
    } else {
      statusColor = Colors.amber;
      statusIcon = Icons.hourglass_empty_rounded;
      statusLabel = 'Pendiente';
    }

    return GlowCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with plan name and status
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.credit_card_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.planName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      item.paymentMethod,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                    ),
                  ],
                ),
              ),
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
                      statusLabel,
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
          const SizedBox(height: 16),
          // Amount and date
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monto',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                    ),
                    Text(
                      '\${item.amount.toStringAsFixed(2)} ${item.currency}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Orbitron',
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Fecha',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                    ),
                    Text(
                      _formatDate(item.paidAt),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
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
            Icons.receipt_long_outlined,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin historial de pagos',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tus pagos aparecerán aquí',
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays < 1) {
      return 'Hoy';
    } else if (diff.inDays == 1) {
      return 'Ayer';
    } else if (diff.inDays < 7) {
      return 'Hace ${diff.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}