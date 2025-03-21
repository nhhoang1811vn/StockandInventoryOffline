import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/payment_status.dart';
import 'package:good_manager/domain/entities/report_type.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/repositories/document_transaction_repositories.dart';
import 'package:good_manager/domain/usecases/customers/customers_usecases.dart';
import 'package:good_manager/domain/usecases/expenses/expense_usercases.dart';
import 'package:good_manager/domain/usecases/suppliers/suppliers_usecases.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../data/storage.dart';
import '../../../../domain/entities/document.dart';
import '../../../../domain/usecases/documents/document_usecases.dart';
import '../../../../domain/usecases/goods/goods_usercases.dart';
import '../../base/base_state.dart';

part 'report_detail_cubit.freezed.dart';
part 'report_detail_state.dart';

@injectable
class ReportDetailCubit extends Cubit<ReportDetailState> {
  final Storage storage;
  final GoodsUseCases goodsUseCase;
  final ExpenseUseCases expenseUseCase;
  final DocumentUseCases documentUseCases;
  final DocumentTransactionRepository documentTransactionRepository;
  final SuppliersUseCase suppliersUseCase;
  final CustomersUseCase customersUseCase;
  ReportDetailCubit({
    required this.storage,
    required this.goodsUseCase,
    required this.expenseUseCase,
    required this.documentUseCases,
    required this.documentTransactionRepository,
    required this.suppliersUseCase,
    required this.customersUseCase
  }) : super(ReportDetailState.initial(state: InitialState()));

  void init(
      BuildContext context,
      ReportType type,
      DateTime start,
      DateTime end,
      int? groupId,
      String? groupName
      ){
    emit(state.copyWith(state: LoadingState(),type: type, start: start, end: end, groupId: groupId, groupName: groupName));
    load(context);
  }
  Future<double> getQuantity(int goodId, List<Document> documents) async{
    double incoming = 0.0;
    double outgoing = 0.0;
    for (Document document in documents){
      incoming += await documentTransactionRepository.getSumQuantityByGoodIdAndByDocumentId(DocumentType.incoming, goodId, document.id!);
      outgoing += await documentTransactionRepository.getSumQuantityByGoodIdAndByDocumentId(DocumentType.outgoing, goodId, document.id!);
    }
    return incoming - outgoing;
  }
  DateTime getPreviousHour(DateTime date){
    return DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch - 60*60*1000);//- 60 mins
  }
  void load(BuildContext context) async{
    List<List<String>> data = [];
    switch(state.type){
      case ReportType.LIST_OF_GOODS:
        data.add([
          AppLocalizations.of(context)!.field_bar_code,
          AppLocalizations.of(context)!.field_name,
          "Ban đầu (SL)",
          "Nhập vào (SL)",
          "Bán ra (SL)",
          "Cuối Kỳ (SL)"]);
        int storeId = storage.getSelectedStoreId();
        List<Good> allGoods = await goodsUseCase.getAllByStoreId(storeId);
        List<Good> goods = allGoods.where((good) => (state.groupId == null || state.groupId == good.groupId)).toList();

        List<Document> documentsPrePeriod = await documentUseCases.getInRange(DateTime.fromMillisecondsSinceEpoch(0), getPreviousHour(state.start!));
        List<Document> documentsInPeriod = await documentUseCases.getInRange(state.start!, state.end!);
        double totalStartPeriodStock = 0.0;
        double totalIncoming = 0.0;
        double totalOutgoing = 0.0;
        double totalEndPeriodStock = 0.0;
        for (Good good in goods){
          double incoming = 0.0;
          double outgoing = 0.0;
          for (Document document in documentsInPeriod){
            incoming += await documentTransactionRepository.getSumQuantityByGoodIdAndByDocumentId(DocumentType.incoming, good.id!, document.id!);
            outgoing += await documentTransactionRepository.getSumQuantityByGoodIdAndByDocumentId(DocumentType.outgoing, good.id!, document.id!);
          }
          double startPeriodStock = await getQuantity(good.id!, documentsPrePeriod);
          double endPeriodStock = startPeriodStock + incoming - outgoing;
          List<String> row = [];
          row.add(good.barCode ?? "");
          row.add(good.name);
          row.add(startPeriodStock.toString());
          row.add(incoming.toString());
          row.add(outgoing.toString());
          row.add(endPeriodStock.toString());
          if (startPeriodStock == 0.0 && incoming == 0.0 && outgoing == 0.0){

          }else{
            data.add(row);
            totalStartPeriodStock += startPeriodStock;
            totalIncoming += incoming;
            totalOutgoing += outgoing;
            totalEndPeriodStock += endPeriodStock;
          }
        }
        if (data.length > 1){
          //add total row
          data.add([AppLocalizations.of(context)!.field_total, "", totalStartPeriodStock.toString(), totalIncoming.toString(), totalOutgoing.toString(), totalEndPeriodStock.toString()]);
        }
        emit(state.copyWith(ids: goods.map((e) => e.id!).toList()));
        break;
      case ReportType.EXPENSES:
        List<Expense> items = await expenseUseCase.getExpensesInRange(state.start!, state.end!);
        data.add([AppLocalizations.of(context)!.field_date, AppLocalizations.of(context)!.field_name, AppLocalizations.of(context)!.field_amount]);
        double total = 0;
        for (Expense item in items){
          List<String> row = [];
          row.add(DateFormatFactory.getDateFormat().format(item.date));
          row.add(item.name);
          row.add(Config.currencyFormat.format(item.amount));
          data.add(row);

          total += item.amount??0;
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
        data.add([
          AppLocalizations.of(context)!.field_date,
          AppLocalizations.of(context)!.field_name,
          AppLocalizations.of(context)!.field_document_type,
          AppLocalizations.of(context)!.field_person_name,
          AppLocalizations.of(context)!.field_quantity,
          //AppLocalizations.of(context)!.field_cost,
          //AppLocalizations.of(context)!.field_revenue
          AppLocalizations.of(context)!.field_amount

        ]);
        double quantityTotal = 0;
        //double costTotal = 0.0;
        //double revenueTotal = 0.0;
        double amountTotal = 0.0;
        for (Document item in items){
          List<String> row = [];
          row.add(DateFormatFactory.getDateFormat().format(item.date));
          row.add(item.name);
          row.add(item.type.getTitle(context));
          row.add(item.personName ?? '');
          row.add(item.quantity.toString());
          /*if (item.type == DocumentType.incoming){
            row.add(Config.currencyFormat.format(item.amount));
            row.add("");
            costTotal += item.amount;
          }else{
            row.add("");
            row.add(Config.currencyFormat.format(item.amount));
            revenueTotal += item.amount;
          }*/
          row.add(Config.currencyFormat.format(item.amount));

          data.add(row);
          amountTotal += item.amount;
          quantityTotal += item.quantity;
        }
        if (items.isNotEmpty){
          List<String> totalRow = [];
          totalRow.add(AppLocalizations.of(context)!.field_total);
          totalRow.add("");
          totalRow.add("");
          totalRow.add("");
          totalRow.add(quantityTotal.toString());
          //totalRow.add(Config.currencyFormat.format(costTotal));
          //totalRow.add(Config.currencyFormat.format(revenueTotal));
          totalRow.add(Config.currencyFormat.format(amountTotal));
          data.add(totalRow);
        }
        emit(state.copyWith(documents: items));
        break;
      case ReportType.DEBTS_BY_SUPPLIER:
        data = await getDataDebtBySupplier(context);
        break;
      case ReportType.DEBTS_BY_CUSTOMER:
        data = await getDataDebtByCustomer(context);
        break;
      default:
        break;
    }
    emit(state.copyWith(state: LoadSuccessState(), data: data));
  }
  Future<List<List<String>>> getDataDebtBySupplier(BuildContext context) async{
    List<Document> pressDocuments = [];
    List<List<String>> rows = [];
    //header
    rows.add([
      AppLocalizations.of(context)!.field_supplier,
      AppLocalizations.of(context)!.field_document_no,
      AppLocalizations.of(context)!.field_date,
      AppLocalizations.of(context)!.field_amount,
      AppLocalizations.of(context)!.field_paid,
      AppLocalizations.of(context)!.field_remaining,
    ]);
    double totalAmount = 0.0;
    double totalPaid = 0.0;
    double totalRemain = 0.0;
    int storeId = storage.getSelectedStoreId();
    List<Supplier> suppliers = await suppliersUseCase.getAllByStoreId(storeId);
    List<Document> allDocuments = await documentUseCases.getInRange(state.start!, state.end!);
    List<Document> incomingDocuments = allDocuments.where((item) => item.type == DocumentType.incoming).toList();
    for (Supplier supplier in suppliers){
      List<Document> documents = incomingDocuments.where((item) => item.personId == supplier.id).toList();
      pressDocuments.addAll(documents);
      for (Document document in documents){
        String supplierName = supplier.name;
        String documentName = document.name;
        String documentDate = DateFormatFactory.getDateFormat().format(document.date);
        String amount = Config.currencyFormat.format(document.amount);
        String paid = Config.currencyFormat.format(document.paid);
        String remain = Config.currencyFormat.format(document.amount - document.paid);
        rows.add([supplierName, documentName, documentDate, amount, paid, remain]);
        totalAmount += document.amount;
        totalPaid += document.paid;
        totalRemain += (document.amount - document.paid);
      }
    }
    rows.add([AppLocalizations.of(context)!.field_total, "", "", getDoubleText(totalAmount), getDoubleText(totalPaid), getDoubleText(totalRemain)]);
    emit(state.copyWith(documents: pressDocuments));
    return rows;
  }


  Future<List<List<String>>> getDataDebtByCustomer(BuildContext context) async{
    List<List<String>> rows = [];
    List<Document> pressDocuments = [];
    //header
    rows.add([
      AppLocalizations.of(context)!.field_customer,
      AppLocalizations.of(context)!.field_document_no,
      AppLocalizations.of(context)!.field_date,
      AppLocalizations.of(context)!.field_amount,
      AppLocalizations.of(context)!.field_paid,
      AppLocalizations.of(context)!.field_remaining,
    ]);
    double totalAmount = 0.0;
    double totalPaid = 0.0;
    double totalRemain = 0.0;

    int storeId = storage.getSelectedStoreId();
    List<Customer> customers = await customersUseCase.getAllByStoreId(storeId);
    List<Document> allDocuments = await documentUseCases.getInRange(state.start!, state.end!);
    List<Document> outgoingDocuments = allDocuments.where((item) => item.type == DocumentType.outgoing).toList();
    for (Customer customer in customers){
      List<Document> documents = outgoingDocuments.where((item) => item.personId == customer.id).toList();
      pressDocuments.addAll(documents);
      for (Document document in documents){
        String customerName = customer.name;
        String documentName = document.name;
        String documentDate = DateFormatFactory.getDateFormat().format(document.date);
        String amount = Config.currencyFormat.format(document.amount);
        String paid = Config.currencyFormat.format(document.paid);
        String remain = Config.currencyFormat.format(document.amount - document.paid);
        rows.add([customerName, documentName, documentDate, amount, paid, remain]);
        totalAmount += document.amount;
        totalPaid += document.paid;
        totalRemain += (document.amount - document.paid);
      }
    }
    rows.add([AppLocalizations.of(context)!.field_total, "", "", getDoubleText(totalAmount), getDoubleText(totalPaid), getDoubleText(totalRemain)]);
    emit(state.copyWith(documents: pressDocuments));
    return rows;
  }


  String getDateTimeText(int date){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return DateFormatFactory.getDateFormat().format(dateTime);
  }
  String getDoubleText(double? input){
    return Config.currencyFormat.format(input);
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
    } catch (err) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }
  /*onExportExcelFileMenuClicked() async{
    //runtime permission
    await Permission.storage.request();
    //convert data to csv
    String csv = const ListToCsvConverter().convert(state.data);
    //convert csv to file
    String? downloadDir = await getDownloadPath();

    String folder = downloadDir! + "/AppViet_QuanLyKho";
    Directory directory = Directory(folder);
    if (!directory.existsSync()){
      directory.create();
    }
    String extension = ".csv";
    DateTime _now = DateTime.now();
    String timestamp = "${_now.day}_${_now.month}_${_now.year}_${_now.hour}_${_now.minute}_${_now.second}";
    String filePath = folder + "/export_" + timestamp + extension;
    File f = File(filePath);
    await f.writeAsString(csv);
    print(filePath);
    showInfoToast(filePath);
  }*/
}
