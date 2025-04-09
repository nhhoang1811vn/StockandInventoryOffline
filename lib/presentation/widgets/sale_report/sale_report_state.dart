part of 'sale_report_cubit.dart';

@freezed
class SaleReportState with _$SaleReportState {
  const factory SaleReportState.initial({
    //required BaseState state,
    DateTime? startDate,
    @Default(0.0)double maxTotalAmount,
    @Default([]) List<MapEntry<double, double>> data1,
    @Default([]) List<MapEntry<double, double>> data2
  }) = _Initial;
}