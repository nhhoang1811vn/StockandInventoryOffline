import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/usecases/customers/customers_usecases.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/models/name.dart';
import '../../base/base_state.dart';

part 'save_customer_cubit.freezed.dart';
part 'save_customer_state.dart';

@injectable
class SaveCustomerCubit extends Cubit<SaveCustomerState> {
  final CustomersUseCase useCase;
  SaveCustomerCubit({required this.useCase}) : super(SaveCustomerState.initial(state: InitialState()));

  void init(Customer item){
    SaveCustomerState initState;
      if (item.id == null){
        initState = state.copyWith(item: item);
      }else{
        initState = state.copyWith(item: item,
            name: NameInput.dirty(value: item.name),
            description: item.description,
            address: item.address,
            email: item.email,
            phone: item.phone,
            taxID: item.taxID,
            bankDetails: item.bankDetail
        );
      }
      emit(initState);
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
    //final email = Email.dirty(value: value);
    emit(state.copyWith(email: value));
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
        //emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
        Customer item = state.item!;
        item.name = state.name.value;
        item.description = state.description;
        item.address = state.address;
        item.email = state.email;
        item.phone = state.phone;
        item.taxID = state.taxID;
        item.bankDetail = state.bankDetails;
        if (item.id == null){
          await useCase.insert(item);
        }else{
          await useCase.update(item);
        }
        emit(state.copyWith(state: SaveItemSuccessful()));
      } catch(error){
        emit(state.copyWith(state: SaveItemError(error.toString())));
      }
    }else{
      emit(state.copyWith(name: NameInput.dirty(value : state.name.value)));
    }
  }
}
