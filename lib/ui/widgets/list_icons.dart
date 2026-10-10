import 'package:flutter/widgets.dart';
import 'package:klar/ui/theme/klar_icons.dart';

/// Icons a list can have, by key, in picker order.
abstract final class ListIcons {
  static const all = <String, IconData>{
    'tray': KlarIcons.tray,
    'briefcase': KlarIcons.briefcase,
    'house': KlarIcons.house,
    'heart': KlarIcons.heart,
    'cart': KlarIcons.shoppingCart,
    'book': KlarIcons.book,
    'leaf': KlarIcons.leaf,
    'barbell': KlarIcons.barbell,
    'coffee': KlarIcons.coffee,
    'airplane': KlarIcons.airplane,
    'paw': KlarIcons.pawPrint,
    'cap': KlarIcons.graduationCap,
    'mountains': KlarIcons.mountains,
    'snowflake': KlarIcons.snowflake,
    'moon': KlarIcons.moon,
    'plant': KlarIcons.plant,
  };

  static IconData of(String key) => all[key] ?? KlarIcons.listBullets;
}
