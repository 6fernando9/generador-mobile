// Project Ranking List for Dashboard
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/theme/neon_colors.dart';
import 'package:mobile/data/models/dashboard_proyectos.dart';
import 'package:mobile/presentation/shared/widgets/neon_card.dart';
import 'package:mobile/presentation/shared/widgets/skeleton_base.dart'
    show SkeletonBase, SkeletonBox, SkeletonText;

/// List of top projects with progress bars
class ProjectRankingList extends ConsumerWidget {
  final DashboardProyectos? proyectos;
  final bool isLoading;
  final String? error;
  final int maxItems;

  const ProjectRankingList({
    super.key,
    this.proyectos,
    this.isLoading = false,
    this.error,
    this.maxItems = 10,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return _buildSkeleton(context);
    }

    if (error != null) {
      return _buildError(context, error!);
    }

    if (proyectos == null || proyectos!.proyectos.isEmpty) {
      return _buildEmpty(context);
    }

    final items = proyectos!.proyectos.take(maxItems).toList();
    final maxGeneraciones = items.first.total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Proyectos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            TextButton.icon(
              onPressed: () {
                // TODO: Navigate to full projects list
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ver todos los proyectos - En desarrollo'),
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  ),
                );
              },
              icon: const Icon(Icons.list_rounded, size: 16),
              label: Text(
                'Ver todo',
                style: GoogleFonts.inter(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final project = items[index];
            final progress = maxGeneraciones > 0 ? project.total / maxGeneraciones : 0.0;
            final rankColor = _getRankColor(index, isDark);
            final neonColor = _getNeonColor(index, isDark);

            return Animate(
              effects: [
                FadeEffect(duration: 400.ms, delay: Duration(milliseconds: 100 * index)),
                SlideEffect(begin: const Offset(0.2, 0), end: Offset.zero, duration: 400.ms, delay: Duration(milliseconds: 100 * index)),
              ],
              child: _ProjectCard(
                project: project,
                rank: index + 1,
                progress: progress,
                rankColor: rankColor,
                neonColor: neonColor,
                onTap: () {
                  // TODO: Navigate to project detail
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Detalle de ${project.nombre} - En desarrollo'),
                      backgroundColor: colorScheme.surfaceContainerHighest,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getRankColor(int index, bool isDark) {
    switch (index) {
      case 0:
        return isDark ? NeonColors.yellowDark : NeonColors.yellowLight;
      case 1:
        return isDark ? NeonColors.cyanDark : NeonColors.cyanLight;
      case 2:
        return isDark ? NeonColors.orangeDark : NeonColors.orangeLight;
      default:
        return isDark ? NeonColors.magentaDark : NeonColors.magentaLight;
    }
  }

  Color _getNeonColor(int index, bool isDark) {
    final colors = [
      isDark ? NeonColors.yellowDark : NeonColors.yellowLight,
      isDark ? NeonColors.cyanDark : NeonColors.cyanLight,
      isDark ? NeonColors.orangeDark : NeonColors.orangeLight,
      isDark ? NeonColors.magentaDark : NeonColors.magentaLight,
      isDark ? NeonColors.purpleDark : NeonColors.purpleLight,
      isDark ? NeonColors.greenDark : NeonColors.greenLight,
      isDark ? NeonColors.blueDark : NeonColors.blueLight,
      isDark ? NeonColors.pinkDark : NeonColors.pinkLight,
    ];
    return colors[index % colors.length];
  }

  Widget _buildSkeleton(BuildContext context) {
    return Column(
      children: List.generate(5, (index) => Padding(
        padding: EdgeInsets.only(bottom: index == 4 ? 0 : 8),
        child: const _ProjectCardSkeleton(),
      )),
    );
  }

  Widget _buildError(BuildContext context, String error) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text(
            'Error al cargar proyectos',
            style: GoogleFonts.spaceGrotesk(fontSize: 16, color: colorScheme.onSurface.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: GoogleFonts.inter(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.5)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GlowCard(
      child: Column(
        children: [
          Icon(
            Icons.folder_open_rounded,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin proyectos aún',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tus proyectos aparecerán aquí al generar código',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectRanking project;
  final int rank;
  final double progress;
  final Color rankColor;
  final Color neonColor;
  final VoidCallback onTap;

  const _ProjectCard({
    required this.project,
    required this.rank,
    required this.progress,
    required this.rankColor,
    required this.neonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: GlowCard(
          glowColor: neonColor,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Rank badge
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      rankColor.withValues(alpha: 0.3),
                      rankColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: rankColor.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: rankColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '#$rank',
                    style: GoogleFonts.orbitron(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: rankColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Project info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            project.nombre,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Percentage badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: neonColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: neonColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            '${project.porcentaje.toStringAsFixed(1)}%',
                            style: GoogleFonts.orbitron(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: neonColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Progress bar
                    Stack(
                      children: [
                        // Background track
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        // Progress fill
                        FractionallySizedBox(
                          widthFactor: progress.clamp(0.0, 1.0),
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  neonColor,
                                  neonColor.withValues(alpha: 0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: neonColor.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Generations count
                    Text(
                      '${_formatNumber(project.total)} generaciones',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Chevron
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurface.withValues(alpha: 0.3),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class _ProjectCardSkeleton extends StatelessWidget {
  const _ProjectCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SkeletonBase(
      child: _ProjectCardSkeletonContent(),
    );
  }
}

class _ProjectCardSkeletonContent extends StatelessWidget {
  const _ProjectCardSkeletonContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SkeletonBox(width: 36, height: 36, borderRadius: 10),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonText(width: 120, height: 16),
                const SizedBox(height: 8),
                SkeletonBox(width: double.infinity, height: 8, borderRadius: 4),
                const SizedBox(height: 6),
                SkeletonText(width: 80, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}