import 'report_date_range_type.dart';

/// Result of the date-range bottom sheet on the Report screen.
/// [groupId] / [customerId] null means all.
class ReportRangeSelection {
  final ReportDateRangeType type;
  final int? groupId;
  final int? customerId;

  const ReportRangeSelection(this.type, {this.groupId, this.customerId});
}
