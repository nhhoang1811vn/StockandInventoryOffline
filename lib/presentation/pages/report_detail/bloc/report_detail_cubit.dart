import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/entities/report_type.dart';
import 'package:good_manager/domain/usecases/expenses/expense_usercases.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/storage.dart';
import '../../../../domain/entities/document.dart';
import '../../../../domain/usecases/documents/document_usecases.dart';
import '../../base/base_state.dart';

part 'report_detail_cubit.freezed.dart';
part 'report_detail_state.dart';

@injectable
class ReportDetailCubit extends Cubit<ReportDetailState> {
  final Storage storage;
  final ExpenseUseCases expenseUseCase;
  final DocumentUseCases documentUseCases;
  ReportDetailCubit({
    required this.storage,
    required this.expenseUseCase,
    required this.documentUseCases
  }) : super(ReportDetailState.initial(state: InitialState()));

  void init(BuildContext context, ReportType type, DateTime start, DateTime end){
    emit(state.copyWith(type: type, start: start, end: end));
    load(context);
  }
  void load(BuildContext context) async{
    List<List<dynamic>> data = [];
    switch(state.type){
      case ReportType.EXPENSES:
        List<Expense> items = await expenseUseCase.getExpensesInRange(state.start!, state.end!);
        data.add([AppLocalizations.of(context)!.field_date, AppLocalizations.of(context)!.field_name, AppLocalizations.of(context)!.field_amount]);
        double total = 0;
        for (Expense item in items){
          List<dynamic> row = [];
          row.add(Config.dateFormat.format(item.date));
          row.add(item.name);
          row.add(item.amount);
          data.add(row);

          total += item.amount;
        }
        if (items.isNotEmpty){
          List<dynamic> totalRow = [];
          totalRow.add(AppLocalizations.of(context)!.field_total);
          totalRow.add("");
          totalRow.add(total);
          data.add(totalRow);
        }
        break;
      case ReportType.LIST_OF_DOCUMENT:
        List<Document> items = await documentUseCases.getInRange(state.start!, state.end!);
        data.add([AppLocalizations.of(context)!.field_date, AppLocalizations.of(context)!.field_name, AppLocalizations.of(context)!.field_document_type, AppLocalizations.of(context)!.field_person_name, AppLocalizations.of(context)!.field_quantity]);
        double total = 0;
        for (Document item in items){
          List<dynamic> row = [];
          row.add(Config.dateFormat.format(item.date));
          row.add(item.name);
          row.add(item.type.getTitle(context));
          row.add(item.personName ?? '');
          row.add(item.quantity);
          data.add(row);

          total += item.quantity;
        }
        if (items.isNotEmpty){
          List<dynamic> totalRow = [];
          totalRow.add(AppLocalizations.of(context)!.field_total);
          totalRow.add("");
          totalRow.add("");
          totalRow.add("");
          totalRow.add(total);
          data.add(totalRow);
        }
        break;
      default:
    }
    emit(state.copyWith(data: data));
  }

  onExportExcelFileMenuClicked() {
    showInfoToast("export file (under development)");
  }
}
