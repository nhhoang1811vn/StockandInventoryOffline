import '../../../domain/entity/entity.dart';
import '../../../domain/exception/insufficient_stock_exception.dart';

abstract class BaseState {}

class InitialState extends BaseState {}

class LoadingState extends BaseState {}

class LoadSuccessState extends BaseState {}

class OpenSaveItemState extends BaseState {}

class OpenHelpPageState extends BaseState {}

class OpenBuySubscriptionDialogState extends BaseState {}

class OpenListSettingsDialogState extends BaseState {}

//goods
class OpenSaveGoodPageState extends BaseState {
  late Good item;

  OpenSaveGoodPageState(this.item);
}

class AddGroupState extends BaseState {
  late Group item;

  AddGroupState(this.item);
}

class InsertTransactionSuccessState extends BaseState {
  late int goodId;
  late double quantity;

  InsertTransactionSuccessState(this.goodId, this.quantity);
}

class InsertTransactionFailedState extends BaseState {}

class OpenReceiveGoodsPopupState extends BaseState {}

class OpenIssueGoodsPopupState extends BaseState {}

class UpdateItemState extends BaseState {}

class OpenHistoryPageState extends BaseState {}

//supplier
class OpenSaveSupplierPageState extends BaseState {
  late Supplier item;

  OpenSaveSupplierPageState(this.item);
}

//customer
class OpenSaveCustomerPageState extends BaseState {
  late Customer item;

  OpenSaveCustomerPageState(this.item);
}

//wallet
class OpenSaveWalletPageState extends BaseState {
  late Wallet item;

  OpenSaveWalletPageState(this.item);
}

//Expenses
class OpenSaveExpensePageState extends BaseState {
  late Expense item;

  OpenSaveExpensePageState(this.item);
}

//Payments
class OpenSavePaymentPageState extends BaseState {
  late Payment item;

  OpenSavePaymentPageState(this.item);
}

class OpenPaymentHistoryPageState extends BaseState {
  final int documentId;

  OpenPaymentHistoryPageState(this.documentId);
}

class OpenDocumentListState extends BaseState {
  OpenDocumentListState();
}

//Document
class OpenPersonListState extends BaseState {}

class OpenGoodListState extends BaseState {}

class SaveDocumentSuccessfulState extends BaseState {
  late Document item;

  SaveDocumentSuccessfulState(this.item);
}

class SaveDocumentFailedState extends BaseState {}

class OpenSaveGoodState extends BaseState {
  late DocumentTransaction item;

  OpenSaveGoodState(this.item);
}

//Stores
class OpenSaveStorePageState extends BaseState {
  late Store item;

  OpenSaveStorePageState(this.item);
}

class OpenCalculatorToInputQuantityState extends BaseState {}

class OpenCalculatorToInputPriceState extends BaseState {}

class OpenCalculatorToInputPurchasePriceState extends BaseState {}

class OpenCalculatorToInputSalePriceState extends BaseState {}

class OpenBarcodeScannerPageState extends BaseState {}

//commons
class SaveItemSuccessful extends BaseState {}

class SaveItemError extends BaseState {
  late String error;

  SaveItemError(this.error);
}

class SaveItemSameBarcodeError extends BaseState {}

class SaveItemSameGroupNameError extends BaseState {}

class DeleteItemError extends BaseState {}

/// A transaction change was rejected because it would make a Good's stock
/// negative while "Allow negative quantity in stock" is off.
class InsufficientStockError extends BaseState {
  final InsufficientStockException error;

  InsufficientStockError(this.error);
}

class OpenSaveGoodPageWithBarcodeState extends BaseState {
  late String barcode;

  OpenSaveGoodPageWithBarcodeState(this.barcode);
}

class OpenInputQuantityDialogState extends BaseState {
  late Good good;

  OpenInputQuantityDialogState(this.good);
}
//class OpenBarcodeScannerToSearchState extends BaseState{

//}
