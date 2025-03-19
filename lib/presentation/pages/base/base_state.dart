import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/entities/transaction.dart';

import '../../../domain/entities/good.dart';
import '../../../domain/entities/supplier.dart';

abstract class BaseState {}
class InitialState extends BaseState {}
class LoadingState extends BaseState {}
class LoadSuccessState extends BaseState {}


class OpenSaveItemState extends BaseState {

}
class OpenHelpPageState extends BaseState {}

class OpenListSettingsDialogState extends BaseState {}
class OpenSortDialogListState extends BaseState {}
//goods
class OpenSaveGoodPageState extends BaseState{
  late Good item;
  OpenSaveGoodPageState(this.item);
}
class AddGroupState extends BaseState{
  late Group item;
  AddGroupState(this.item);
}
class InsertTransactionSuccessState extends BaseState{
  late int goodId;
  late double quantity;
  InsertTransactionSuccessState(this.goodId, this.quantity);
}
class InsertTransactionFailedState extends BaseState{

}
class OpenReceiveGoodsPopupState extends BaseState{

}
class OpenIssueGoodsPopupState extends BaseState{

}
class UpdateItemState extends BaseState{

}
class OpenHistoryPageState extends BaseState{

}
//supplier
class OpenSaveSupplierPageState extends BaseState{
  late Supplier item;
  OpenSaveSupplierPageState(this.item);
}
//customer
class OpenSaveCustomerPageState extends BaseState{
  late Customer item;
  OpenSaveCustomerPageState(this.item);
}

//Expenses
class OpenSaveExpensePageState extends BaseState{
  late Expense item;
  OpenSaveExpensePageState(this.item);
}
//Payments
class OpenSavePaymentPageState extends BaseState{
  late Payment item;
  OpenSavePaymentPageState(this.item);
}
class OpenDocumentListState extends BaseState{
  OpenDocumentListState();
}
//Document
class OpenPersonListState extends BaseState{

}

class OpenGoodListState extends BaseState{

}
class SaveDocumentSuccessfulState extends BaseState{
  late Document item;
  SaveDocumentSuccessfulState(this.item);
}
class SaveDocumentFailedState extends BaseState{

}
class OpenSaveGoodState extends BaseState{
  late DocumentTransaction item;
  OpenSaveGoodState(this.item);
}
//Stores
class OpenSaveStorePageState extends BaseState{
  late Store item;
  OpenSaveStorePageState(this.item);
}



class OpenCalculatorToInputQuantityState extends BaseState{

}
class OpenCalculatorToInputPriceState extends BaseState{

}
class OpenCalculatorToInputPurchasePriceState extends BaseState{

}
class OpenCalculatorToInputSalePriceState extends BaseState{

}
class OpenBarcodeScannerPageState extends BaseState{

}
//commons
class SaveItemSuccessful extends BaseState{

}
class SaveItemError extends BaseState{
  late String error;
  SaveItemError(this.error);
}
class SaveItemSameBarcodeError extends BaseState{

}
class DeleteItemError extends BaseState{

}
class OpenSaveGoodPageWithBarcodeState extends BaseState{
  late String barcode;
  OpenSaveGoodPageWithBarcodeState(this.barcode);
}
class OpenInputQuantityDialogState extends BaseState{
  late Good good;
  OpenInputQuantityDialogState(this.good);
}
class OpenBarcodeScannerToSearchState extends BaseState{

}