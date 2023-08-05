import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecases/groups/groups_usecases.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/group.dart';
import '../../../../domain/entities/models/name.dart';

part 'save_group_cubit.freezed.dart';
part 'save_group_state.dart';
@injectable
class SaveGroupCubit extends Cubit<SaveGroupState>{
  final GroupsUseCases useCase;
  SaveGroupCubit({required this.useCase}) : super(SaveGroupState.initial(state: InitialState()));
  void init(Group item){
    SaveGroupState initState;
    if (item.id == -1){
      initState = state.copyWith(item: item);
    }else{
      initState = state.copyWith(item: item,
          name: NameInput.dirty(value: item.name),
          description: item.description,
          barCode: item.barCode,
          files: item.files
      );
    }
    emit(initState);
  }

  void onSaveClicked() async{
    final validate = Formz.validate([state.name]);
    if (validate){
      //emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      Group item = state.item!;
      item.name = state.name.value;
      item.description = state.description;
      item.barCode = state.barCode;
      item.files = state.files;
      if (item.id == -1){
        await useCase.insert(item);
      }else{
        await useCase.update(item);
      }
      emit(state.copyWith(state: SaveItemSuccessful()));
    }else{
      emit(state.copyWith(name: NameInput.dirty(value : state.name.value)));
    }
  }
  void nameChanged(String value){
    final name = NameInput.dirty(value: value);
    emit(state.copyWith(name: name));
  }
  void descriptionChanged(String value){
    emit(state.copyWith(description: value));
  }
  void barCodeChanged(String value){
    emit(state.copyWith(barCode: value));
  }
  void onImagesChanged(List<String> value){
    emit(state.copyWith(files: value));
  }
}