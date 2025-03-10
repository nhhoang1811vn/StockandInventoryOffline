import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/documents/document_usecases.dart';
import '../../pages/base/base_state.dart';

part 'sale_report_cubit.freezed.dart';
part 'sale_report_state.dart';

@injectable
class SaleReportCubit extends Cubit<SaleReportState> {

  final DocumentUseCases useCase;
  SaleReportCubit({required this.useCase}) : super(SaleReportState.initial(data: []));

  void initState() async{
    List<MapEntry<double, double>> data = [];
    DateTime currentDate = DateTime.now();

    double maxTotalAmount = 0.0; // Variable to hold the max total amount
    List<double> totalAmounts = []; // To store the total amounts for each month


    for (int i = 0; i<=5;i++){
      DateTime startDate = DateTime(currentDate.year, currentDate.month - 5 + i, 1); // First day of the month
      DateTime endDate = DateTime(currentDate.year, currentDate.month - 5 + i, 1).add(Duration(days: 32)); // First day of next month
      endDate = DateTime(endDate.year, endDate.month, 1).subtract(Duration(days: 1)); // Last day of the current month

      var documents = await useCase.getInRange(startDate, endDate);
      documents = documents.where((item) => item.type == DocumentType.outgoing).toList();
      double totalAmount = 0.0;
      for (Document document in documents){
        totalAmount += document.amount;
      }

      totalAmounts.add(totalAmount);
      if (totalAmount > maxTotalAmount) {
        maxTotalAmount = totalAmount;
      }
    }
    for (int i = 0; i <= 5; i++) {
      double normalizedValue = totalAmounts[i] * 4 / maxTotalAmount;
      data.add(MapEntry(i.toDouble(), normalizedValue));
    }
    emit(state.copyWith(
        startDate: DateTime(currentDate.year, currentDate.month - 5, 1),
        maxTotalAmount: maxTotalAmount,
        data: data,
    ));
  }
}