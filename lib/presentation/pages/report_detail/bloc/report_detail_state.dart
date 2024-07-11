part of 'report_detail_cubit.dart';

@freezed
class ReportDetailState with _$ReportDetailState{
  const factory ReportDetailState.initial({
    required BaseState state,
    ReportType? type,
    DateTime? start,
    DateTime? end,
    @Default([]) List<List<String>> data,
    @Default([]) List<int> ids,
  }) = _Initial;
}