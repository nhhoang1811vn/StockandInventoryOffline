import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entity/entity.dart';
import '../../base/base_state.dart';

part 'save_store_cubit.freezed.dart';
part 'save_store_state.dart';

@injectable
class SaveStoreCubit extends Cubit<SaveStoreState> {
  final StoresUseCase useCase;

  SaveStoreCubit({required this.useCase})
      : super(SaveStoreState.initial(state: InitialState()));

  void init(Store item) {
    SaveStoreState initState;
    if (item.id == null) {
      initState = state.copyWith(item: item);
    } else {
      initState = state.copyWith(
        item: item,
        name: NameInput.dirty(value: item.name),
        description: item.description,
      );
    }
    emit(initState);
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

  void onSaveClicked() async {
    final validate = Formz.validate([state.name]);
    if (validate) {
      try {
        Store item = state.item!;
        item.name = state.name.value;
        item.description = state.description;
        if (item.id == null) {
          await useCase.insert(item);
        } else {
          await useCase.update(item);
          //if (item.id == storage.getSelectedStoreId()){
          //  storage.setSelectedStoreName(item.name);
          //}
        }
        emit(state.copyWith(state: SaveItemSuccessful(), item: item));
      } catch (error) {
        emit(state.copyWith(state: SaveItemError(error.toString())));
      }
    } else {
      emit(state.copyWith(name: NameInput.dirty(value: state.name.value)));
    }
  }
}
