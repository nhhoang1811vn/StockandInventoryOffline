import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/data/storage.dart';
import 'package:good_manager/domain/entities/batch_mode_scan.dart';
import 'package:good_manager/domain/entities/payment_status.dart';
import 'package:good_manager/domain/entities/save_document_setting.dart';
import 'package:good_manager/domain/usecases/documents/document_usecases.dart';
import 'package:good_manager/domain/usecases/payment/payment_usercases.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/save_document/sort/sort_by_barcode_document_transaction.dart';
import 'package:good_manager/presentation/pages/save_document/sort/sort_by_quantity_document_transaction.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/document.dart';
import '../../../../domain/entities/good.dart';
import '../../../../domain/entities/models/name.dart';
import '../../../../domain/entities/payment.dart';
import '../../../../domain/entities/sort_by_number.dart';
import '../../../../domain/entities/sort_by_text.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/usecases/goods/goods_usercases.dart';
import '../sort/sort_by_created_date_document_transaction.dart';
import '../sort/sort_by_name_document_transaction.dart';
import '../sort/sort_transaction.dart';

part 'save_document_cubit.freezed.dart';
part 'save_document_state.dart';

@injectable
class SaveDocumentCubit extends Cubit<SaveDocumentState> {
  final Storage storage;
  final DocumentUseCases useCase;
  final PaymentUseCases paymentUseCase;
  final GoodsUseCases goodUseCases;

  SaveDocumentCubit({required this.useCase, required this.paymentUseCase, required this.goodUseCases, required this.storage})
      : super(SaveDocumentState.initial(state: InitialState(), setting: storage.getSaveDocumentSetting()));

  void init(Document item) {
    SaveDocumentState initState = state.copyWith(
        item: item,
        name: NameInput.dirty(value: item.name),
        description: item.description,
        date: item.date,
        personId: item.personId,
        personName: item.personName,
        paymentStatus: item.paymentStatus
    );
    emit(initState);
    if (item.id != null) {
      loadPayments();
      loadTransactions();
    }
  }

  Future<bool> onWillPop() async {
    return true;
  }

  void nameChanged(String value) {
    final name = NameInput.dirty(value: value);
    emit(state.copyWith(name: name));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  void dateChanged(DateTime date) {
    emit(state.copyWith(date: date));
  }
  DateTime getDateOnly(DateTime dateTime){
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
  Future<bool> save() async {
    final validate = Formz.validate([state.name]);
    if (validate) {
      Document item = state.item!;
      item.name = state.name.value;
      item.description = state.description;
      item.date = getDateOnly(state.date!);
      item.personId = state.personId;
      item.paymentStatus = state.paymentStatus!;
      if (item.id == null) {
        int id = await useCase.insert(item);
        item.id = id;
      } else {
        await useCase.update(item);
      }
      emit(state.copyWith(item: item));
      return true;
    } else {
      emit(state.copyWith(name: NameInput.dirty(value: state.name.value)));
      return false;
    }
  }

  void onAddGoodClicked() async {
    final result = await save();
    if (result){
      emit(state.copyWith(state: OpenGoodListState()));
    }
  }

  void onSaveMenuClicked() async {
    bool result = await save();
    if (result) {
      emit(state.copyWith(state: SaveDocumentSuccessfulState(state.item!)));
    }
  }

  void onSearchMenuClicked() {
    emit(state.copyWith(showSearchBar: !state.showSearchBar));
    resetSearch();
  }

  void resetSearch() {
    emit(state.copyWith(textSearch: ""));
    filter();
  }

  onPersonClicked() {
    emit(state.copyWith(state: OpenPersonListState()));
  }

  void onPersonChanged(int id) {
    emit(state.copyWith(personId: id));
  }
  void onPersonNameChanged(String name){
    emit(state.copyWith(personName: name));
  }
  void loadPayments() async{
    List<Payment> payments = await paymentUseCase.getByDocumentId(state.item!.id!);
    emit(state.copyWith(payments: payments));
  }
  void loadPaymentsAndCheck() async{
    List<Payment> payments = await paymentUseCase.getByDocumentId(state.item!.id!);
    emit(state.copyWith(payments: payments));
    if (payments.isNotEmpty){
      verifyPaymentStatusButton();
    }
  }
  void verifyPaymentStatusButton(){
    double totalPayment = getTotalPayments(state.payments);
    double totalAmount = state.totalAmount;
    if (totalPayment < totalAmount){
      emit(state.copyWith(paymentStatus: PaymentStatus.PARTIAL));
    }else{
      emit(state.copyWith(paymentStatus: PaymentStatus.PAID));
    }
    save();
  }
  double getTotalPayments(List<Payment> payments){
    double total = 0.0;
    payments.forEach((element) {
      total += element.amount??0;
    });
    return total;
  }
  void loadTransactions() async {
    if (state.item?.id != null){
      List<DocumentTransaction> transactions = await useCase.getTransactionsByDocumentId(state.item!.id!);
      double totalQuantity = 0;
      double totalAmount = 0.0;
      transactions.forEach((element) {
        totalQuantity += element.quantity;
        totalAmount += (element.quantity * (element.price ?? 0.0));
      });
      emit(state.copyWith(allTransactions: transactions, totalQuantity: totalQuantity, totalAmount: totalAmount));
      sort();
      filter();

      //total amount has changed, correct payment status button if there is any exist payment record
      if (state.payments.isNotEmpty){
        verifyPaymentStatusButton();
      }
    }
  }

  void deleteTransaction(DocumentTransaction item) async {
    bool result = await useCase.deleteTransaction(item.id!);
    if (result) {
      loadTransactions();
    }
  }

  void onPressedTransaction(DocumentTransaction transaction) {
    emit(state.copyWith(state: OpenSaveGoodState(transaction)));
  }
  void resetSearchText() {
    emit(state.copyWith(textSearch: ""));
    filter();
  }
  void onSearchTextChanged(String newValue) {
    emit(state.copyWith(textSearch: newValue));
    filter();
  }

  void filter() {
    List<DocumentTransaction> transactions =
        state.allTransactions.where((element) => filterTransaction(element)).toList();
    emit(state.copyWith(transactions: transactions));
  }

  bool filterTransaction(DocumentTransaction item) {
    if (state.textSearch.trim().isEmpty) {
      return true;
    }
    return item.good.name.contains(state.textSearch) ||
        item.good.description.contains(state.textSearch) ||
        (item.good.barCode != null && item.good.barCode!.contains(state.textSearch));
  }

  void onSortByMenuClicked() {
    emit(state.copyWith(state: OpenSortDialogListState()));
  }

  void onBatchScanMenuClicked() {
    emit(state.copyWith(state: OpenBarcodeScannerPageState()));
  }

  void onHelpMenuClicked() {
    emit(state.copyWith(state: OpenHelpPageState()));
  }

  void setSettings(SaveDocumentSetting setting) {
    storage.setSaveDocumentSetting(setting);
    emit(state.copyWith(setting: setting));
    sort();
    filter();
  }

  void sort() {
    List<SortTransaction> options = getSortOptions();
    List<DocumentTransaction> items = [];
    items.addAll(state.allTransactions);
    items.sort((item1, item2) {
      int compare = 0;
      for (final option in options) {
        compare = option.getResult(item1, item2);
        if (compare != 0) break;
      }
      return compare;
    });
    emit(state.copyWith(allTransactions: items));
  }

  List<SortTransaction> getSortOptions() {
    List<SortTransaction> options = [];
    switch (state.setting.sortByName) {
      case SortByText.a_to_z:
        {
          options.add(SortByNameAToZDocumentTransaction());
          break;
        }
      case SortByText.z_to_a:
        {
          options.add(SortByNameZToADocumentTransaction());
          break;
        }
      case SortByText.no_sort:
        break;
    }
    switch (state.setting.sortByBarcode) {
      case SortByNumber.ascending:
        {
          options.add(SortByBarCodeAscendingDocumentTransaction());
          break;
        }
      case SortByNumber.descending:
        {
          options.add(SortByBarCodeDescendingDocumentTransaction());
          break;
        }
      case SortByNumber.no_sort:
        break;
    }
    switch (state.setting.sortByQuantity) {
      case SortByNumber.ascending:
        {
          options.add(SortByQuantityAscendingDocumentTransaction());
          break;
        }
      case SortByNumber.descending:
        {
          options.add(SortByQuantityDescendingDocumentTransaction());
          break;
        }
      case SortByNumber.no_sort:
        break;
    }
    if (options.isEmpty){
      options.add(SortByCreatedDateDocumentTransaction());
    }
    return options;
  }
  void updateDocument(Document item){
    emit(state.copyWith(item: item));
  }
  void findGood(String barcode) async{
    try{
      Good good = await goodUseCases.getGoodsByBarCode(barcode);
      if (storage.getBatchModeScan() == BatchModeScan.MANUAL){
        emit(state.copyWith(state: OpenInputQuantityDialogState(good)));
      }else{
        saveThenAddTransaction(good, 1, state.item!.type == DocumentType.incoming ? good.purchasePrice : good.salePrice);
        onBatchScanMenuClicked();
      }

    }catch(e){
      emit(state.copyWith(state: OpenSaveGoodPageWithBarcodeState(barcode)));
    }
  }

  void saveThenAddTransaction(Good good, double quantity, double? price) async{
    bool result = await save();
    if (result){
      DocumentTransaction transaction = DocumentTransaction();
      transaction.documentId = state.item!.id!;
      transaction.goodId = good.id!;
      transaction.quantity = quantity;
      transaction.price = price;
      transaction.type = state.item!.type;
      transaction.storeId = storage.getSelectedStoreId();
      await useCase.insertTransaction(transaction);
      loadTransactions();
    }
  }
  void onSearchBarcodeClicked(){
    emit(state.copyWith(state: OpenBarcodeScannerToSearchState()));
  }

  onPaymentStatusChanged(PaymentStatus status) {
    emit(state.copyWith(paymentStatus: status));
  }
  void onPaymentStatusButtonPressed() async{
    if (state.payments.isNotEmpty){
      emit(state.copyWith(state: OpenPaymentListPageState()));
    }else{
      emit(state.copyWith(state: OpenChangePaymentDialogState()));
    }
  }
}
