import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:injectable/injectable.dart';

import '../../../../constant/constant.dart';
import '../../../../domain/entity/entity.dart';
import '../../base/base_state.dart';

part 'save_wallet_cubit.freezed.dart';
part 'save_wallet_state.dart';

@injectable
class SaveWalletCubit extends Cubit<SaveWalletState> {
  final WalletUseCases useCase;
  final PaymentUseCases paymentUseCases;

  SaveWalletCubit({
    required this.useCase,
    required this.paymentUseCases,
  }) : super(SaveWalletState.initial(state: InitialState()));

  void init(Wallet item) {
    SaveWalletState initState;
    initState = state.copyWith(
      item: item,
      name: (item.name.isNotEmpty)
          ? NameInput.dirty(value: item.name)
          : NameInput.pure(),
      description: item.description,
      color: Color(item.color),
    );
    emit(initState);
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: NameInput.dirty(value: value)));
  }

  void onColorChanged(Color color) {
    emit(state.copyWith(state: UpdateItemState(), color: color));
  }

  void onAmountChanged(String value) {
    if (value.isNotEmpty) {
      num amountNum = Config.simpleCurrencyFormat.parse(value);
      double amount = amountNum.toDouble();
      emit(state.copyWith(amount: amount));
    } else {
      emit(state.copyWith(amount: null));
    }
  }

  void onSaveClicked() async {
    final validate = Formz.validate([state.name]);
    if (validate) {
      Wallet item = state.item!;
      item.name = state.name.value;
      item.description = state.description;
      item.color = state.color!.value;
      if (item.id == null) {
        int id = await useCase.insert(item);
        if (state.amount != 0 && state.amount != null) {
          item.id = id;
          var payment = Payment();
          payment.description = "initial amount";
          payment.amount = state.amount;
          payment.date = DateTime.now();
          payment.walletId = id;
          payment.type = PaymentType.inbound;
          payment.storeId = AppSettings.getSelectedStoreId();
          paymentUseCases.insert(payment);
        }
      } else {
        await useCase.update(item);
      }
      emit(state.copyWith(state: SaveItemSuccessful(), item: item));
    } else {
      emit(state.copyWith(name: NameInput.dirty(value: state.name.value)));
    }
  }
}
