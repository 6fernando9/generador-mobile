// History list skeleton for dashboard
import 'package:flutter/material.dart';
import 'package:mobile/presentation/shared/widgets/skeleton_base.dart';

/// Skeleton for download history list
class HistoryListSkeleton extends StatelessWidget {
  final int itemCount;

  const HistoryListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
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
          child: Row(
            children: [
              SkeletonBox(width: 48, height: 48, borderRadius: 10),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonText(width: double.infinity, height: 16),
                    const SizedBox(height: 6),
                    SkeletonText(width: 150, height: 12),
                    const SizedBox(height: 4),
                    SkeletonText(width: 100, height: 11),
                  ],
                ),
              ),
              SkeletonBox(width: 80, height: 28, borderRadius: 20),
            ],
          ),
        ),
      ),
    );
  }
}