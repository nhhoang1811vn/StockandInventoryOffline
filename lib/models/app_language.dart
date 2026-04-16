import 'dart:ui';

import 'package:hive/hive.dart';

part 'app_language.g.dart';

@HiveType(typeId: 10)
enum AppLanguage {
  @HiveField(0) english,
  @HiveField(1) spanish,
  @HiveField(2) french,
  @HiveField(3) german,
  @HiveField(4) chinese,
  @HiveField(5) arabic,
  @HiveField(6) hindi,
  @HiveField(7) portuguese,
  @HiveField(8) russian,
  @HiveField(9) japanese,
  @HiveField(10) vietnamese
}

extension AppLanguageExtension on AppLanguage {
  String get label {
    switch (this) {
      case AppLanguage.english:
        return "English";
      case AppLanguage.spanish:
        return "Español";
      case AppLanguage.french:
        return "Français";
      case AppLanguage.german:
        return "Deutsch";
      case AppLanguage.chinese:
        return "中文";
      case AppLanguage.arabic:
        return "العربية";
      case AppLanguage.hindi:
        return "हिन्दी";
      case AppLanguage.portuguese:
        return "Português";
      case AppLanguage.russian:
        return "Русский";
      case AppLanguage.japanese:
        return "日本語";
      case AppLanguage.vietnamese:
        return "Tiếng Việt";
    }
  }

  Locale get locale {
    switch (this) {
      case AppLanguage.english:
        return const Locale("en", "US");
      case AppLanguage.spanish:
        return const Locale("es", "ES");
      case AppLanguage.french:
        return const Locale("fr", "FR");
      case AppLanguage.german:
        return const Locale("de", "DE");
      case AppLanguage.chinese:
        return const Locale("zh", "CN");
      case AppLanguage.arabic:
        return const Locale("ar", "SA");
      case AppLanguage.hindi:
        return const Locale("hi", "IN");
      case AppLanguage.portuguese:
        return const Locale("pt", "BR");
      case AppLanguage.russian:
        return const Locale("ru", "RU");
      case AppLanguage.japanese:
        return const Locale("ja", "JP");
      case AppLanguage.vietnamese:
        return const Locale("vi", "VN");
    }
  }
}
