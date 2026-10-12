import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/models/app_language.dart';
import 'package:good_manager/presentation/markdown/md_bundle.dart';
import 'package:good_manager/presentation/markdown/md_provider.dart';
import 'package:good_manager/presentation/markdown/md_provider_ipm_en.dart';
import 'package:good_manager/presentation/markdown/md_provider_ipm_vn.dart';
import 'package:good_manager/presentation/markdown/md_resource_ar.dart';
import 'package:good_manager/presentation/markdown/md_resource_de.dart';
import 'package:good_manager/presentation/markdown/md_resource_es.dart';
import 'package:good_manager/presentation/markdown/md_resource_fr.dart';
import 'package:good_manager/presentation/markdown/md_resource_hi.dart';
import 'package:good_manager/presentation/markdown/md_resource_ja.dart';
import 'package:good_manager/presentation/markdown/md_resource_pt.dart';
import 'package:good_manager/presentation/markdown/md_resource_ru.dart';
import 'package:good_manager/presentation/markdown/md_resource_zh.dart';

class MDProviderFactory {
  static MDProvider get() {
    switch (AppSettings.appLanguage) {
      case AppLanguage.vietnamese:
        return MDProviderIpmVN();
      case AppLanguage.spanish:
        return MDProviderFromBundle(MarkdownResourceES.bundle);
      case AppLanguage.french:
        return MDProviderFromBundle(MarkdownResourceFR.bundle);
      case AppLanguage.german:
        return MDProviderFromBundle(MarkdownResourceDE.bundle);
      case AppLanguage.chinese:
        return MDProviderFromBundle(MarkdownResourceZH.bundle);
      case AppLanguage.arabic:
        return MDProviderFromBundle(MarkdownResourceAR.bundle);
      case AppLanguage.hindi:
        return MDProviderFromBundle(MarkdownResourceHI.bundle);
      case AppLanguage.portuguese:
        return MDProviderFromBundle(MarkdownResourcePT.bundle);
      case AppLanguage.russian:
        return MDProviderFromBundle(MarkdownResourceRU.bundle);
      case AppLanguage.japanese:
        return MDProviderFromBundle(MarkdownResourceJA.bundle);
      case AppLanguage.english:
        return MDProviderIpmEN();
    }
  }
}
