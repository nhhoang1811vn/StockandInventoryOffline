import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entity/entity.dart';

part 'save_group_cubit.freezed.dart';
part 'save_group_state.dart';

@injectable
class SaveGroupCubit extends Cubit<SaveGroupState> {
  final GroupsUseCases useCase;

  SaveGroupCubit({required this.useCase})
      : super(SaveGroupState.initial(state: InitialState()));

  void init(Group item) {
    SaveGroupState initState;
    if (item.id == null) {
      initState = state.copyWith(item: item);
    } else {
      initState = state.copyWith(
        item: item,
        name: NameInput.dirty(value: item.name),
        description: item.description,
        barCode: item.barCode ?? '',
        files: item.files,
      );
    }
    emit(initState);
  }

  void onSaveClicked() async {
    final validate = Formz.validate([state.name]);
    if (validate) {
      try {
        Group item = state.item!;
        item.name = state.name.value;
        item.description = state.description;
        //if (state.barCode.trim().isNotEmpty){
        //  item.barCode = state.barCode.trim();
        //}

        item.barCode = state.barCode;
        item.files = state.files;
        if (item.id == null) {
          await useCase.insert(item);
        } else {
          await useCase.update(item);
        }
        emit(state.copyWith(state: SaveItemSuccessful()));
      } catch (e) {
        if (e.toString().contains("UNIQUE constraint failed: Groups.barCode")) {
          emit(state.copyWith(state: SaveItemSameBarcodeError()));
        } else {
          emit(state.copyWith(state: SaveItemError(e.toString())));
        }
      }
    } else {
      emit(state.copyWith(name: NameInput.dirty(value: state.name.value)));
    }
  }

  void nameChanged(String value) {
    final name = NameInput.dirty(value: value);
    emit(state.copyWith(name: name));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  void barCodeChanged(String value) {
    emit(state.copyWith(barCode: value));
  }

  void onImagesChanged(List<String> value) {
    emit(state.copyWith(files: value));
  }

  void onBarcodeScannerPressed() {
    emit(state.copyWith(state: OpenBarcodeScannerPageState()));
  }
}
