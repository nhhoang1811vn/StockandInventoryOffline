import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../constant/constant.dart';
import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';

part 'save_payment_cubit.freezed.dart';
part 'save_payment_state.dart';

@injectable
class SavePaymentCubit extends Cubit<SavePaymentState> {
  final PaymentUseCases useCase;
  final PaymentCategoryUseCases paymentCategoryUseCases;
  final WalletUseCases walletUseCases;
  final CustomersUseCase customersUseCase;
  final SuppliersUseCase suppliersUseCase;

  SavePaymentCubit({
    required this.useCase,
    required this.paymentCategoryUseCases,
    required this.walletUseCases,
    required this.customersUseCase,
    required this.suppliersUseCase,
  }) : super(SavePaymentState.initial(state: InitialState()));

  void init(Payment item) async {
    var allCategories = await paymentCategoryUseCases.getAll();
    var categories =
        allCategories.where((category) => category.type == item.type).toList();
    PaymentCategory? selectedCategory = categories.firstWhereOrNull(
      (category) => category.id == item.categoryId,
    );
    int storeId = AppSettings.getSelectedStoreId();
    var wallets = await walletUseCases.getAllByStoreId(storeId);
    Wallet? selectedWallet =
        wallets.firstWhereOrNull((wallet) => wallet.id == item.walletId);
    emit(
      state.copyWith(
        state: UpdateItemState(),
        categories: categories,
        selectedCategory: selectedCategory,
        wallets: wallets,
        selectedWallet: selectedWallet,
        item: item,
        description: item.description,
        documentId: item.documentId,
        document: item.document,
        supplierId: item.supplierId,
        supplier: item.supplier,
        customerId: item.customerId,
        customer: item.customer,
        amount: item.amount,
        date: item.date,
      ),
    );
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  void onDocumentChanged(Document item) async {
    emit(
      state.copyWith(
        documentId: null,
        document: null,
        customerId: null,
        customer: null,
        supplierId: null,
        supplier: null,
      ),
    );
    emit(state.copyWith(documentId: item.id, document: item));

    if (state.item!.type == PaymentType.inbound) {
      if (item.personId != null) {
        Customer customer = await customersUseCase.get(item.personId!);
        emit(state.copyWith(customerId: item.personId, customer: customer));
      }
    } else {
      if (item.personId != null) {
        Supplier supplier = await suppliersUseCase.get(item.personId!);
        emit(state.copyWith(supplierId: item.personId, supplier: supplier));
      }
    }
  }

  void onCancelDocument() {
    emit(
      state.copyWith(
        documentId: null,
        document: null,
        customerId: null,
        customer: null,
        supplierId: null,
        supplier: null,
      ),
    );
  }

  void onCancelPerson() {
    emit(
      state.copyWith(
        documentId: null,
        document: null,
        customerId: null,
        customer: null,
        supplierId: null,
        supplier: null,
      ),
    );
  }

  void onSupplierChanged(Supplier item) {
    emit(
      state.copyWith(
        documentId: null,
        document: null,
        customerId: null,
        customer: null,
        supplierId: null,
        supplier: null,
      ),
    );
    emit(state.copyWith(supplierId: item.id, supplier: item));
  }

  void onCustomerChanged(Customer item) {
    emit(
      state.copyWith(
        documentId: null,
        document: null,
        customerId: null,
        customer: null,
        supplierId: null,
        supplier: null,
      ),
    );
    emit(state.copyWith(customerId: item.id, customer: item));
  }

  void onSelectDocument() {
    emit(state.copyWith(state: OpenDocumentListState()));
  }

  void onSelectPerson() {
    emit(state.copyWith(state: OpenPersonListState()));
  }

  void onAmountChanged(String value) {
    if (value.isNotEmpty) {
      num amountNum = Config.simpleCurrencyFormat.parse(value);
      double amount = amountNum.toDouble();
      emit(state.copyWith(amount: amount));
    } else {
      emit(state.copyWith(amount: null));
    }
  }

  void dateChanged(DateTime date) {
    emit(state.copyWith(date: date));
  }

  void onSaveClicked() async {
    Payment item = state.item!;
    item.description = state.description;
    item.date = state.date!;
    item.amount = state.amount;
    item.documentId = state.documentId;
    item.categoryId = state.selectedCategory?.id;
    item.walletId = state.selectedWallet?.id;
    item.supplierId = state.supplierId;
    item.customerId = state.customerId;

    if (item.id == null) {
      await useCase.insert(item);
    } else {
      await useCase.update(item);
    }
    AppSettings.setSavePaymentLastSelectedWalletId(item.walletId);
    emit(state.copyWith(state: SaveItemSuccessful()));
  }

  void resetState() {
    emit(state.copyWith(state: InitialState()));
  }

  void onCategoryChanged(PaymentCategory item) {
    emit(state.copyWith(state: UpdateItemState(), selectedCategory: item));
  }

  void onWalletChanged(Wallet item) {
    emit(state.copyWith(state: UpdateItemState(), selectedWallet: item));
  }

  void onRefreshCategories() async {
    var allCategories = await paymentCategoryUseCases.getAll();
    var categories = allCategories
        .where((category) => category.type == state.item!.type)
        .toList();

    PaymentCategory? selectedCategory = categories.firstWhereOrNull(
      (category) => category.id == state.selectedCategory?.id,
    );
    emit(
      state.copyWith(
        categories: categories,
        selectedCategory: selectedCategory,
      ),
    );
  }

  void onRefreshWallets() async {
    int storeId = AppSettings.getSelectedStoreId();
    var wallets = await walletUseCases.getAllByStoreId(storeId);
    //var categories = allCategories.where((category) => category.type == state.item!.type).toList();

    Wallet? selectedWallet = wallets.firstWhereOrNull(
      (wallet) => wallet.id == state.selectedWallet?.id,
    );
    emit(state.copyWith(wallets: wallets, selectedWallet: selectedWallet));
  }

  int getSelectedStoreId() {
    return AppSettings.getSelectedStoreId();
  }
}
