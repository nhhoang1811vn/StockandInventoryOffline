import 'report_date_range_type.dart';

/// Result of the date-range bottom sheet on the Report screen.
/// [groupId] / [customerId] / [supplierId] null means all.
class ReportRangeSelection {
  final ReportDateRangeType type;
  final int? groupId;
  final int? customerId;
  final int? supplierId;

  const ReportRangeSelection(
    this.type, {
    this.groupId,
    this.customerId,
    this.supplierId,
  });
}
