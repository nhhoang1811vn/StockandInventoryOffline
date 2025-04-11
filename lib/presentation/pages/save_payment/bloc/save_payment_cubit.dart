import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/payment_category.dart';
import 'package:good_manager/domain/entities/wallet.dart';
import 'package:good_manager/domain/usecases/payment/payment_usercases.dart';
import 'package:good_manager/domain/usecases/payment_category/payment_category_usercases.dart';
import 'package:good_manager/domain/usecases/wallets/wallet_usecases.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/models/name.dart';
import '../../../../domain/entities/payment.dart';
import '../../../constants.dart';

part 'save_payment_cubit.freezed.dart';

part 'save_payment_state.dart';

@injectable
class SavePaymentCubit extends Cubit<SavePaymentState> {
  final PaymentUseCases useCase;
  final PaymentCategoryUseCases paymentCategoryUseCases;
  final WalletUseCases walletUseCases;

  SavePaymentCubit({required this.useCase, required this.paymentCategoryUseCases, required this.walletUseCases})
      : super(SavePaymentState.initial(state: InitialState()));

  void init(Payment item) async {
    var allCategories = await paymentCategoryUseCases.getAll();
    var categories = allCategories.where((category) => category.type == item.type).toList();
    PaymentCategory? selectedCategory = categories.firstWhereOrNull(
      (category) => category.id == item.categoryId,
    );
    int storeId = storage.getSelectedStoreId();
    var wallets = await walletUseCases.getAllByStoreId(storeId);
    Wallet? selectedWallet = wallets.firstWhereOrNull((wallet) => wallet.id == item.walletId);
    emit(state.copyWith(
        state: UpdateItemState(),
        categories: categories,
        selectedCategory: selectedCategory,
        wallets: wallets,
        selectedWallet: selectedWallet,
        item: item,
        description: item.description,
        documentId: item.documentId,
        documentName: NameInput.dirty(value: item.document?.name ?? ""),
        amount: item.amount,
        date: item.date));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  void onDocumentChanged(Document item) {
    emit(state.copyWith(state: InitialState(), documentName: NameInput.dirty(value: item.name), documentId: item.id));
  }

  void onDocumentNameClicked() {
    emit(state.copyWith(state: OpenDocumentListState()));
  }

  void onAmountChanged(String value) {
    if (value.isNotEmpty) {
      num amountNum = Config.currencyFormat.parse(value);
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

    if (item.id == null) {
      await useCase.insert(item);
    } else {
      await useCase.update(item);
    }
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
    var categories = allCategories.where((category) => category.type == state.item!.type).toList();

    PaymentCategory? selectedCategory = categories.firstWhereOrNull(
      (category) => category.id == state.selectedCategory?.id,
    );
    emit(state.copyWith(categories: categories, selectedCategory: selectedCategory));
  }
  void onRefreshWallets() async {
    int storeId = storage.getSelectedStoreId();
    var wallets = await walletUseCases.getAllByStoreId(storeId);
    //var categories = allCategories.where((category) => category.type == state.item!.type).toList();

    Wallet? selectedWallet = wallets.firstWhereOrNull(
          (wallet) => wallet.id == state.selectedWallet?.id,
    );
    emit(state.copyWith(wallets: wallets, selectedWallet: selectedWallet));
  }

  void deleteCategory(int id) async {
    await paymentCategoryUseCases.delete(id);
  }
}
