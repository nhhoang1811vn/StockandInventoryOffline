import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

enum ReportDateRangeType {
  CURRENT_MONTH,
  LAST_30_DAYS,
  LAST_90_DAYS,
  CURRENT_YEAR,
  CUSTOM
}

extension ReportDateRangeTypeExtension on ReportDateRangeType {
  String getText(BuildContext context) {
    switch (this) {
      case ReportDateRangeType.CURRENT_MONTH:
        return context.tr("report_type_current_month");
      case ReportDateRangeType.LAST_30_DAYS:
        return context.tr("report_type_last_30_days");
      case ReportDateRangeType.LAST_90_DAYS:
        return context.tr("report_type_last_90_days");
      case ReportDateRangeType.CURRENT_YEAR:
        return context.tr("report_type_current_year");
      case ReportDateRangeType.CUSTOM:
        return context.tr("report_type_custom");
    }
  }
}
