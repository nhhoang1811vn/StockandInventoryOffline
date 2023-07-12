import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/entities/models/email.dart';
import '../../../../domain/entities/models/name.dart';
import '../../../../domain/usecases/suppliers/suppliers_usecases.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'save_supplier_cubit.freezed.dart';
part 'save_supplier_state.dart';

@injectable
class SaveSupplierCubit extends Cubit<SaveSupplierState> {
  final SuppliersUseCase useCase;
  SaveSupplierCubit({required this.useCase}) : super(const SaveSupplierState.initial());
  /*TextEditingController addressTextController;
  TextEditingController emailTextController;
  TextEditingController phoneTextController;
  TextEditingController taxIDTextController;
  TextEditingController bankDetailsTextController;*/

  /*SaveSupplierController(repository, item)
      : super(SaveSupplierPresenter(repository), item) {
    addressTextController = TextEditingController();
    emailTextController = TextEditingController();
    phoneTextController = TextEditingController();
    taxIDTextController = TextEditingController();
    bankDetailsTextController = TextEditingController();
    addressTextController.text = item.address;
    emailTextController.text = item.email;
    phoneTextController.text = item.phone;
    taxIDTextController.text = item.taxID;
    bankDetailsTextController.text = item.bankDetail;
  }*/
  /*
  @override
  void updateItem() {
    super.updateItem();
    item.address = addressTextController.text;
    item.email = emailTextController.text;
    item.phone = phoneTextController.text;
    item.taxID = taxIDTextController.text;
    item.bankDetail = bankDetailsTextController.text;
  }

  @override
  Supplier getOriginalItem(Supplier item) {
    Supplier supplier = Supplier();
    supplier.name = item.name;
    supplier.description = item.description;
    supplier.address = item.address;
    supplier.email = item.email;
    supplier.phone = item.phone;
    supplier.taxID = item.taxID;
    supplier.bankDetail = item.bankDetail;

    return supplier;
  }

  @override
  bool hasChanged(Supplier item, Supplier originalItem) {
    return (item.name != originalItem.name ||
        item.description != originalItem.description ||
        item.address != originalItem.address ||
        item.email != originalItem.email ||
        item.phone != originalItem.phone ||
        item.taxID != originalItem.taxID ||
        item.bankDetail != originalItem.bankDetail);
  }*/

  Future<bool> onWillPop() async {
    return true;
  }
  void nameChanged(String value){
    final name = NameInput.dirty(value: value);
    emit(state.copyWith(name: name));
  }
  void descriptionChanged(String value){
    emit(state.copyWith(description: value));
  }
  void addressChanged(String value){
    emit(state.copyWith(address: value));
  }
  void emailChanged(String value){
    final email = Email.dirty(value: value);
    emit(state.copyWith(email: email));
  }
  void phoneChanged(String value){
    emit(state.copyWith(phone: value));
  }
  void taxIDChanged(String value){
    emit(state.copyWith(taxID: value));
  }
  void bankDetailsChanged(String value){
    emit(state.copyWith(bankDetails: value));
  }

  void onSaveClicked() async{
    final validate = Formz.validate([state.name]);
    if (validate){
      try{
        emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
        /*final Supplier item = Supplier();
        item.name = state.name.value;
        item.email = state.email.value;
        await useCase.insert(item);*/
        if (state.isInsert){
          //await useCase.insert(item);
        }else{
          //await useCase.update(item);
        }
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch(error){
        emit(state.copyWith(
            exceptionError: "Unexpected error please try again later",
            status: FormzSubmissionStatus.failure));
      }
    }else{
      emit(state.copyWith(name: NameInput.dirty(value : state.name.value)));
    }
  }
}
