import 'report_date_range_type.dart';

/// Result of the date-range bottom sheet on the Report screen.
/// [groupId] null means all groups.
class ReportRangeSelection {
  final ReportDateRangeType type;
  final int? groupId;

  const ReportRangeSelection(this.type, this.groupId);
}
