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
import 'package:good_manager/extension/date_time_apis.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

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
  bool showTotalText = false;
  bool showTotal = false;

  ColumnReport(this.title, {this.isPickValues = false, this.showTotalText = false, this.showTotal = false});
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

  void init(AppLocalizations localizations, bool isNeedUpdateSelectedValue, ReportType type, DateTime? start, DateTime? end) {
    emit(state.copyWith(state: LoadingState(), type: type, start: start, end: end));
    load(localizations, isNeedUpdateSelectedValue);
  }
  void initColumn(List<ColumnReport> columns){
    emit(state.copyWith(columns: columns));
  }
  Future<double> getSumQuantityIncoming(int goodId, List<Document> documents) async{
    double incoming = 0.0;
    for (Document document in documents) {
      incoming += await documentTransactionRepository.getSumQuantityByGoodIdAndByDocumentId(DocumentType.incoming, goodId, document.id!);
    }
    return incoming;
  }
  Future<double> getSumQuantityOutgoing(int goodId, List<Document> documents) async{
    double outgoing = 0.0;
    for (Document document in documents) {
      outgoing += await documentTransactionRepository.getSumQuantityByGoodIdAndByDocumentId(DocumentType.outgoing, goodId, document.id!);
    }
    return outgoing;
  }

  // Future<double> getQuantity(int goodId, List<Document> documents) async {
  //   double incoming = 0.0;
  //   double outgoing = 0.0;
  //   for (Document document in documents) {
  //     incoming += await documentTransactionRepository.getSumQuantityByGoodIdAndByDocumentId(
  //         DocumentType.incoming, goodId, document.id!);
  //     outgoing += await documentTransactionRepository.getSumQuantityByGoodIdAndByDocumentId(
  //         DocumentType.outgoing, goodId, document.id!);
  //   }
  //   return incoming - outgoing;
  // }

  //DateTime getPreviousHour(DateTime date) {
  //  return DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch - 60 * 60 * 1000); //- 60 mins
 // }

  void load(AppLocalizations localizations, bool isNeedUpdateSelectedValue) async {
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
    updateSetValuesForPickValuesColumn();
    if (isNeedUpdateSelectedValue){
      updateSelectedValueForPickValuesColumn();
    }
    update(localizations);
  }

  void updateSetValuesForPickValuesColumn() {
    List<ColumnReport> newColumns = state.columns;
    for (int i = 0; i < state.rows.length; i++) {
      for (int j = 0; j < newColumns.length; j++) {
        if (newColumns[j].isPickValues) {
          newColumns[j].values.add(state.rows[i][j]);
        }
      }
    }
    emit(state.copyWith(columns: newColumns));
  }
  void updateSelectedValueForPickValuesColumn(){
    List<ColumnReport> newColumns = state.columns;
    for (int i = 0; i < state.rows.length; i++) {
      for (int j = 0; j < newColumns.length; j++) {
        if (newColumns[j].isPickValues) {
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
    List<int?> ids = [];
    for (int i =0; i< rows.length;i++){
      var row = rows[i];
      var valid = true;
      for (int j = 0; j < state.columns.length; j++) {
        valid = isValid(state.columns[j], row[j]);
        if (!valid) {
          break;
        }
      }
      if (valid) {
        if (
           state.type == ReportType.LIST_OF_CUSTOMER_PAYMENTS
            || state.type == ReportType.LIST_OF_SUPPLIER_PAYMENTS
        ){

        }else{
          ids.add(state.allIds[i]);
        }
        validRows.add(row);
      }
    }
    emit(state.copyWith(ids: ids));
    if (validRows.length > 0) {
      List<String> totalRow = [];
      for (int i = 0; i < state.columns.length; i++) {
        if (state.columns[i].showTotalText){
          totalRow.add(localizations.field_total);
        }
        else if (state.columns[i].showTotal) {
          var sumAmount = 0.0;
          for (int j = 0; j < validRows.length; j++) {
            sumAmount += getDoubleFromFormattedText(validRows[j][i]);
          }
          totalRow.add(getDoubleText(sumAmount));
        }else{
          totalRow.add("");
        }
      }
      validRows.add(totalRow);
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

    List<Good> items = [];
    for (Good good in allGoods) {
      var minQuan = 0.0;
      if (good.minQuantity != null){
        minQuan = good.minQuantity!;
      }
      if (good.quantity < minQuan){
        items.add(good);
      }
    }
    for (Good item in items){
      var minQuan = 0.0;
      if (item.minQuantity != null){
        minQuan = item.minQuantity!;
      }
      var reorder = minQuan - item.quantity;
      var amount = reorder * (item.purchasePrice??0.0);
      List<String> row = [
        item.name,
        item.barCode ?? "",
        getDoubleText(item.quantity),
        getDoubleText(minQuan),
        getDoubleText(reorder),
        getDoubleText(item.purchasePrice??0),
        getDoubleText(amount)
      ];
      rows.add(row);
    }
    emit(state.copyWith(rows: rows,allIds: items.map((item) => item.id!).toList()));
  }
  Future<void> initListOfGoods(AppLocalizations localizations) async {
    List<List<String>> rows = [];
    int storeId = storage.getSelectedStoreId();
    List<Good> allGoods = await goodsUseCase.getAllByStoreId(storeId);
    allGoods.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    List<Document> documentsPrePeriod = await documentUseCases.getInRange(DateTime.fromMillisecondsSinceEpoch(0), state.start!.endOfYesterday());

    List<Document> documentsInPeriod = await documentUseCases.getInRange(state.start!.startOfDay(), state.end!.endOfDay());
    for (Good good in allGoods) {
      var groupName = localizations.no_group;
      if (good.groupId != null) {
        Group group = await groupsUseCases.getById(good.groupId!);
        groupName = group.name;
      }
      double sumQuantityIncomingPre = await getSumQuantityIncoming(good.id!, documentsPrePeriod);
      double sumQuantityOutgoingPre = await getSumQuantityOutgoing(good.id!, documentsPrePeriod);
      double startPeriodStock = sumQuantityIncomingPre - sumQuantityOutgoingPre;

      double incoming = await getSumQuantityIncoming(good.id!, documentsInPeriod);
      double outgoing = await getSumQuantityOutgoing(good.id!, documentsInPeriod);

      double endPeriodStock = startPeriodStock + incoming - outgoing;
      List<String> row = [
        good.name,
        groupName,
        good.barCode ?? "",
        getDoubleText(startPeriodStock),
        getDoubleText(incoming),
        getDoubleText(outgoing),
        getDoubleText(endPeriodStock)
      ];
      rows.add(row);
    }
    emit(state.copyWith(rows: rows, allIds: allGoods.map((good) => good.id!).toList()));
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
      row.add(getDoubleText(item.quantity));
      row.add(getDoubleText(item.amount));
      rows.add(row);
    }
    emit(state.copyWith(rows: rows, allIds: items.map((document) => document.id!).toList()));
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
        getDoubleText(personTotalAmount),
        getDoubleText(personTotalPaid),
        getDoubleText(personTotalRemaining),
      ]);
    }

    emit(state.copyWith(rows: rows, allIds: suppliers.map((supplier) => supplier.id!).toList()));
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
        getDoubleText(personTotalAmount),
        getDoubleText(personTotalPaid),
        getDoubleText(personTotalRemaining),
      ]);
    }
    emit(state.copyWith(rows: rows, allIds: customers.map((customer) => customer.id!).toList()));
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
    Set<int?> categoryIds = {};
    for (Payment item in items) {
      var name = "";
      if (item.category != null) {
        name = item.category!.name;
      } else {
        name = localizations.no_category;
      }
      categoryIds.add(item.category?.id);
      categoryTotals[name] = (categoryTotals[name] ?? 0) + (item.amount ?? 0);
    }
    categoryTotals.forEach((category, total) {
      rows.add([category, getDoubleText(total)]);
    });
    emit(state.copyWith(rows: rows, allIds: categoryIds.toList()));
  }

  Future<void> initListOfWallets() async {
    List<List<String>> rows = [];
    int storeId = storage.getSelectedStoreId();
    List<Wallet> wallets = await walletUseCases.getAllByStoreId(storeId);
    for (Wallet wallet in wallets) {
      List<Payment> prePayments = await paymentUseCases.getInRangeByWalletId(
          wallet.id!, DateTime.fromMillisecondsSinceEpoch(0), state.start!.endOfYesterday());
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
        getDoubleText(preRev),
        getDoubleText(inAmount),
        getDoubleText(outAmount),
        getDoubleText(preRev + inAmount - outAmount),
      ]);
    }
    emit(state.copyWith(rows: rows, allIds: wallets.map((wallet) => wallet.id!).toList()));
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
        getDoubleText(getTotal(payments)),
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

  String getDoubleText(double input) {
    final formatter = NumberFormat('#,###');
    return formatter.format(input);
  }
  double getDoubleFromFormattedText(String input){
    return double.tryParse(input.replaceAll(",", ""))??0;
  }

  void setColumns(List<ColumnReport> columns) {
    emit(state.copyWith(columns: columns));
  }
  Future<Good> getGood(int id){
    return goodsUseCase.get(id);
  }
  Future<Document> getDocument(int id){
    return documentUseCases.get(id);
  }
  Future<Supplier> getSupplier(int id){
    return suppliersUseCase.get(id);
  }
  Future<Customer> getCustomer(int id){
    return customersUseCase.get(id);
  }
}
