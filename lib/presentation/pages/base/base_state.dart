import 'package:good_manager/domain/entities/group.dart';

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
class AddGoodState extends BaseState{
  late Good item;
  AddGoodState(this.item);
}
class AddGroupState extends BaseState{
  late Group item;
  AddGroupState(this.item);
}
//supplier
class EditSupplierState extends BaseState{
  late Supplier item;
  EditSupplierState(this.item);
}
class AddSupplierState extends BaseState{

}