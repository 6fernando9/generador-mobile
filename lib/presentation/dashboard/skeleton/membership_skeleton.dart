// Membership skeleton for dashboard
import 'package:flutter/material.dart';
import 'package:mobile/presentation/shared/widgets/skeleton_base.dart';

/// Skeleton for membership card
class MembershipCardSkeleton extends StatelessWidget {
  const MembershipCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SkeletonBase(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tu Suscripción',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SkeletonBox(width: 80, height: 28, borderRadius: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonText(width: 140, height: 14),
                          const SizedBox(height: 4),
                          SkeletonText(width: 100, height: 13),
                        ],
                      ),
                    ),
                    SkeletonBox(width: 100, height: 32, borderRadius: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, __) => SkeletonBase(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SkeletonBox(width: 40, height: 40, borderRadius: 10),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonText(width: 140, height: 16),
                            const SizedBox(height: 4),
                            SkeletonText(width: 100, height: 12),
                          ],
                        ),
                      ),
                      SkeletonBox(width: 80, height: 28, borderRadius: 20),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonText(width: 40, height: 12),
                            const SizedBox(height: 4),
                            SkeletonText(width: 100, height: 18),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SkeletonText(width: 40, height: 12),
                            const SizedBox(height: 4),
                            SkeletonText(width: 80, height: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}