part of 'expense_report_chart_cubit.dart';

@freezed
class ExpenseReportChartState with _$ExpenseReportChartState {
  const factory ExpenseReportChartState.initial({
    DateTime? startDate,
    @Default(0.0)double maxTotalAmount,
    @Default([]) List<MapEntry<double, double>> data
  }) = _Initial;
}