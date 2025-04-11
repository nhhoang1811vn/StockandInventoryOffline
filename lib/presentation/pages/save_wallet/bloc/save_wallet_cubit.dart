import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/payment_category.dart';
import 'package:good_manager/domain/entities/wallet.dart';
import 'package:good_manager/domain/usecases/payment_category/payment_category_usercases.dart';
import 'package:good_manager/domain/usecases/wallets/wallet_usecases.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/models/name.dart';
import '../../base/base_state.dart';

part 'save_wallet_cubit.freezed.dart';
part 'save_wallet_state.dart';

@injectable
class SaveWalletCubit extends Cubit<SaveWalletState>{
  final WalletUseCases useCase;
  SaveWalletCubit({required this.useCase}) : super(SaveWalletState.initial(state: InitialState()));

  void init(Wallet item) {
    SaveWalletState initState;
    initState = state.copyWith(item: item,
        name: NameInput.dirty(value: item.name),
        description: item.description,
        color: Color(item.color)
    );
    emit(initState);
  }
  void descriptionChanged(String value){
    emit(state.copyWith(description: value));
  }
  void nameChanged(String value){
    emit(state.copyWith(name: NameInput.dirty(value: value)));
  }
  void onColorChanged(Color color){
    emit(state.copyWith(state: UpdateItemState(),color: color));
  }
  void onSaveClicked() async {
    final validate = Formz.validate([state.name]);
    if (validate){
      Wallet item = state.item!;
      item.name = state.name.value;
      item.description = state.description;
      item.color = state.color!.value;
      if (item.id == null){
        int id = await useCase.insert(item);
        item.id = id;
      }else{
        await useCase.update(item);
      }
      emit(state.copyWith(state: SaveItemSuccessful(), item: item));
    }
  }
}