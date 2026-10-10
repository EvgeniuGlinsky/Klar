import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_typography.dart';

abstract final class KlarTheme {
  static const overlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarContrastEnforced: false,
  );

  static ThemeData get dark {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: KlarColors.sage,
      onPrimary: KlarColors.onAccent,
      secondary: KlarColors.birch,
      onSecondary: KlarColors.onAccent,
      tertiary: KlarColors.fjord,
      onTertiary: KlarColors.onAccent,
      error: KlarColors.lingon,
      onError: KlarColors.text,
      surface: KlarColors.surface,
      onSurface: KlarColors.text,
      onSurfaceVariant: KlarColors.textMuted,
      surfaceContainerLowest: KlarColors.background,
      surfaceContainerLow: KlarColors.surface,
      surfaceContainer: KlarColors.surface,
      surfaceContainerHigh: KlarColors.surfaceRaised,
      surfaceContainerHighest: KlarColors.surfaceRaised,
      outline: KlarColors.lineStrong,
      outlineVariant: KlarColors.line,
    );
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(KlarDimens.radius));

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: KlarTypography.family,
      scaffoldBackgroundColor: KlarColors.background,
      canvasColor: KlarColors.background,
      splashFactory: InkSparkle.splashFactory,
      highlightColor: Colors.transparent,
      dividerTheme: const DividerThemeData(color: KlarColors.line, thickness: KlarDimens.hairline, space: 1),
      textTheme: const TextTheme(
        displaySmall: KlarTypography.display,
        titleLarge: KlarTypography.title,
        titleMedium: KlarTypography.body,
        bodyLarge: KlarTypography.body,
        bodyMedium: KlarTypography.body,
        bodySmall: KlarTypography.bodyMuted,
        labelLarge: KlarTypography.button,
        labelMedium: KlarTypography.meta,
        labelSmall: KlarTypography.label,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: KlarColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: overlayStyle,
        titleTextStyle: KlarTypography.title,
        iconTheme: IconThemeData(color: KlarColors.text),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: KlarColors.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: KlarColors.surface,
        showDragHandle: true,
        dragHandleColor: KlarColors.lineStrong,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: KlarColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: shape,
        titleTextStyle: KlarTypography.title,
        contentTextStyle: KlarTypography.bodyMuted,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: KlarColors.surfaceRaised,
        contentTextStyle: KlarTypography.body.copyWith(fontSize: 14),
        actionTextColor: KlarColors.birch,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KlarDimens.radiusSmall)),
        elevation: 0,
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: KlarColors.textFaint),
        isDense: true,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: KlarColors.birch,
        selectionColor: KlarColors.birch.withValues(alpha: 0.3),
        selectionHandleColor: KlarColors.birch,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: KlarColors.birch,
          textStyle: KlarTypography.button,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KlarDimens.radiusSmall)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: KlarColors.sage,
          foregroundColor: KlarColors.onAccent,
          textStyle: KlarTypography.button,
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KlarDimens.radius)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: KlarColors.text,
          textStyle: KlarTypography.button,
          minimumSize: const Size(0, 52),
          side: const BorderSide(color: KlarColors.lineStrong),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KlarDimens.radius)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? KlarColors.onAccent : KlarColors.textMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? KlarColors.sage : KlarColors.surfaceRaised,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: KlarColors.birch,
        inactiveTrackColor: KlarColors.line,
        thumbColor: KlarColors.birch,
        overlayColor: Colors.transparent,
        trackHeight: 2,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: KlarColors.surface,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: KlarColors.surface,
        headerForegroundColor: KlarColors.text,
        shape: shape,
        todayForegroundColor: const WidgetStatePropertyAll(KlarColors.birch),
        todayBorder: const BorderSide(color: KlarColors.birch),
        dayForegroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? KlarColors.onAccent : KlarColors.text,
        ),
        dayBackgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? KlarColors.birch : null,
        ),
        dividerColor: KlarColors.line,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: KlarColors.surface,
        shape: shape,
        dialBackgroundColor: KlarColors.surfaceRaised,
        dialHandColor: KlarColors.birch,
        dialTextColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.selected) ? KlarColors.onAccent : KlarColors.text,
        ),
        hourMinuteColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.selected) ? KlarColors.surfaceRaised : KlarColors.background,
        ),
        hourMinuteTextColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.selected) ? KlarColors.birch : KlarColors.textMuted,
        ),
        entryModeIconColor: KlarColors.textMuted,
      ),
    );
  }
}
