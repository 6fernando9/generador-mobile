// Metrics skeleton for dashboard
import 'package:flutter/material.dart';
import 'package:mobile/presentation/shared/widgets/skeleton_base.dart';

/// Skeleton for metrics grid
class MetricsCardSkeleton extends StatelessWidget {
  final int count;

  const MetricsCardSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: count,
      itemBuilder: (context, index) => SkeletonBase(
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
              SkeletonText(width: 100, height: 14),
              const SizedBox(height: 12),
              SkeletonText(width: 80, height: 28),
              const SizedBox(height: 8),
              Row(
                children: [
                  SkeletonText(width: 60, height: 12),
                  const SizedBox(width: 8),
                  SkeletonText(width: 60, height: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}