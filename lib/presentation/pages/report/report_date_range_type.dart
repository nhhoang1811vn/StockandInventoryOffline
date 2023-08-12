import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ReportDateRangeType{
  CURRENT_MONTH,
  LAST_30_DAYS,
  LAST_90_DAYS,
  CURRENT_YEAR
}
extension ReportDateRangeTypeExtension on ReportDateRangeType{
  String getText(BuildContext context){
    switch(this){
      case ReportDateRangeType.CURRENT_MONTH:
        return AppLocalizations.of(context)!.report_type_current_month;
      case ReportDateRangeType.LAST_30_DAYS:
        return AppLocalizations.of(context)!.report_type_last_30_days;
      case ReportDateRangeType.LAST_90_DAYS:
        return AppLocalizations.of(context)!.report_type_last_90_days;
      case ReportDateRangeType.CURRENT_YEAR:
        return AppLocalizations.of(context)!.report_type_current_year;
    }
  }
}