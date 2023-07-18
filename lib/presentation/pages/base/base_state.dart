import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/entities/store.dart';

import '../../../domain/entities/good.dart';
import '../../../domain/entities/supplier.dart';

abstract class BaseState {}
class InitialState extends BaseState {}
class LoadingState extends BaseState {}

class OpenSaveItemState extends BaseState {

}
class OpenHelpPageState extends BaseState {}
class OpenSortDialogListState extends BaseState {}
//goods
class SaveGoodState extends BaseState{
  late Good item;
  SaveGoodState(this.item);
}
class AddGroupState extends BaseState{
  late Group item;
  AddGroupState(this.item);
}
class InsertTransactionSuccessState extends BaseState{

}
class InsertTransactionFailedState extends BaseState{

}
//supplier
class SaveSupplierState extends BaseState{
  late Supplier item;
  SaveSupplierState(this.item);
}
//Expenses
class SaveExpenseState extends BaseState{
  late Expense item;
  SaveExpenseState(this.item);
}
//Document
class OpenSupplierListState extends BaseState{

}
class OpenCustomerListState extends BaseState{

}
class OpenGoodListState extends BaseState{

}
//Stores
class SaveStoreState extends BaseState{
  late Store item;
  SaveStoreState(this.item);
}