import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/domain/usecases/payment/payment_usercases.dart';
import 'package:injectable/injectable.dart';

part 'sale_report_cubit.freezed.dart';
part 'sale_report_state.dart';

@injectable
class SaleReportCubit extends Cubit<SaleReportState> {
  final PaymentUseCases useCase;

  SaleReportCubit({required this.useCase}) : super(SaleReportState.initial());

  void initState() async {
    List<MapEntry<double, double>> data1 = [];
    List<MapEntry<double, double>> data2 = [];
    DateTime currentDate = DateTime.now();

    double maxTotalAmount = 0.0; // Variable to hold the max total amount
    List<double> totalIncomingAmounts = []; // To store the total amounts for each month
    List<double> totalOutgoingAmounts = [];

    for (int i = 0; i < 6; i++) {
      DateTime startDate = DateTime(currentDate.year, currentDate.month - 5 + i, 1); // First day of the month
      DateTime endDate =
          DateTime(currentDate.year, currentDate.month - 5 + i, 1).add(Duration(days: 32)); // First day of next month
      endDate = DateTime(endDate.year, endDate.month, 1).subtract(Duration(days: 1)); // Last day of the current month

      var payments = await useCase.getInRange(startDate, endDate);
      var inboundPayments = payments.where((item) => item.type == PaymentType.inbound).toList();
      var outboundPayments = payments.where((item) => item.type == PaymentType.outbound).toList();

      double totalIncomingAmount = 0.0;
      for (Payment payment in inboundPayments) {
        totalIncomingAmount += payment.amount ?? 0.0;
      }
      double totalOutgoingAmount = 0.0;
      for (Payment payment in outboundPayments) {
        totalOutgoingAmount += payment.amount ?? 0.0;
      }
      totalIncomingAmounts.add(totalIncomingAmount);
      totalOutgoingAmounts.add(totalOutgoingAmount);

      if (totalIncomingAmount > maxTotalAmount) {
        maxTotalAmount = totalIncomingAmount;
      }
      if (totalOutgoingAmount > maxTotalAmount) {
        maxTotalAmount = totalOutgoingAmount;
      }
    }
    if (maxTotalAmount > 0) {
      for (int i = 0; i < 6; i++) {
        double normalizedValue1 = totalIncomingAmounts[i] * 5 / maxTotalAmount;
        double normalizedValue2 = totalOutgoingAmounts[i] * 5 / maxTotalAmount;
        data1.add(MapEntry(i.toDouble(), normalizedValue1));
        data2.add(MapEntry(i.toDouble(), normalizedValue2));
      }
      emit(state.copyWith(
        startDate: DateTime(currentDate.year, currentDate.month - 5, 1),
        maxTotalAmount: maxTotalAmount,
        data1: data1,
        data2: data2,
      ));
    } else {
      for (int i = 0; i < 6; i++) {
        double normalizedValue1 = 0.0;
        double normalizedValue2 = 0.0;
        data1.add(MapEntry(i.toDouble(), normalizedValue1));
        data2.add(MapEntry(i.toDouble(), normalizedValue2));
      }
      if (!isClosed){
        emit(state.copyWith(
          startDate: DateTime(currentDate.year, currentDate.month - 5, 1),
          maxTotalAmount: maxTotalAmount,
          data1: data1,
          data2: data2,
        ));
      }
    }
  }
}
