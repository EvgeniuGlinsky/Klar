import 'package:flutter/material.dart';
import 'package:klar/ui/theme/klar_colors.dart';

abstract final class KlarTypography {
  static const family = 'Manrope';

  static const display = TextStyle(
    fontFamily: family,
    fontSize: 34,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.6,
    height: 1.15,
    color: KlarColors.text,
  );

  static const title = TextStyle(
    fontFamily: family,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
    height: 1.25,
    color: KlarColors.text,
  );

  static const body = TextStyle(
    fontFamily: family,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: KlarColors.text,
  );

  static const bodyMuted = TextStyle(
    fontFamily: family,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: KlarColors.textMuted,
  );

  static const meta = TextStyle(
    fontFamily: family,
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: KlarColors.textMuted,
  );

  /// Small caps-like section labels.
  static const label = TextStyle(
    fontFamily: family,
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.4,
    height: 1.2,
    color: KlarColors.textFaint,
  );

  static const button = TextStyle(
    fontFamily: family,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
}
