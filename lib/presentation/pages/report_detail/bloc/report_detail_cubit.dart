import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/payment_status.dart';
import 'package:good_manager/domain/entities/report_type.dart';
import 'package:good_manager/domain/repositories/document_transaction_repositories.dart';
import 'package:good_manager/domain/usecases/expenses/expense_usercases.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  ReportDetailCubit({
    required this.storage,
    required this.goodsUseCase,
    required this.expenseUseCase,
    required this.documentUseCases,
    required this.documentTransactionRepository
  }) : super(ReportDetailState.initial(state: InitialState()));

  void init(BuildContext context, ReportType type, DateTime start, DateTime end){
    emit(state.copyWith(type: type, start: start, end: end));
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
  DateTime getPrevousHour(DateTime date){
    return DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch - 60*60*1000);//- 60 mins
  }
  void load(BuildContext context) async{
    List<List<String>> data = [];
    switch(state.type){
      case ReportType.LIST_OF_GOODS:
        data.add(["Tên", "Ban đầu (SL)", "Nhập vào (SL)", "Bán ra (SL)", "Cuối Kỳ (SL)"]);
        int storeId = storage.getSelectedStoreId();
        List<Good> goods = await goodsUseCase.getAllByStoreId(storeId);

        List<Document> documentsPrePeriod = await documentUseCases.getInRange(DateTime.fromMillisecondsSinceEpoch(0), getPrevousHour(state.start!));
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
          data.add([AppLocalizations.of(context)!.field_total, totalStartPeriodStock.toString(), totalIncoming.toString(), totalOutgoing.toString(), totalEndPeriodStock.toString()]);
        }
        emit(state.copyWith(ids: goods.map((e) => e.id!).toList()));

        break;
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
        data.add([AppLocalizations.of(context)!.field_date, AppLocalizations.of(context)!.field_name, AppLocalizations.of(context)!.field_document_type, AppLocalizations.of(context)!.field_person_name, AppLocalizations.of(context)!.field_quantity, AppLocalizations.of(context)!.field_cost,AppLocalizations.of(context)!.field_revenue]);
        int quantityTotal = 0;
        double costTotal = 0.0;
        double revenueTotal = 0.0;
        for (Document item in items){
          List<String> row = [];
          row.add(Config.dateFormat.format(item.date));
          row.add(item.name);
          row.add(item.type.getTitle(context));
          row.add(item.personName ?? '');
          row.add(item.quantity.toString());
          if (item.type == DocumentType.incoming){
            row.add(Config.currencyFormat.format(item.amount));
            row.add("");
            costTotal += item.amount;
          }else{
            row.add("");
            row.add(Config.currencyFormat.format(item.amount));
            revenueTotal += item.amount;
          }
          data.add(row);
          //todo
          //quantityTotal += item.quantity;
        }
        if (items.isNotEmpty){
          List<String> totalRow = [];
          totalRow.add(AppLocalizations.of(context)!.field_total);
          totalRow.add("");
          totalRow.add("");
          totalRow.add("");
          totalRow.add(quantityTotal.toString());
          totalRow.add(Config.currencyFormat.format(costTotal));
          totalRow.add(Config.currencyFormat.format(revenueTotal));
          data.add(totalRow);
        }
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
    emit(state.copyWith(data: data));
  }
  Future<List<List<String>>> getDataDebtBySupplier(BuildContext context) async{
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

    var dbHelper = DBHelper();

    String query = "SELECT S.id as supplierId, S.name as supplierName,D.id, D.name as documentName, D.date, SUM(T.quantity*T.price) as amount, R.amount as payment FROM ${DBHelper.DOCUMENTS_TABLE_NAME} D ";
    query += "INNER JOIN ${DBHelper.SUPPLIERS_TABLE_NAME} S ON D.supplierId = S.id ";
    query += "LEFT JOIN ${DBHelper.DOCUMENT_TRANSACTIONS_TABLE_NAME} T ON D.id = T.documentId ";
    query += "LEFT JOIN (SELECT documentId,SUM(amount) as amount FROM ${DBHelper.PAYMENTS_TABLE_NAME} GROUP BY documentId) as R ON D.id = R.documentId ";
    query += "WHERE D.storeId = ? AND D.paymentStatus != ? AND D.date BETWEEN ? AND ?";
    query += "GROUP BY D.id ";
    query += "ORDER BY S.name, D.date DESC";


    var result = await dbHelper.rawQuery(query, [storage.getSelectedStoreId(), PaymentStatus.PAID.index, state.start!.millisecondsSinceEpoch, state.end!.millisecondsSinceEpoch]);
    double totalAmount = 0.0;
    double totalPayment = 0.0;
    double totalRemain = 0.0;

    for (Map<dynamic, dynamic> map in result){
      double amount = map["amount"]??0.0;
      double payment = map["payment"]??0.0;
      double remain = amount - payment;
      totalAmount += amount;
      totalPayment += payment;
      totalRemain += remain;


      rows.add([map["supplierName"], map["documentName"], getDateTimeText(map["date"]), getDoubleText(amount), getDoubleText(payment),getDoubleText(remain) ]);
    }
    rows.add([AppLocalizations.of(context)!.field_total, "", "", getDoubleText(totalAmount), getDoubleText(totalPayment), getDoubleText(totalRemain)]);
    return rows;
  }


  Future<List<List<String>>> getDataDebtByCustomer(BuildContext context) async{
    List<List<String>> rows = [];
    //header
    rows.add([
      AppLocalizations.of(context)!.field_customer,
      AppLocalizations.of(context)!.field_document_no,
      AppLocalizations.of(context)!.field_date,
      AppLocalizations.of(context)!.field_amount,
      AppLocalizations.of(context)!.field_paid,
      AppLocalizations.of(context)!.field_remaining,
    ]);

    var dbHelper = DBHelper();

    String query = "SELECT C.name as customerName,D.id, D.name as documentName, D.date, SUM(T.quantity*T.price) as amount, R.amount as payment FROM ${DBHelper.DOCUMENTS_TABLE_NAME} D ";
    query += "INNER JOIN ${DBHelper.CUSTOMERS_TABLE_NAME} C ON D.customerId = C.id ";
    query += "LEFT JOIN ${DBHelper.DOCUMENT_TRANSACTIONS_TABLE_NAME} T ON D.id = T.documentId ";
    query += "LEFT JOIN (SELECT documentId,SUM(amount) as amount FROM ${DBHelper.PAYMENTS_TABLE_NAME} GROUP BY documentId) as R ON D.id = R.documentId ";
    query += "WHERE D.storeId = ? AND D.paymentStatus != ? AND D.date BETWEEN ? AND ?";
    query += "GROUP BY D.id ";
    query += "ORDER BY C.name, D.date DESC";


    var result = await dbHelper.rawQuery(query, [storage.getSelectedStoreId(), PaymentStatus.PAID.index, state.start!.millisecondsSinceEpoch, state.end!.millisecondsSinceEpoch]);
    double totalAmount = 0.0;
    double totalPayment = 0.0;
    double totalRemain = 0.0;

    for (Map<dynamic, dynamic> map in result){
      double amount = map["amount"]??0.0;
      double payment = map["payment"]??0.0;
      double remain = amount - payment;
      totalAmount += amount;
      totalPayment += payment;
      totalRemain += remain;
      rows.add([map["customerName"], map["documentName"], getDateTimeText(map["date"]), getDoubleText(amount), getDoubleText(payment),getDoubleText(remain) ]);
    }
    rows.add([AppLocalizations.of(context)!.field_total, "", "", getDoubleText(totalAmount), getDoubleText(totalPayment), getDoubleText(totalRemain)]);
    return rows;
  }


  String getDateTimeText(int date){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return Config.dateFormat.format(dateTime);
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
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }
  onExportExcelFileMenuClicked() async{
    //runtime permission
    var status = await Permission.storage.request();
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
  }
}
