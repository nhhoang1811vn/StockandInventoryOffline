part of 'report_detail_cubit.dart';

@freezed
class ReportDetailState with _$ReportDetailState{
  const factory ReportDetailState.initial({
    required BaseState state,
    ReportType? type,
    DateTime? start,
    DateTime? end,
    @Default([]) List<List<String>> data,
    //@Default([]) List<int> ids,
    @Default([]) List<Good> goods,
    @Default([]) List<Document> documents,
    @Default([]) List<Supplier> suppliers,
    @Default([]) List<Customer> customers,
    @Default([]) List<ColumnReport> columns,
    @Default([]) List<List<String>> rows,
    @Default([]) List<Payment> payments,
  }) = _Initial;
}