// Responsive utilities for KrakenDraw
import 'package:flutter/material.dart';

/// Screen breakpoints following Material Design guidelines
class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1600;
}

/// Device type enum for responsive layouts
enum DeviceType { mobile, tablet, desktop, largeDesktop }

/// Responsive helper class for adaptive layouts
class Responsive {
  const Responsive._();

  /// Get device type based on screen width
  static DeviceType deviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppBreakpoints.mobile) return DeviceType.mobile;
    if (width < AppBreakpoints.tablet) return DeviceType.tablet;
    if (width < AppBreakpoints.desktop) return DeviceType.desktop;
    return DeviceType.largeDesktop;
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < AppBreakpoints.mobile;

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppBreakpoints.mobile && width < AppBreakpoints.desktop;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppBreakpoints.desktop;

  /// Check if current screen is large desktop
  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppBreakpoints.largeDesktop;

  /// Responsive horizontal padding based on screen size
  static EdgeInsets horizontalPadding(BuildContext context) {
    final type = deviceType(context);
    switch (type) {
      case DeviceType.mobile:
        return const EdgeInsets.symmetric(horizontal: 16);
      case DeviceType.tablet:
        return const EdgeInsets.symmetric(horizontal: 24);
      case DeviceType.desktop:
        return const EdgeInsets.symmetric(horizontal: 32);
      case DeviceType.largeDesktop:
        return const EdgeInsets.symmetric(horizontal: 48);
    }
  }

  /// Responsive vertical padding based on screen size
  static EdgeInsets verticalPadding(BuildContext context) {
    final type = deviceType(context);
    switch (type) {
      case DeviceType.mobile:
        return const EdgeInsets.symmetric(vertical: 16);
      case DeviceType.tablet:
        return const EdgeInsets.symmetric(vertical: 20);
      case DeviceType.desktop:
        return const EdgeInsets.symmetric(vertical: 24);
      case DeviceType.largeDesktop:
        return const EdgeInsets.symmetric(vertical: 32);
    }
  }

  /// Responsive all-around padding
  static EdgeInsets padding(BuildContext context) {
    final type = deviceType(context);
    switch (type) {
      case DeviceType.mobile:
        return const EdgeInsets.all(16);
      case DeviceType.tablet:
        return const EdgeInsets.all(20);
      case DeviceType.desktop:
        return const EdgeInsets.all(24);
      case DeviceType.largeDesktop:
        return const EdgeInsets.all(32);
    }
  }

  /// Responsive max width for content containers
  static double maxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final type = deviceType(context);
    switch (type) {
      case DeviceType.mobile:
        return width; // Full width on mobile
      case DeviceType.tablet:
        return 540;
      case DeviceType.desktop:
        return 480;
      case DeviceType.largeDesktop:
        return 420;
    }
  }

  /// Responsive spacing between form fields
  static double fieldSpacing(BuildContext context) {
    final type = deviceType(context);
    switch (type) {
      case DeviceType.mobile:
        return 16.0;
      case DeviceType.tablet:
        return 20.0;
      case DeviceType.desktop:
        return 24.0;
      case DeviceType.largeDesktop:
        return 28.0;
    }
  }

  /// Responsive spacing between sections
  static double sectionSpacing(BuildContext context) {
    final type = deviceType(context);
    switch (type) {
      case DeviceType.mobile:
        return 24.0;
      case DeviceType.tablet:
        return 28.0;
      case DeviceType.desktop:
        return 32.0;
      case DeviceType.largeDesktop:
        return 40.0;
    }
  }

  /// Responsive avatar radius
  static double avatarRadius(BuildContext context) {
    final type = deviceType(context);
    switch (type) {
      case DeviceType.mobile:
        return 40.0;
      case DeviceType.tablet:
        return 48.0;
      case DeviceType.desktop:
        return 52.0;
      case DeviceType.largeDesktop:
        return 56.0;
    }
  }

  /// Responsive icon size
  static double iconSize(BuildContext context, {double baseSize = 24}) {
    final type = deviceType(context);
    switch (type) {
      case DeviceType.mobile:
        return baseSize * 0.9;
      case DeviceType.tablet:
        return baseSize;
      case DeviceType.desktop:
        return baseSize * 1.1;
      case DeviceType.largeDesktop:
        return baseSize * 1.2;
    }
  }

  /// Responsive font size multiplier
  static double fontScale(BuildContext context) {
    final type = deviceType(context);
    switch (type) {
      case DeviceType.mobile:
        return 0.95;
      case DeviceType.tablet:
        return 1.0;
      case DeviceType.desktop:
        return 1.05;
      case DeviceType.largeDesktop:
        return 1.1;
    }
  }

  /// Responsive button height
  static double buttonHeight(BuildContext context) {
    final type = deviceType(context);
    switch (type) {
      case DeviceType.mobile:
        return 48.0;
      case DeviceType.tablet:
        return 52.0;
      case DeviceType.desktop:
        return 56.0;
      case DeviceType.largeDesktop:
        return 60.0;
    }
  }

  /// Responsive border radius
  static double borderRadius(BuildContext context, {double baseRadius = 12}) {
    final type = deviceType(context);
    switch (type) {
      case DeviceType.mobile:
        return baseRadius * 0.8;
      case DeviceType.tablet:
        return baseRadius;
      case DeviceType.desktop:
        return baseRadius * 1.1;
      case DeviceType.largeDesktop:
        return baseRadius * 1.2;
    }
  }

  /// Get responsive value based on device type
  static T value<T>(BuildContext context, {
    required T mobile,
    required T tablet,
    required T desktop,
    required T largeDesktop,
  }) {
    final type = deviceType(context);
    switch (type) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.desktop:
        return desktop;
      case DeviceType.largeDesktop:
        return largeDesktop;
    }
  }

  /// Responsive grid columns count
  static int gridColumns(BuildContext context, {int maxColumns = 4}) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppBreakpoints.mobile) return 1;
    if (width < AppBreakpoints.tablet) return 2;
    if (width < AppBreakpoints.desktop) return 3;
    return maxColumns > 4 ? 4 : maxColumns;
  }

  /// Responsive card aspect ratio
  static double cardAspectRatio(BuildContext context) {
    final type = deviceType(context);
    switch (type) {
      case DeviceType.mobile:
        return 1.0;
      case DeviceType.tablet:
        return 1.1;
      case DeviceType.desktop:
        return 1.15;
      case DeviceType.largeDesktop:
        return 1.2;
    }
  }
}

/// Extension for easier access to responsive utilities
extension ResponsiveContext on BuildContext {
  DeviceType get deviceType => Responsive.deviceType(this);
  bool get isMobile => Responsive.isMobile(this);
  bool get isTablet => Responsive.isTablet(this);
  bool get isDesktop => Responsive.isDesktop(this);
  bool get isLargeDesktop => Responsive.isLargeDesktop(this);

  EdgeInsets get responsivePadding => Responsive.padding(this);
  EdgeInsets get responsiveHorizontalPadding => Responsive.horizontalPadding(this);
  EdgeInsets get responsiveVerticalPadding => Responsive.verticalPadding(this);
  double get responsiveMaxContentWidth => Responsive.maxContentWidth(this);
  double get responsiveFieldSpacing => Responsive.fieldSpacing(this);
  double get responsiveSectionSpacing => Responsive.sectionSpacing(this);
  double get responsiveAvatarRadius => Responsive.avatarRadius(this);
  double get responsiveIconSize => Responsive.iconSize(this);
  double get responsiveFontScale => Responsive.fontScale(this);
  double get responsiveButtonHeight => Responsive.buttonHeight(this);
  double get responsiveBorderRadius => Responsive.borderRadius(this);

  T responsiveValue<T>({
    required T mobile,
    required T tablet,
    required T desktop,
    required T largeDesktop,
  }) => Responsive.value(this,
    mobile: mobile, tablet: tablet, desktop: desktop, largeDesktop: largeDesktop);
}