import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'app_theme.g.dart';

@HiveType(typeId: 6)
enum AppTheme {
  @HiveField(4) orange,
  @HiveField(1) blue,
  @HiveField(2) green,

  @HiveField(0) indigo,


  @HiveField(5) violet,
  @HiveField(6) red,
  @HiveField(7) pink,

  @HiveField(8) teal,
  @HiveField(9) cyan,
  @HiveField(10) lime,
  @HiveField(11) amber,
  @HiveField(3) dark,
  @HiveField(12) system_default,
}
extension AppThemeExtension on AppTheme{
  String get label {
    switch (this) {
      case AppTheme.system_default: return "System Default (auto)";
      case AppTheme.dark: return "Dark";
      case AppTheme.blue: return "Blue";
      case AppTheme.green: return "Green";
      case AppTheme.orange: return "Orange";
      case AppTheme.violet: return "Violet";
      case AppTheme.red: return "Red";
      case AppTheme.pink: return "Pink";
      case AppTheme.indigo: return "Indigo";
      case AppTheme.teal: return "Teal";
      case AppTheme.cyan: return "Cyan";
      case AppTheme.lime: return "Lime";
      case AppTheme.amber: return "Amber";
    }
  }
  bool get isLocked {
    switch (this) {
      //case AppTheme.system_default:
      case AppTheme.blue:
      case AppTheme.green:
      case AppTheme.orange:
        return false;
      default:
        return true;
    }
  }

  Color get color {
    switch (this) {
      // case AppTheme.system_default:
      //   return Colors.grey; // fallback
      // case AppTheme.dark:
      //   return Colors.black;
      case AppTheme.blue:
        return Colors.blue;
      case AppTheme.green:
        return Colors.green;
      case AppTheme.orange:
        return Colors.orange;
      case AppTheme.violet:
        return Colors.deepPurple;
      case AppTheme.red:
        return Colors.red;
      case AppTheme.pink:
        return Colors.pink;
      case AppTheme.indigo:
        return Colors.indigo;
      case AppTheme.teal:
        return Colors.teal;
      case AppTheme.cyan:
        return Colors.cyan;
      case AppTheme.lime:
        return Colors.lime;
      case AppTheme.amber:
        return Colors.amber;
      default:
        return Colors.blue;
    }
  }
  ThemeMode get mode{
    switch(this){
      case AppTheme.system_default: return ThemeMode.system;
      case AppTheme.dark: return ThemeMode.dark;
      default: return ThemeMode.light;
    }
  }
}