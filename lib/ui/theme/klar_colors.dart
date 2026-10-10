import 'package:flutter/material.dart';

/// Dark Scandinavian palette: warm charcoal, stone and muted natural accents.
abstract final class KlarColors {
  static const background = Color(0xFF121314);
  static const surface = Color(0xFF1B1D1F);
  static const surfaceRaised = Color(0xFF232629);
  static const line = Color(0xFF2E3236);
  static const lineStrong = Color(0xFF3C4146);

  static const text = Color(0xFFECE8E1);
  static const textMuted = Color(0xFF9A9893);
  static const textFaint = Color(0xFF65645F);

  static const sage = Color(0xFF8FA89B);
  static const fjord = Color(0xFF7C93A8);
  static const clay = Color(0xFFC48A6A);
  static const birch = Color(0xFFD9CBB3);
  static const lingon = Color(0xFFB5636A);
  static const moss = Color(0xFF8E9A6B);
  static const heather = Color(0xFF9C8AA5);
  static const stone = Color(0xFF8A8F94);

  static const onAccent = Color(0xFF121314);

  /// List colors by key, in picker order.
  static const lists = {
    'birch': birch,
    'sage': sage,
    'fjord': fjord,
    'clay': clay,
    'lingon': lingon,
    'moss': moss,
    'heather': heather,
    'stone': stone,
  };

  static Color list(String key) => lists[key] ?? birch;
}
