import 'package:flutter/material.dart';

/// Single source of truth for spacing, radius, type scale and semantic colors.
/// Prefer these over numeric literals and `Colors.*` in widgets.
class AppSpacing {
  AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class AppBreakpoints {
  AppBreakpoints._();

  /// The UI is phone-first; on wider screens (tablets, desktop windows,
  /// landscape) content is centered and capped to this width.
  static const double contentMaxWidth = 600;
}

class AppRadius {
  AppRadius._();

  static const double sm = 8; // inputs, small chips
  static const double md = 12; // buttons, small cards
  static const double lg = 16; // cards, sheets
  static const double xl = 24; // large surfaces, bottom bar

  static BorderRadius get smAll => BorderRadius.circular(sm);

  static BorderRadius get mdAll => BorderRadius.circular(md);

  static BorderRadius get lgAll => BorderRadius.circular(lg);

  static BorderRadius get xlAll => BorderRadius.circular(xl);
}

/// Type scale. Minimum readable size is 12.
class AppType {
  AppType._();

  static const double caption = 12;
  static const double body = 14;
  static const double bodyLarge = 16;
  static const double title = 18;
  static const double headline = 22;
  static const double display = 28;
}

/// Semantic (status) colors. Same hues in light and dark; use [on] helpers
/// for readable foreground text.
class AppColors {
  AppColors._();

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  /// Light screen background / dark screen background.
  static const Color backgroundLight = Color(0xFFF1F3F4);
  static const Color backgroundDark = Color(0xFF121212);

  /// Readable text/icon color on top of [background] (works for any seed
  /// color, including light ones such as lime or amber).
  static Color on(Color background) =>
      ThemeData.estimateBrightnessForColor(background) == Brightness.dark
          ? Colors.white
          : Colors.black87;
}

extension AppThemeContext on BuildContext {
  /// Surface color for cards/tiles; follows light (white) and dark (black).
  Color get appCardColor =>
      Theme.of(this).cardTheme.color ?? Theme.of(this).colorScheme.surface;

  /// Screen background (matches the scaffold).
  Color get appBackground => Theme.of(this).scaffoldBackgroundColor;

  /// Primary text/icon color for the current brightness.
  Color get appOnSurface => Theme.of(this).colorScheme.onSurface;
}
