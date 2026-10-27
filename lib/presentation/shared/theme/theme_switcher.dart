// Theme switcher provider for KrakenDraw
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Theme mode notifier with persistence
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeKey = 'app_theme_mode';

  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey);
      if (themeIndex != null) {
        state = ThemeMode.values[themeIndex];
      }
    } catch (_) {
      // Ignore errors, use default
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, mode.index);
    } catch (_) {
      // Ignore errors
    }
  }

  void toggleTheme() {
    switch (state) {
      case ThemeMode.light:
        setThemeMode(ThemeMode.dark);
      case ThemeMode.dark:
        setThemeMode(ThemeMode.system);
      case ThemeMode.system:
        setThemeMode(ThemeMode.light);
    }
  }

  void setLight() => setThemeMode(ThemeMode.light);
  void setDark() => setThemeMode(ThemeMode.dark);
  void setSystem() => setThemeMode(ThemeMode.system);
}

/// Consumer widget to easily access theme mode
class ThemeModeConsumer extends ConsumerWidget {
  final Widget Function(BuildContext, ThemeMode, WidgetRef) builder;
  final Widget? child;

  const ThemeModeConsumer({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return builder(context, themeMode, ref);
  }
}

/// Theme toggle button widget
class ThemeToggleButton extends ConsumerWidget {
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  const ThemeToggleButton({
    super.key,
    this.iconSize = 24,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final notifier = ref.read(themeModeProvider.notifier);

    IconData icon;
    String tooltip;
    Color? color;

    switch (themeMode) {
      case ThemeMode.light:
        icon = Icons.light_mode_rounded;
        tooltip = 'Modo claro - Tocar para modo oscuro';
        color = Colors.amber;
        break;
      case ThemeMode.dark:
        icon = Icons.dark_mode_rounded;
        tooltip = 'Modo oscuro - Tocar para modo sistema';
        color = Colors.indigoAccent;
        break;
      case ThemeMode.system:
        icon = Icons.settings_brightness_rounded;
        tooltip = 'Modo sistema - Tocar para modo claro';
        color = Colors.tealAccent;
        break;
    }

    return IconButton(
      icon: Icon(icon, size: iconSize, color: color),
      tooltip: tooltip,
      onPressed: notifier.toggleTheme,
      padding: padding ?? const EdgeInsets.all(8),
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
    ).animate().fadeIn(duration: 300.ms).scale(delay: 100.ms);
  }
}

/// Theme selector bottom sheet
class ThemeSelectorSheet extends ConsumerWidget {
  const ThemeSelectorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final notifier = ref.read(themeModeProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Apariencia',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 24),
          ..._buildThemeOptions(context, themeMode, notifier),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _buildThemeOptions(
    BuildContext context,
    ThemeMode currentMode,
    ThemeModeNotifier notifier,
  ) {
    final options = [
      _ThemeOption(
        mode: ThemeMode.light,
        title: 'Claro',
        subtitle: 'Siempre usar tema claro',
        icon: Icons.light_mode_rounded,
        color: Colors.amber,
      ),
      _ThemeOption(
        mode: ThemeMode.dark,
        title: 'Oscuro',
        subtitle: 'Siempre usar tema oscuro',
        icon: Icons.dark_mode_rounded,
        color: Colors.indigoAccent,
      ),
      _ThemeOption(
        mode: ThemeMode.system,
        title: 'Sistema',
        subtitle: 'Seguir configuración del dispositivo',
        icon: Icons.settings_brightness_rounded,
        color: Colors.tealAccent,
      ),
    ];

    return options.map((option) {
      final isSelected = option.mode == currentMode;
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              notifier.setThemeMode(option.mode);
              Navigator.of(context).pop();
            },
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? option.color : Theme.of(context).dividerColor,
                  width: isSelected ? 2 : 1,
                ),
                color: isSelected
                    ? option.color.withValues(alpha: 0.1)
                    : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected ? option.color : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      option.icon,
                      color: isSelected ? Theme.of(context).colorScheme.onPrimary : option.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected ? option.color : null,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          option.subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: option.color,
                      size: 24,
                    ),
                ],
              ),
            ),
          ),
        ),
      ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1, end: 0);
    }).toList();
  }
}

class _ThemeOption {
  final ThemeMode mode;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  _ThemeOption({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

/// Show theme selector bottom sheet
Future<void> showThemeSelector(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const ThemeSelectorSheet(),
  );
}