part of 'report_detail_cubit.dart';

@freezed
class ReportDetailState with _$ReportDetailState{
  const factory ReportDetailState.initial({
    required BaseState state,
    ReportType? type,
    DateTime? start,
    DateTime? end,
  int? groupId,
  String? groupName,
    @Default([]) List<List<String>> data,
    @Default([]) List<int> ids,
    @Default([]) List<Document> documents,
    @Default([]) List<ColumnReport> columns,
    @Default([]) List<List<String>> rows,
    @Default([]) List<Payment> payments,
  }) = _Initial;
}