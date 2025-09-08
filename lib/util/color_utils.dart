import 'package:flutter/material.dart';

class ColorUtils {
  ColorUtils._();
  static Color getItemBgColor1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade900
          : Colors.white;

  static Color getItemBgColor2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.blueGrey.shade800
          : Colors.blue.shade50;

  static Color getHeaderBgColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.blueGrey.shade900
          : Colors.blue.shade100;
}
