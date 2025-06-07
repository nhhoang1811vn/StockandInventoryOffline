import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/report_type.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/wallet.dart';
import 'package:good_manager/domain/repositories/document_transaction_repositories.dart';
import 'package:good_manager/domain/usecases/customers/customers_usecases.dart';
import 'package:good_manager/domain/usecases/groups/groups_usecases.dart';
import 'package:good_manager/domain/usecases/payment/payment_usercases.dart';
import 'package:good_manager/domain/usecases/suppliers/suppliers_usecases.dart';
import 'package:good_manager/domain/usecases/wallets/wallet_usecases.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../data/storage.dart';
import '../../../../domain/entities/document.dart';
import '../../../../domain/entities/group.dart';
import '../../../../domain/entities/payment.dart';
import '../../../../domain/usecases/documents/document_usecases.dart';
import '../../../../domain/usecases/goods/goods_usercases.dart';
import '../../base/base_state.dart';

part 'report_detail_cubit.freezed.dart';
part 'report_detail_state.dart';

class ColumnReport {
  final String title;
  bool isVisible = true;
  bool isPickValues = false;
  Set<String> values = {};
  Set<String> selectedValues = {};

  ColumnReport(this.title, {this.isPickValues = false});
}

@injectable
class ReportDetailCubit extends Cubit<ReportDetailState> {
  final Storage storage;
  final GoodsUseCases goodsUseCase;
  final GroupsUseCases groupsUseCases;
  final PaymentUseCases paymentUseCases;
  final DocumentUseCases documentUseCases;
  final DocumentTransactionRepository documentTransactionRepository;
  final SuppliersUseCase suppliersUseCase;
  final CustomersUseCase customersUseCase;
  final WalletUseCases walletUseCases;

  ReportDetailCubit({
    required this.storage,
    required this.goodsUseCase,
    required this.groupsUseCases,
    required this.paymentUseCases,
    required this.documentUseCases,
    required this.documentTransactionRepository,
    required this.suppliersUseCase,
    required this.customersUseCase,
    required this.walletUseCases,
  }) : super(ReportDetailState.initial(state: InitialState()));

  void init(AppLocalizations localizations, ReportType type, DateTime? start, DateTime? end) {
    emit(state.copyWith(state: LoadingState(), type: type, start: start, end: end));
    load(localizations);
  }
  void initColumn(List<ColumnReport> columns){
    emit(state.copyWith(columns: columns));
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

  void load(AppLocalizations localizations) async {
    switch (state.type) {
      case ReportType.LIST_OF_GOODS:
        await initListOfGoods(localizations);
        break;
      case ReportType.LIST_OF_DOCUMENT:
        await initListOfDocuments(localizations);
        break;
      case ReportType.DEBTS_BY_SUPPLIER:
        await initDebtBySupplier();
        break;
      case ReportType.DEBTS_BY_CUSTOMER:
        await initDebtByCustomer();
        break;
      case ReportType.OUTBOUND_PAYMENTS:
        await initPayments(localizations, PaymentType.outbound);
        break;
      case ReportType.INBOUND_PAYMENTS:
        await initPayments(localizations, PaymentType.inbound);
        break;
      case ReportType.LIST_OF_WALLETS:
        await initListOfWallets();
      case ReportType.LIST_OF_SUPPLIER_PAYMENTS:
        await initListOfSupplierPayments();
      case ReportType.LIST_OF_CUSTOMER_PAYMENTS:
        await initListOfCustomerPayments();
      case ReportType.RE_ORDER:
        await initReorder();
      default:
        break;
    }
    updateSetValues();
    update(localizations);
  }

  void updateSetValues() {
    List<ColumnReport> newColumns = state.columns;
    for (int i = 0; i < state.rows.length; i++) {
      for (int j = 0; j < newColumns.length; j++) {
        if (newColumns[j].isPickValues) {
          newColumns[j].values.add(state.rows[i][j]);
          newColumns[j].selectedValues.add(state.rows[i][j]);
        }
      }
    }
    emit(state.copyWith(columns: newColumns));
  }

  void update(AppLocalizations localizations) {
    List<List<String>> data = [];
    List<String> header = [];
    for (var column in state.columns) {
      if (column.isVisible) {
        header.add(column.title);
      }
    }
    data.add(header);
    List<List<String>> rows = state.rows;
    List<List<String>> validRows = [];

    for (var row in rows) {
      var valid = true;
      for (int j = 0; j < state.columns.length; j++) {
        valid = isValid(state.columns[j], row[j]);
        if (!valid) {
          break;
        }
      }
      if (valid) {
        validRows.add(row);
      }
    }
    if (validRows.length > 0) {
      if (state.type == ReportType.LIST_OF_GOODS) {
        double totalStartPeriod = 0.0;
        double totalIn = 0.0;
        double totalOut = 0.0;
        double totalEndPeriod = 0.0;
        for (int i = 0; i < validRows.length; i++) {
          totalStartPeriod += double.parse(validRows[i][3]);
          totalIn += double.parse(validRows[i][4]);
          totalOut += double.parse(validRows[i][5]);
          totalEndPeriod += double.parse(validRows[i][6]);
        }
        validRows.add([
          localizations.field_total,
          "",
          "",
          totalStartPeriod.toString(),
          totalIn.toString(),
          totalOut.toString(),
          totalEndPeriod.toString()
        ]);
      } else if (state.type == ReportType.LIST_OF_DOCUMENT) {
        double totalQuantity = 0.0;
        double totalAmount = 0.0;
        for (int i = 0; i < validRows.length; i++) {
          totalQuantity += double.parse(validRows[i][4]);
          totalAmount += double.parse(validRows[i][5]);
        }
        validRows.add(
            [localizations.field_total, "", "", "", totalQuantity.toString(), totalAmount.toString()]);
      }
    }
    for (var row in validRows) {
      List<String> rowData = [];
      for (int j = 0; j < state.columns.length; j++) {
        if (state.columns[j].isVisible) {
          rowData.add(row[j]);
        }
      }
      data.add(rowData);
    }
    emit(state.copyWith(state: LoadSuccessState(), data: data));
  }

  bool isValid(ColumnReport column, String value) {
    if (!column.isVisible)
      return true;
    if (column.isPickValues && !column.selectedValues.contains(value)) return false;
    return true;
  }
  Future<void> initReorder() async{
    List<List<String>> rows = [];
    int storeId = storage.getSelectedStoreId();
    List<Good> allGoods = await goodsUseCase.getAllByStoreId(storeId);
    allGoods.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    for (Good good in allGoods) {
      var minQuan = 0.0;
      if (good.minQuantity != null){
        minQuan = good.minQuantity!;
      }
      if (good.quantity < minQuan){
        var reorder = minQuan - good.quantity;
        var amount = reorder * (good.purchasePrice??0.0);
        List<String> row = [
          good.name,
          good.barCode ?? "",
          good.quantity.toString(),
          minQuan.toString(),
          reorder.toString(),
          good.purchasePrice.toString(),
          amount.toString()
        ];
        rows.add(row);
      }
    }
    emit(state.copyWith(rows: rows));
  }
  Future<void> initListOfGoods(AppLocalizations localizations) async {
    List<List<String>> rows = [];
    int storeId = storage.getSelectedStoreId();
    List<Good> allGoods = await goodsUseCase.getAllByStoreId(storeId);
    allGoods.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    List<Document> documentsPrePeriod =
        await documentUseCases.getInRange(DateTime.fromMillisecondsSinceEpoch(0), getPreviousHour(state.start!));
    List<Document> documentsInPeriod = await documentUseCases.getInRange(state.start!, state.end!);
    for (Good good in allGoods) {
      double incoming = 0.0;
      double outgoing = 0.0;
      for (Document document in documentsInPeriod) {
        incoming += await documentTransactionRepository.getSumQuantityByGoodIdAndByDocumentId(
            DocumentType.incoming, good.id!, document.id!);
        outgoing += await documentTransactionRepository.getSumQuantityByGoodIdAndByDocumentId(
            DocumentType.outgoing, good.id!, document.id!);
      }
      //var groupName = "No group";
      var groupName = localizations.no_group;
      if (good.groupId != null) {
        Group group = await groupsUseCases.getById(good.groupId!);
        groupName = group.name;
      }
      double startPeriodStock = await getQuantity(good.id!, documentsPrePeriod);
      double endPeriodStock = startPeriodStock + incoming - outgoing;
      List<String> row = [
        good.name,
        groupName,
        good.barCode ?? "",
        startPeriodStock.toString(),
        incoming.toString(),
        outgoing.toString(),
        endPeriodStock.toString()
      ];
      rows.add(row);
    }
    emit(state.copyWith(rows: rows, goods: allGoods));
  }

  Future<void> initListOfDocuments(AppLocalizations localizations) async {
    List<List<String>> rows = [];
    List<Document> items = await documentUseCases.getInRange(state.start!, state.end!);
    for (Document item in items) {
      List<String> row = [];
      row.add(DateFormatFactory.getDateFormat().format(item.date));
      row.add(item.name);
      row.add(item.type.getTitle(localizations));
      row.add(item.personName ?? '');
      row.add(item.quantity.toString());
      row.add(item.amount.toString());
      rows.add(row);
    }
    emit(state.copyWith(rows: rows, documents: items));
  }

  Future<void> initDebtBySupplier() async {
    List<List<String>> rows = [];
    int storeId = storage.getSelectedStoreId();
    List<Supplier> suppliers = await suppliersUseCase.getAllByStoreId(storeId);
    List<Document> allDocuments = await documentUseCases.getInRange(state.start!, state.end!);
    List<Document> incomingDocuments = allDocuments.where((item) => item.type == DocumentType.incoming).toList();
    for (Supplier supplier in suppliers) {
      String supplierName = supplier.name;
      List<Document> documents = incomingDocuments.where((item) => item.personId == supplier.id).toList();

      double personTotalAmount = 0.0;
      double personTotalPaid = 0.0;
      double personTotalRemaining = 0.0;

      for (Document document in documents) {
        personTotalAmount += document.amount;
        personTotalPaid += document.paid;
        personTotalRemaining += (document.amount - document.paid);
      }
      rows.add([
        supplierName,
        Config.currencyFormat.format(personTotalAmount),
        Config.currencyFormat.format(personTotalPaid),
        Config.currencyFormat.format(personTotalRemaining)
      ]);
    }

    emit(state.copyWith(rows: rows, suppliers: suppliers));
  }

  Future<void> initDebtByCustomer() async {
    List<List<String>> rows = [];
    int storeId = storage.getSelectedStoreId();
    List<Customer> customers = await customersUseCase.getAllByStoreId(storeId);
    List<Document> allDocuments = await documentUseCases.getInRange(state.start!, state.end!);
    List<Document> outgoingDocuments = allDocuments.where((item) => item.type == DocumentType.outgoing).toList();
    for (Customer customer in customers) {
      String customerName = customer.name;
      List<Document> documents = outgoingDocuments.where((item) => item.personId == customer.id).toList();
      double personTotalAmount = 0.0;
      double personTotalPaid = 0.0;
      double personTotalRemaining = 0.0;

      for (Document document in documents) {
        personTotalAmount += document.amount;
        personTotalPaid += document.paid;
        personTotalRemaining += (document.amount - document.paid);
      }
      rows.add([
        customerName,
        Config.currencyFormat.format(personTotalAmount),
        Config.currencyFormat.format(personTotalPaid),
        Config.currencyFormat.format(personTotalRemaining),
      ]);
    }
    emit(state.copyWith(rows: rows, customers: customers));
  }

  Future<void> initPayments(AppLocalizations localizations, PaymentType type) async {
    List<List<String>> rows = [];

    List<Payment> allItems = await paymentUseCases.getInRange(state.start!, state.end!);
    List<Payment> outboundItems = allItems.where((item) => item.type == type).toList();
    var items = [...outboundItems]..sort((a, b) {
        if (a.category?.name == null) return 1;
        if (b.category?.name == null) return -1;
        return a.category!.name.compareTo(b.category!.name);
      });
    Map<String, double> categoryTotals = {};
    for (Payment item in items) {
      var name = "";
      if (item.category != null) {
        name = item.category!.name;
      } else {
        name = localizations.no_category;
      }
      categoryTotals[name] = (categoryTotals[name] ?? 0) + (item.amount ?? 0);
    }
    categoryTotals.forEach((category, total) {
      rows.add([category, Config.currencyFormat.format(total)]);
    });
    emit(state.copyWith(rows: rows, payments: items));
  }

  Future<void> initListOfWallets() async {
    List<List<String>> rows = [];
    int storeId = storage.getSelectedStoreId();
    List<Wallet> wallets = await walletUseCases.getAllByStoreId(storeId);
    for (Wallet wallet in wallets) {
      List<Payment> prePayments = await paymentUseCases.getInRangeByWalletId(
          wallet.id!, DateTime.fromMillisecondsSinceEpoch(0), getPreviousHour(state.start!));
      List<Payment> payments = await paymentUseCases.getInRangeByWalletId(wallet.id!, state.start!, state.end!);

      double preRev = getRevenue(prePayments);
      double inAmount = payments
          .where((payment) => payment.type == PaymentType.inbound)
          .toList()
          .fold(0.0, (sum, payment) => sum + (payment.amount ?? 0.0));
      double outAmount = payments
          .where((payment) => payment.type == PaymentType.outbound)
          .toList()
          .fold(0.0, (sum, payment) => sum + (payment.amount ?? 0.0));
      rows.add([
        wallet.name,
        Config.simpleCurrencyFormat.format(preRev),
        Config.simpleCurrencyFormat.format(inAmount),
        Config.simpleCurrencyFormat.format(outAmount),
        Config.simpleCurrencyFormat.format(preRev + inAmount - outAmount),
      ]);
    }
    emit(state.copyWith(rows: rows));
  }
  Future<void> initListOfSupplierPayments() async {
    List<List<String>> rows = [];
    int storeId = storage.getSelectedStoreId();
    List<Supplier> suppliers = await suppliersUseCase.getAllByStoreId(storeId);
    for (Supplier supplier in suppliers){
      List<Payment> payments = await paymentUseCases.getInRangeBySupplierId(supplier.id!, state.start!, state.end!);
      rows.add([
        supplier.name,
        Config.simpleCurrencyFormat.format(getTotal(payments)),
      ]);
    }
    emit(state.copyWith(rows: rows));
  }
  Future<void> initListOfCustomerPayments() async {
    List<List<String>> rows = [];
    int storeId = storage.getSelectedStoreId();
    List<Customer> customers = await customersUseCase.getAllByStoreId(storeId);
    for (Customer customer in customers){
      List<Payment> payments = await paymentUseCases.getInRangeByCustomerId(customer.id!, state.start!, state.end!);
      rows.add([
        customer.name,
        Config.simpleCurrencyFormat.format(getTotal(payments)),
      ]);
    }
    emit(state.copyWith(rows: rows));
  }

  double getRevenue(List<Payment> payments) {
    double inAmount = payments
        .where((payment) => payment.type == PaymentType.inbound)
        .toList()
        .fold(0.0, (sum, payment) => sum + (payment.amount ?? 0.0));
    double outAmount = payments
        .where((payment) => payment.type == PaymentType.outbound)
        .toList()
        .fold(0.0, (sum, payment) => sum + (payment.amount ?? 0.0));
    return inAmount - outAmount;
  }
  double getTotal(List<Payment> payments){
    return  payments
        //.where((payment) => payment.type == PaymentType.inbound)
        .toList()
        .fold(0.0, (sum, payment) => sum + (payment.amount ?? 0.0));
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
