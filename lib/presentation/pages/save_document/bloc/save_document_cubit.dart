import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/save_document/sort/sort_by_barcode_document_transaction.dart';
import 'package:good_manager/presentation/pages/save_document/sort/sort_by_quantity_document_transaction.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../util/quantity_format.dart';
import '../sort/sort_by_created_date_document_transaction.dart';
import '../sort/sort_by_name_document_transaction.dart';
import '../sort/sort_transaction.dart';

part 'save_document_cubit.freezed.dart';
part 'save_document_state.dart';

@injectable
class SaveDocumentCubit extends Cubit<SaveDocumentState> {
  final DocumentUseCases useCase;
  final PaymentUseCases paymentUseCase;
  final GoodsUseCases goodUseCases;

  SaveDocumentCubit({
    required this.useCase,
    required this.paymentUseCase,
    required this.goodUseCases,
  }) : super(
          SaveDocumentState.initial(
            state: InitialState(),
            setting: AppSettings.getSaveDocumentSetting(),
          ),
        );

  void init(Document item) {
    SaveDocumentState initState = state.copyWith(
      item: item,
      name: NameInput.dirty(value: item.name),
      description: item.description,
      date: item.date,
      personId: item.personId,
      personName: item.personName,
      //paymentStatus: item.paymentStatus
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

  //DateTime getDateOnly(DateTime dateTime){
  //  return DateTime(dateTime.year, dateTime.month, dateTime.day);
  //}
  Future<bool> save() async {
    final validate = Formz.validate([state.name]);
    if (validate) {
      Document item = state.item!;
      item.name = state.name.value;
      item.description = state.description;
      //item.date = getDateOnly(state.date!);
      item.date = state.date!;
      item.personId = state.personId;
      if (item.id == null) {
        int id = await useCase.insert(item);
        item.id = id;
      } else {
        await useCase.update(item);
      }
      if (isClosed) return true;
      emit(state.copyWith(item: item));
      return true;
    } else {
      emit(state.copyWith(name: NameInput.dirty(value: state.name.value)));
      return false;
    }
  }

  void onAddGoodClicked() async {
    final result = await save();
    if (isClosed) return;
    if (result) {
      emit(state.copyWith(state: OpenGoodListState()));
    }
  }

  void onSaveMenuClicked() async {
    bool result = await save();
    if (isClosed) return;
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

  void onPersonClicked() {
    emit(state.copyWith(state: OpenPersonListState()));
  }

  void onPersonChanged(int id) {
    emit(state.copyWith(personId: id));
  }

  void onPersonNameChanged(String name) {
    emit(state.copyWith(personName: name));
  }

  void loadPayments() async {
    List<Payment> payments =
        await paymentUseCase.getByDocumentId(state.item!.id!);
    if (isClosed) return;
    emit(state.copyWith(payments: payments));
  }

  double getTotalPayments(List<Payment> payments) {
    double total = 0.0;
    payments.forEach((element) {
      total += element.amount ?? 0;
    });
    return total;
  }

  void loadTransactions() async {
    if (state.item?.id != null) {
      List<DocumentTransaction> transactions =
          await useCase.getTransactionsByDocumentId(state.item!.id!);
      if (isClosed) return;
      double totalQuantity = 0.0;
      double totalAmount = 0.0;
      transactions.forEach((element) {
        totalQuantity += element.quantity;
        totalAmount += (element.quantity * (element.price ?? 0.0));
      });
      totalQuantity =
          roundQuantity(totalQuantity, AppSettings.getQuantityDecimals());
      emit(
        state.copyWith(
          allTransactions: transactions,
          totalQuantity: totalQuantity,
          totalAmount: totalAmount,
        ),
      );
      sort();
      filter();
    }
  }

  void deleteTransaction(DocumentTransaction item) async {
    bool result = await useCase.deleteTransaction(item.id!);
    if (isClosed) return;
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
    if (isClosed) return;
    List<DocumentTransaction> transactions = state.allTransactions
        .where((element) => filterTransaction(element))
        .toList();
    emit(state.copyWith(transactions: transactions));
  }

  bool filterTransaction(DocumentTransaction item) {
    if (state.textSearch.trim().isEmpty) {
      return true;
    }
    final query = state.textSearch.toLowerCase();
    return item.good.name.toLowerCase().contains(query) ||
        item.good.description.toLowerCase().contains(query) ||
        (item.good.barCode != null &&
            item.good.barCode!.toLowerCase().contains(query));
  }

  void onBatchScanMenuClicked() {
    emit(state.copyWith(state: OpenBarcodeScannerPageState()));
  }

  void onHelpMenuClicked() {
    emit(state.copyWith(state: OpenHelpPageState()));
  }

  void sort() {
    if (isClosed) return;
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
    if (options.isEmpty) {
      options.add(SortByCreatedDateDocumentTransaction());
    }
    return options;
  }

  void updateDocument(Document item) {
    emit(state.copyWith(item: item));
  }

  void findGood(String barcode) async {
    try {
      Good good = await goodUseCases.getGoodsByBarCode(barcode);
      if (isClosed) return;
      if (AppSettings.getBatchModeScan() == BatchModeScan.MANUAL) {
        emit(state.copyWith(state: OpenInputQuantityDialogState(good)));
      } else {
        saveThenAddTransaction(
          good,
          1,
          AppSettings.getGoodPropertiesSettings()
              .defaultPriceFor(good, state.item!.type),
        );
        await Future.delayed(
          Duration(milliseconds: AppSettings.getBatchScanDelayMs()),
        );
        if (isClosed) return;
        onBatchScanMenuClicked();
      }
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(state: OpenSaveGoodPageWithBarcodeState(barcode)));
    }
  }

  void saveThenAddTransaction(Good good, double quantity, double? price) async {
    bool result = await save();
    if (isClosed) return;
    if (result) {
      DocumentTransaction transaction = DocumentTransaction();
      transaction.documentId = state.item!.id!;
      transaction.goodId = good.id!;
      transaction.quantity = quantity;
      transaction.price = price;
      transaction.type = state.item!.type;
      transaction.storeId = AppSettings.getSelectedStoreId();
      await useCase.insertTransaction(transaction);
      if (isClosed) return;
      loadTransactions();
    }
  }

  MyCompany? getMyCompany() {
    return AppSettings.getMyCompany();
  }

  void resetAllFilter() {
    applyFilter(SaveDocumentSetting.getDefault());
  }

  void applyFilter(SaveDocumentSetting setting) {
    emit(state.copyWith(setting: setting));
    AppSettings.setSaveDocumentSetting(setting);
    sort();
    filter();
  }

  int getSelectedStoreId() {
    return AppSettings.getSelectedStoreId();
  }
}
