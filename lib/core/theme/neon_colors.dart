/// Neon color palette for KrakenDraw - works in both light and dark modes
import 'package:flutter/material.dart';

/// Neon color constants inspired by the web version
/// These colors are designed to pop on both dark and light backgrounds
class NeonColors {
  // Primary neon colors
  static const Color cyan = Color(0xFF00FFFF);
  static const Color magenta = Color(0xFFFF00FF);
  static const Color purple = Color(0xFFBF00FF);
  static const Color green = Color(0xFF39FF14);
  static const Color orange = Color(0xFFFF6A00);
  static const Color blue = Color(0xFF0080FF);
  static const Color pink = Color(0xFFFF1493);
  static const Color yellow = Color(0xFFFFEA00);

  // Dark mode optimized (brighter, more saturated)
  static const Color cyanDark = Color(0xFF00FFFF);
  static const Color magentaDark = Color(0xFFFF00FF);
  static const Color purpleDark = Color(0xFFD000FF);
  static const Color greenDark = Color(0xFF00FF41);
  static const Color orangeDark = Color(0xFFFF5500);
  static const Color blueDark = Color(0xFF0099FF);
  static const Color pinkDark = Color(0xFFFF00AA);
  static const Color yellowDark = Color(0xFFF5FF00);

  // Light mode optimized (darker, more readable)
  static const Color cyanLight = Color(0xFF00B4D8);
  static const Color magentaLight = Color(0xFFC71585);
  static const Color purpleLight = Color(0xFF8A2BE2);
  static const Color greenLight = Color(0xFF2E8B57);
  static const Color orangeLight = Color(0xFFE67E22);
  static const Color blueLight = Color(0xFF2980B9);
  static const Color pinkLight = Color(0xFFE91E63);
  static const Color yellowLight = Color(0xFFF39C12);

  // Glow colors for shadows and borders
  static const Color glowCyanDark = Color(0x4400FFFF);
  static const Color glowMagentaDark = Color(0x44FF00FF);
  static const Color glowPurpleDark = Color(0x44BF00FF);
  static const Color glowGreenDark = Color(0x4439FF14);

  static const Color glowCyanLight = Color(0x3300B4D8);
  static const Color glowMagentaLight = Color(0x33C71585);
  static const Color glowPurpleLight = Color(0x338A2BE2);
  static const Color glowGreenLight = Color(0x332E8B57);

  // Gradient combinations for backgrounds
  static const List<Color> darkGradient = [
    Color(0xFF0A0A1A),
    Color(0xFF1A0A2E),
    Color(0xFF0F0A1F),
  ];

  static const List<Color> lightGradient = [
    Color(0xFFF8F9FF),
    Color(0xFFEDEBFF),
    Color(0xFFF0F8FF),
  ];

  /// Get neon color for current theme
  static Color getNeon(String name, bool isDark) {
    final darkMap = {
      'cyan': cyanDark,
      'magenta': magentaDark,
      'purple': purpleDark,
      'green': greenDark,
      'orange': orangeDark,
      'blue': blueDark,
      'pink': pinkDark,
      'yellow': yellowDark,
    };
    final lightMap = {
      'cyan': cyanLight,
      'magenta': magentaLight,
      'purple': purpleLight,
      'green': greenLight,
      'orange': orangeLight,
      'blue': blueLight,
      'pink': pinkLight,
      'yellow': yellowLight,
    };
    return isDark ? (darkMap[name] ?? cyanDark) : (lightMap[name] ?? cyanLight);
  }

  /// Get glow color for current theme
  static Color getGlow(String name, bool isDark) {
    final darkMap = {
      'cyan': glowCyanDark,
      'magenta': glowMagentaDark,
      'purple': glowPurpleDark,
      'green': glowGreenDark,
    };
    final lightMap = {
      'cyan': glowCyanLight,
      'magenta': glowMagentaLight,
      'purple': glowPurpleLight,
      'green': glowGreenLight,
    };
    return isDark ? (darkMap[name] ?? glowCyanDark) : (lightMap[name] ?? glowCyanLight);
  }

  /// Glow color maps for easy access
  static const Map<String, Color> glowDark = {
    'cyan': glowCyanDark,
    'magenta': glowMagentaDark,
    'purple': glowPurpleDark,
    'green': glowGreenDark,
  };

  static const Map<String, Color> glowLight = {
    'cyan': glowCyanLight,
    'magenta': glowMagentaLight,
    'purple': glowPurpleLight,
    'green': glowGreenLight,
  };

  /// Get gradient for current theme
  static List<Color> getGradient(bool isDark) {
    return isDark ? darkGradient : lightGradient;
  }
}

/// Neon color scheme for easy theming
class NeonColorScheme {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color onPrimary;
  final Color onSecondary;
  final Color onBackground;
  final Color onSurface;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color glowPrimary;
  final Color glowSecondary;

  const NeonColorScheme({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.onPrimary,
    required this.onSecondary,
    required this.onBackground,
    required this.onSurface,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.glowPrimary,
    required this.glowSecondary,
  });

  /// Dark neon color scheme
  static const NeonColorScheme dark = NeonColorScheme(
    primary: NeonColors.cyanDark,
    secondary: NeonColors.magentaDark,
    accent: NeonColors.purpleDark,
    background: Color(0xFF0A0A1A),
    surface: Color(0xFF15152A),
    surfaceVariant: Color(0xFF1E1E3A),
    onPrimary: Color(0xFF000000),
    onSecondary: Color(0xFF000000),
    onBackground: Color(0xFFFFFFFF),
    onSurface: Color(0xFFFFFFFF),
    outline: Color(0xFF333355),
    outlineVariant: Color(0xFF2A2A4A),
    shadow: Color(0x88000000),
    glowPrimary: NeonColors.glowCyanDark,
    glowSecondary: NeonColors.glowMagentaDark,
  );

  /// Light neon color scheme
  static const NeonColorScheme light = NeonColorScheme(
    primary: NeonColors.cyanLight,
    secondary: NeonColors.magentaLight,
    accent: NeonColors.purpleLight,
    background: Color(0xFFFAFBFF),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFF0F0FA),
    onPrimary: Color(0xFF000000),
    onSecondary: Color(0xFF000000),
    onBackground: Color(0xFF0A0A1A),
    onSurface: Color(0xFF0A0A1A),
    outline: Color(0xFFD0D0E8),
    outlineVariant: Color(0xFFE0E0F0),
    shadow: Color(0x22000000),
    glowPrimary: NeonColors.glowCyanLight,
    glowSecondary: NeonColors.glowMagentaLight,
  );
}