import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:good_manager/constant/app_tokens.dart';
import 'package:good_manager/util/dimen.dart';

SystemUiOverlayStyle appStatusBarStyle(bool isDark) {
  return SystemUiOverlayStyle(
    statusBarColor:
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
  );
}

/// Builds the app theme for [seed] in [brightness]. All shared component
/// styling (inputs, buttons, dialogs, sheets, chips, cards) lives here so
/// individual widgets do not need to restyle themselves.
ThemeData buildAppTheme(Color seed, Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final base = isDark ? ThemeData.dark() : ThemeData.light();
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);

  final textTheme = base.textTheme.copyWith(
    titleSmall:
        base.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    titleMedium:
        base.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
  );

  final background =
      isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
  final cardColor = isDark ? Colors.black : Colors.white;

  OutlineInputBorder inputBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderSide: BorderSide(color: color, width: width),
        borderRadius: AppRadius.smAll,
      );

  final buttonShape = RoundedRectangleBorder(borderRadius: AppRadius.mdAll);
  const buttonMinSize = Size(64, 48);

  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: background,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: appStatusBarStyle(isDark),
      backgroundColor: background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: scheme.onSurface),
      titleTextStyle: TextStyle(
        fontSize: AppType.bodyLarge,
        fontWeight: FontWeight.w500,
        color: scheme.onSurface,
      ),
    ),
    cardTheme: CardThemeData(color: cardColor),
    inputDecorationTheme: InputDecorationTheme(
      border: inputBorder(scheme.outline),
      enabledBorder: inputBorder(scheme.outline),
      disabledBorder: inputBorder(scheme.outline.withValues(alpha: 0.5)),
      focusedBorder: inputBorder(scheme.primary, width: 2),
      errorBorder: inputBorder(scheme.error),
      focusedErrorBorder: inputBorder(scheme.error, width: 2),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        minimumSize: buttonMinSize,
        shape: buttonShape,
        textStyle: const TextStyle(
            fontSize: AppType.bodyLarge, fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: buttonMinSize,
        shape: buttonShape,
        textStyle: const TextStyle(
            fontSize: AppType.bodyLarge, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.primary,
        side: BorderSide(color: scheme.primary),
        minimumSize: buttonMinSize,
        shape: buttonShape,
        textStyle: const TextStyle(
            fontSize: AppType.bodyLarge, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: buttonShape,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.cardRadius)),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
    ),
  );
}
