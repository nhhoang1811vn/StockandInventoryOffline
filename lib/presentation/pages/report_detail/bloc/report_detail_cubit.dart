import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/report_type.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/repositories/document_transaction_repositories.dart';
import 'package:good_manager/domain/usecases/customers/customers_usecases.dart';
import 'package:good_manager/domain/usecases/payment/payment_usercases.dart';
import 'package:good_manager/domain/usecases/suppliers/suppliers_usecases.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../data/storage.dart';
import '../../../../domain/entities/document.dart';
import '../../../../domain/entities/payment.dart';
import '../../../../domain/usecases/documents/document_usecases.dart';
import '../../../../domain/usecases/goods/goods_usercases.dart';
import '../../base/base_state.dart';

part 'report_detail_cubit.freezed.dart';
part 'report_detail_state.dart';

class ColumnReport{
  final String title;
  bool isVisible = true;

  ColumnReport(this.title);
}

@injectable
class ReportDetailCubit extends Cubit<ReportDetailState> {
  final Storage storage;
  final GoodsUseCases goodsUseCase;
  final PaymentUseCases paymentUseCases;
  final DocumentUseCases documentUseCases;
  final DocumentTransactionRepository documentTransactionRepository;
  final SuppliersUseCase suppliersUseCase;
  final CustomersUseCase customersUseCase;

  ReportDetailCubit(
      {required this.storage,
      required this.goodsUseCase,
      required this.paymentUseCases,
      required this.documentUseCases,
      required this.documentTransactionRepository,
      required this.suppliersUseCase,
      required this.customersUseCase})
      : super(ReportDetailState.initial(state: InitialState()));

  void init(BuildContext context, ReportType type, DateTime start, DateTime end, int? groupId, String? groupName) {
    emit(state.copyWith(
        state: LoadingState(), type: type, start: start, end: end, groupId: groupId, groupName: groupName));
    load(context);
  }

  Future<double> getQuantity(int goodId, List<Document> documents) async {
    double incoming = 0.0;
    double outgoing = 0.0;
    for (Document document in documents) {
      incoming += await documentTransactionRepository.getSumQuantityByGoodIdAndByDocumentId(
          DocumentType.incoming, goodId, document.id!);
      outgoing += await documentTransactionRepository.getSumQuantityByGoodIdAndByDocumentId(
          DocumentType.outgoing, goodId, document.id!);
    }
    return incoming - outgoing;
  }

  DateTime getPreviousHour(DateTime date) {
    return DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch - 60 * 60 * 1000); //- 60 mins
  }

  void load(BuildContext context) async {
    switch (state.type) {
      case ReportType.LIST_OF_GOODS:
        await initListOfGoods(context);
        break;
      case ReportType.LIST_OF_DOCUMENT:
        await initListOfDocuments(context);
        break;
      case ReportType.DEBTS_BY_SUPPLIER:
        await initDebtBySupplier(context);
        break;
      case ReportType.DEBTS_BY_CUSTOMER:
        await initDebtByCustomer(context);
        break;
      case ReportType.OUTBOUND_PAYMENTS:
        await initPayments(context, PaymentType.outbound);
        break;
      case ReportType.INBOUND_PAYMENTS:
        await  initPayments(context, PaymentType.inbound);
        break;
      default:
        break;
    }
    update();
  }
  void update(){
    List<List<String>> data = [];
    List<String> header = [];
    for (var column in state.columns){
      if (column.isVisible){
        header.add(column.title);
      }
    }
    data.add(header);
    for (var row in state.rows){
      List<String> rowData = [];
      for (int i = 0; i< row.length;i++){
        if (state.columns[i].isVisible){
          rowData.add(row[i]);
        }
      }
      data.add(rowData);
    }
    emit(state.copyWith(state: LoadSuccessState(),data: data));
  }

  Future<void> initListOfGoods(BuildContext context) async {
    List<ColumnReport> columns = [
      ColumnReport(AppLocalizations.of(context)!.field_bar_code),
      ColumnReport(AppLocalizations.of(context)!.field_name),
      ColumnReport(AppLocalizations.of(context)!.field_start_period),
      ColumnReport(AppLocalizations.of(context)!.field_in),
      ColumnReport(AppLocalizations.of(context)!.field_out),
      ColumnReport(AppLocalizations.of(context)!.field_end_period)
    ];
    List<List<String>> rows = [];
    int storeId = storage.getSelectedStoreId();
    List<Good> allGoods = await goodsUseCase.getAllByStoreId(storeId);
    List<Good> goods = allGoods.where((good) => (state.groupId == null || state.groupId == good.groupId)).toList();

    List<Document> documentsPrePeriod =
        await documentUseCases.getInRange(DateTime.fromMillisecondsSinceEpoch(0), getPreviousHour(state.start!));
    List<Document> documentsInPeriod = await documentUseCases.getInRange(state.start!, state.end!);
    double totalStartPeriodStock = 0.0;
    double totalIncoming = 0.0;
    double totalOutgoing = 0.0;
    double totalEndPeriodStock = 0.0;
    for (Good good in goods) {
      double incoming = 0.0;
      double outgoing = 0.0;
      for (Document document in documentsInPeriod) {
        incoming += await documentTransactionRepository.getSumQuantityByGoodIdAndByDocumentId(
            DocumentType.incoming, good.id!, document.id!);
        outgoing += await documentTransactionRepository.getSumQuantityByGoodIdAndByDocumentId(
            DocumentType.outgoing, good.id!, document.id!);
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
      if (startPeriodStock == 0.0 && incoming == 0.0 && outgoing == 0.0) {
      } else {
        rows.add(row);
        totalStartPeriodStock += startPeriodStock;
        totalIncoming += incoming;
        totalOutgoing += outgoing;
        totalEndPeriodStock += endPeriodStock;
      }
    }
    if (rows.length > 0) {
      rows.add([
        AppLocalizations.of(context)!.field_total,
        "",
        totalStartPeriodStock.toString(),
        totalIncoming.toString(),
        totalOutgoing.toString(),
        totalEndPeriodStock.toString()
      ]);
    }
    emit(state.copyWith(ids: goods.map((e) => e.id!).toList()));
    emit(state.copyWith(columns: columns,rows: rows));
  }

  Future<void> initListOfDocuments(BuildContext context) async {
    List<ColumnReport> columns = [
      ColumnReport(AppLocalizations.of(context)!.field_date),
      ColumnReport(AppLocalizations.of(context)!.field_name),
      ColumnReport(AppLocalizations.of(context)!.field_document_type),
      ColumnReport(AppLocalizations.of(context)!.field_person_name),
      ColumnReport(AppLocalizations.of(context)!.field_quantity),
      ColumnReport(AppLocalizations.of(context)!.field_amount),
    ];

    List<List<String>> rows = [];
    List<Document> items = await documentUseCases.getInRange(state.start!, state.end!);
    double quantityTotal = 0;
    double amountTotal = 0.0;
    for (Document item in items) {
      List<String> row = [];
      row.add(DateFormatFactory.getDateFormat().format(item.date));
      row.add(item.name);
      row.add(item.type.getTitle(context));
      row.add(item.personName ?? '');
      row.add(item.quantity.toString());
      row.add(Config.currencyFormat.format(item.amount));

      rows.add(row);
      amountTotal += item.amount;
      quantityTotal += item.quantity;
    }
    if (items.isNotEmpty) {
      List<String> totalRow = [];
      totalRow.add(AppLocalizations.of(context)!.field_total);
      totalRow.add("");
      totalRow.add("");
      totalRow.add("");
      totalRow.add(quantityTotal.toString());
      totalRow.add(Config.currencyFormat.format(amountTotal));
      rows.add(totalRow);
    }
    emit(state.copyWith(documents: items));
    emit(state.copyWith(columns: columns, rows: rows));
  }

  Future<void> initDebtBySupplier(BuildContext context) async {
    List<ColumnReport> columns = [
      ColumnReport(AppLocalizations.of(context)!.field_supplier),
      ColumnReport(AppLocalizations.of(context)!.field_document_no),
      ColumnReport(AppLocalizations.of(context)!.field_date),
      ColumnReport(AppLocalizations.of(context)!.field_amount),
      ColumnReport(AppLocalizations.of(context)!.field_paid),
      ColumnReport(AppLocalizations.of(context)!.field_remaining),
    ];
    List<Document> pressDocuments = [];
    List<List<String>> rows = [];

    List<String> names = [];
    List<double> amounts = [];
    List<double> paids = [];
    List<double> remains = [];

    int storeId = storage.getSelectedStoreId();
    List<Supplier> suppliers = await suppliersUseCase.getAllByStoreId(storeId);
    List<Document> allDocuments = await documentUseCases.getInRange(state.start!, state.end!);
    List<Document> incomingDocuments = allDocuments.where((item) => item.type == DocumentType.incoming).toList();
    for (Supplier supplier in suppliers) {
      String supplierName = supplier.name;
      List<Document> documents = incomingDocuments.where((item) => item.personId == supplier.id).toList();
      pressDocuments.addAll(documents);

      double personTotalAmount = 0.0;
      double personTotalPaid = 0.0;
      double personTotalRemaining = 0.0;

      for (Document document in documents) {
        String documentName = document.name;
        String documentDate = DateFormatFactory.getDateFormat().format(document.date);
        String amount = Config.currencyFormat.format(document.amount);
        String paid = Config.currencyFormat.format(document.paid);
        String remain = Config.currencyFormat.format(document.amount - document.paid);

        rows.add([supplierName, documentName, documentDate, amount, paid, remain]);

        personTotalAmount += document.amount;
        personTotalPaid += document.paid;
        personTotalRemaining += (document.amount - document.paid);
      }
      names.add(supplierName);
      amounts.add(personTotalAmount);
      paids.add(personTotalPaid);
      remains.add(personTotalRemaining);
    }
    rows.add([AppLocalizations.of(context)!.field_total, "","", "","",""]);

    for (int i = 0 ; i< names.length;i++){
      rows.add([
        names[i],
        "",
        "",
        Config.currencyFormat.format(amounts[i]),
        Config.currencyFormat.format(paids[i]),
        Config.currencyFormat.format(remains[i]),

      ]);
    }
    emit(state.copyWith(columns: columns, rows: rows,documents: pressDocuments));
  }

  Future<void> initDebtByCustomer(BuildContext context) async {
    List<List<String>> rows = [];
    List<Document> pressDocuments = [];
    List<ColumnReport> columns = [
      ColumnReport(AppLocalizations.of(context)!.field_customer),
      ColumnReport(AppLocalizations.of(context)!.field_document_no),
      ColumnReport(AppLocalizations.of(context)!.field_date),
      ColumnReport(AppLocalizations.of(context)!.field_amount),
      ColumnReport(AppLocalizations.of(context)!.field_paid),
      ColumnReport(AppLocalizations.of(context)!.field_remaining),
    ];
    List<String> names = [];
    List<double> amounts = [];
    List<double> paids = [];
    List<double> remains = [];

    int storeId = storage.getSelectedStoreId();
    List<Customer> customers = await customersUseCase.getAllByStoreId(storeId);
    List<Document> allDocuments = await documentUseCases.getInRange(state.start!, state.end!);
    List<Document> outgoingDocuments = allDocuments.where((item) => item.type == DocumentType.outgoing).toList();
    for (Customer customer in customers) {
      String customerName = customer.name;
      List<Document> documents = outgoingDocuments.where((item) => item.personId == customer.id).toList();
      pressDocuments.addAll(documents);
      double personTotalAmount = 0.0;
      double personTotalPaid = 0.0;
      double personTotalRemaining = 0.0;

      for (Document document in documents) {
        String documentName = document.name;
        String documentDate = DateFormatFactory.getDateFormat().format(document.date);
        String amount = Config.currencyFormat.format(document.amount);
        String paid = Config.currencyFormat.format(document.paid);
        String remain = Config.currencyFormat.format(document.amount - document.paid);
        rows.add([customerName, documentName, documentDate, amount, paid, remain]);
        personTotalAmount += document.amount;
        personTotalPaid += document.paid;
        personTotalRemaining += (document.amount - document.paid);
      }
      names.add(customerName);
      amounts.add(personTotalAmount);
      paids.add(personTotalPaid);
      remains.add(personTotalRemaining);

    }
    rows.add([AppLocalizations.of(context)!.field_total, "","", "","",""]);
    for (int i = 0 ; i< names.length;i++){
      rows.add([
        names[i],
        "",
        "",
        Config.currencyFormat.format(amounts[i]),
        Config.currencyFormat.format(paids[i]),
        Config.currencyFormat.format(remains[i]),

      ]);
    }
    emit(state.copyWith(columns: columns, rows: rows, documents: pressDocuments));
  }
  Future<void> initPayments(BuildContext context, PaymentType type) async{
    List<List<String>> rows = [];
    List<ColumnReport> columns = [
      ColumnReport(AppLocalizations.of(context)!.label_category_name),
      ColumnReport(AppLocalizations.of(context)!.field_date),
      ColumnReport(AppLocalizations.of(context)!.field_amount),
    ];

    List<Payment> allItems = await paymentUseCases.getInRange(state.start!, state.end!);
    List<Payment> outboundItems = allItems.where((item) => item.type == type).toList();

    var items = [...outboundItems]..sort((a, b) {
      if (a.category?.name == null) return 1;
      if (b.category?.name == null) return -1;
      return a.category!.name.compareTo(b.category!.name);
    });
    Map<String, double> categoryTotals = {};
    for (Payment item in items){
      var name = "";
      if (item.category != null){
        name = item.category!.name;
      }else{
        name = AppLocalizations.of(context)!.no_category;
      }
      String dateText = DateFormatFactory.getDateFormat().format(item.date);
      String amountText =  Config.currencyFormat.format(item.amount  ?? 0);
      rows.add([name, dateText, amountText]);

      categoryTotals[name] = (categoryTotals[name] ?? 0) + (item.amount ?? 0);
    }
    rows.add([AppLocalizations.of(context)!.field_total, "",""]);
    categoryTotals.forEach((category, total) {
      rows.add([category, "", Config.currencyFormat.format(total)]);
    });
    emit(state.copyWith(columns: columns, rows: rows, payments: items));
  }

  String getDateTimeText(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return DateFormatFactory.getDateFormat().format(dateTime);
  }

  String getDoubleText(double? input) {
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

  void setColumns(List<ColumnReport> columns) {
    emit(state.copyWith(columns: columns));
  }
}
