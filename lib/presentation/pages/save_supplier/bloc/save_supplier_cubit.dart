import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/app/main.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/models/email.dart';
import '../../../../domain/entities/models/name.dart';
import '../../../../domain/usecases/suppliers/suppliers_usecases.dart';

part 'save_supplier_cubit.freezed.dart';
part 'save_supplier_state.dart';

@injectable
class SaveSupplierCubit extends Cubit<SaveSupplierState> {
  final SuppliersUseCase useCase;
  SaveSupplierCubit({required this.useCase}) : super(const SaveSupplierState.initial());

  void init(Supplier? item){
    if (item != null){
      emit(state.copyWith(item: item));
    }
  }

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
        Supplier item;
        if (state.item == null){
          item = Supplier();
        }else{
          item = state.item!;
        }
        item.name = state.name.value;
        item.description = state.description;
        item.address = state.address;
        item.email = state.email.value;
        item.phone = state.phone;
        item.taxID = state.taxID;
        item.bankDetail = state.bankDetails;
        item.storeId = storage.getSelectedStoreId();
        if (item.id == -1){
          await useCase.insert(item);
        }else{
          await useCase.update(item);
        }
        emit(state.copyWith(status: FormzSubmissionStatus.success, item: item));
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
