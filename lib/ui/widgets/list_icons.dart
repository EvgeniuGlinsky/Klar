import 'package:flutter/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Icons a list can have, by key, in picker order.
abstract final class ListIcons {
  static const all = <String, IconData>{
    'tray': PhosphorIconsLight.tray,
    'briefcase': PhosphorIconsLight.briefcase,
    'house': PhosphorIconsLight.house,
    'heart': PhosphorIconsLight.heart,
    'cart': PhosphorIconsLight.shoppingCart,
    'book': PhosphorIconsLight.book,
    'leaf': PhosphorIconsLight.leaf,
    'barbell': PhosphorIconsLight.barbell,
    'coffee': PhosphorIconsLight.coffee,
    'airplane': PhosphorIconsLight.airplane,
    'paw': PhosphorIconsLight.pawPrint,
    'cap': PhosphorIconsLight.graduationCap,
    'mountains': PhosphorIconsLight.mountains,
    'snowflake': PhosphorIconsLight.snowflake,
    'moon': PhosphorIconsLight.moon,
    'plant': PhosphorIconsLight.plant,
  };

  static IconData of(String key) => all[key] ?? PhosphorIconsLight.listBullets;
}
