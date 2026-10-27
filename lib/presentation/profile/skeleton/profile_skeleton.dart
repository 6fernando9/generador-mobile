// Profile skeleton for KrakenDraw
import 'package:flutter/material.dart';
import 'package:mobile/presentation/shared/widgets/skeleton_base.dart';

/// Skeleton for profile page
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SkeletonBase(
        child: Column(
          children: [
            // Avatar section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  SkeletonCircle(size: 100),
                  const SizedBox(height: 16),
                  SkeletonText(width: 180, height: 24),
                  const SizedBox(height: 8),
                  SkeletonText(width: 220, height: 16),
                  const SizedBox(height: 4),
                  SkeletonBox(width: 100, height: 24, borderRadius: 20),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Stats row
            Row(
              children: [
                Expanded(child: _statSkeleton(context)),
                const SizedBox(width: 12),
                Expanded(child: _statSkeleton(context)),
                const SizedBox(width: 12),
                Expanded(child: _statSkeleton(context)),
              ],
            ),
            const SizedBox(height: 24),
            // Action buttons
            Row(
              children: [
                Expanded(child: SkeletonBox(height: 48, borderRadius: 12)),
                const SizedBox(width: 12),
                Expanded(child: SkeletonBox(height: 48, borderRadius: 12)),
              ],
            ),
            const SizedBox(height: 24),
            // Sections
            ...List.generate(3, (index) => Column(
              children: [
                SkeletonBase(child: _sectionSkeleton(context)),
                const SizedBox(height: 16),
              ],
            )),
            const SizedBox(height: 24),
            // Logout button
            SkeletonBox(height: 48, borderRadius: 12),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _statSkeleton(BuildContext context) {
    return Container(
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
        children: [
          SkeletonText(width: 60, height: 24),
          const SizedBox(height: 4),
          SkeletonText(width: 40, height: 12),
        ],
      ),
    );
  }

  Widget _sectionSkeleton(BuildContext context) {
    return Container(
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
              SkeletonBox(width: 36, height: 36, borderRadius: 8),
              const SizedBox(width: 12),
              SkeletonText(width: 120, height: 18),
              const Spacer(),
              SkeletonBox(width: 80, height: 28, borderRadius: 20),
            ],
          ),
          const SizedBox(height: 16),
          SkeletonText(width: double.infinity, height: 14),
          const SizedBox(height: 8),
          SkeletonText(width: 200, height: 14),
          const SizedBox(height: 8),
          SkeletonText(width: 150, height: 14),
        ],
      ),
    );
  }
}