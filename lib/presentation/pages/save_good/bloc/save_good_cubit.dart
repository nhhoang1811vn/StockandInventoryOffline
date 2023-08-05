import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/usecases/goods/goods_usercases.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/models/name.dart';
import '../../base/base_state.dart';

part 'save_good_cubit.freezed.dart';
part 'save_good_state.dart';

@injectable
class SaveGoodCubit extends Cubit<SaveGoodState>{
  final GoodsUseCases useCase;
  SaveGoodCubit({required this.useCase}) : super(SaveGoodState.initial(state: InitialState()));
  void init(Good item, int quantity){
    SaveGoodState initState;
    if (item.id == -1){
      initState = state.copyWith(item: item, quantity: quantity);
    }else{
      initState = state.copyWith(item: item,
          name: NameInput.dirty(value: item.name),
          description: item.description,
          barCode: item.barCode,
          files: item.files,
          quantity: quantity
      );
    }
    emit(initState);
  }
  void onSaveClicked() async {
    final validate = Formz.validate([state.name]);
    if (validate){
      try{
        Good item = state.item!;
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
      }catch (e){
        emit(state.copyWith(state: SaveItemError(e.toString())));
      }
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
  void onModifyQuantityButtonPressed(){
    emit(state.copyWith(state: OpenCalculatorToInputQuantityState()));
  }

  void quantityChanged(String value) {
    emit(state.copyWith(quantity: int.parse(value)));
  }
}