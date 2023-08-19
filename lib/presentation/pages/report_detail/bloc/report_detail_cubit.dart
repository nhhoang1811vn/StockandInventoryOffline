import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/entities/report_type.dart';
import 'package:good_manager/domain/usecases/expenses/expense_usercases.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
    List<List<String>> data = [];
    switch(state.type){
      case ReportType.EXPENSES:
        List<Expense> items = await expenseUseCase.getExpensesInRange(state.start!, state.end!);
        data.add([AppLocalizations.of(context)!.field_date, AppLocalizations.of(context)!.field_name, AppLocalizations.of(context)!.field_amount]);
        double total = 0;
        for (Expense item in items){
          List<String> row = [];
          row.add(Config.dateFormat.format(item.date));
          row.add(item.name);
          row.add(Config.currencyFormat.format(item.amount));
          data.add(row);

          total += item.amount;
        }
        if (items.isNotEmpty){
          List<String> totalRow = [];
          totalRow.add(AppLocalizations.of(context)!.field_total);
          totalRow.add("");
          totalRow.add(Config.currencyFormat.format(total));
          data.add(totalRow);
        }
        break;
      case ReportType.LIST_OF_DOCUMENT:
        List<Document> items = await documentUseCases.getInRange(state.start!, state.end!);
        data.add([AppLocalizations.of(context)!.field_date, AppLocalizations.of(context)!.field_name, AppLocalizations.of(context)!.field_document_type, AppLocalizations.of(context)!.field_person_name, AppLocalizations.of(context)!.field_quantity, AppLocalizations.of(context)!.field_amount]);
        double quantityTotal = 0;
        double amountTotal = 0.0;
        for (Document item in items){
          List<String> row = [];
          row.add(Config.dateFormat.format(item.date));
          row.add(item.name);
          row.add(item.type.getTitle(context));
          row.add(item.personName ?? '');
          row.add(item.quantity.toString());
          row.add(Config.currencyFormat.format(item.amount));
          data.add(row);

          quantityTotal += item.quantity;
          amountTotal += item.amount;
        }
        if (items.isNotEmpty){
          List<String> totalRow = [];
          totalRow.add(AppLocalizations.of(context)!.field_total);
          totalRow.add("");
          totalRow.add("");
          totalRow.add("");
          totalRow.add(quantityTotal.toString());
          totalRow.add(Config.currencyFormat.format(amountTotal));
          data.add(totalRow);
        }
        break;
      default:
    }
    emit(state.copyWith(data: data));
  }
  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }
  onExportExcelFileMenuClicked() async{
    //runtime permission
    Map<Permission, PermissionStatus> status = await [Permission.storage].request();
    //convert data to csv
    String csv = const ListToCsvConverter().convert(state.data);
    //convert csv to file
    String? downloadDir = await getDownloadPath();
    String extension = ".csv";
    DateTime _now = DateTime.now();
    String timestamp = "${_now.hour}_${_now.minute}_${_now.second}";
    String filePath = downloadDir! + "/export_" + timestamp + extension;
    File f = File(filePath);
    await f.writeAsString(csv);
    print(filePath);
    showInfoToast(filePath);
    //OpenFile.open(filePath);
  }
}
