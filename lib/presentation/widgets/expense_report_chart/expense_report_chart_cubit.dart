import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/usecases/expenses/expense_usercases.dart';
import 'package:injectable/injectable.dart';

part 'expense_report_chart_cubit.freezed.dart';
part 'expense_report_chart_state.dart';

@injectable
class ExpenseReportChartCubit extends Cubit<ExpenseReportChartState> {

  final ExpenseUseCases useCase;
  ExpenseReportChartCubit({required this.useCase}) : super(ExpenseReportChartState.initial(data: []));

  void initState() async{
    List<MapEntry<double, double>> data = [];
    DateTime currentDate = DateTime.now();

    double maxTotalAmount = 0.0; // Variable to hold the max total amount
    List<double> totalAmounts = []; // To store the total amounts for each month


    for (int i = 0; i<=5;i++){
      DateTime startDate = DateTime(currentDate.year, currentDate.month - 5 + i, 1); // First day of the month
      DateTime endDate = DateTime(currentDate.year, currentDate.month - 5 + i, 1).add(Duration(days: 32)); // First day of next month
      endDate = DateTime(endDate.year, endDate.month, 1).subtract(Duration(days: 1)); // Last day of the current month
      print("startDate ${startDate}");
      print("endDate ${endDate}");
      var expenses = await useCase.getExpensesInRange(startDate, endDate);
      double totalAmount = 0.0;
      for (Expense expense in expenses){
        if (expense.amount!=null){
          totalAmount += expense.amount!;
        }
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