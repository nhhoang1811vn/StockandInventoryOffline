import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entity/entity.dart';
import '../../base/base_state.dart';

part 'save_payment_category_cubit.freezed.dart';
part 'save_payment_category_state.dart';

@injectable
class SavePaymentCategoryCubit extends Cubit<SavePaymentCategoryState> {
  final PaymentCategoryUseCases useCase;

  SavePaymentCategoryCubit({required this.useCase})
      : super(SavePaymentCategoryState.initial(state: InitialState()));

  void init(PaymentCategory item) {
    SavePaymentCategoryState initState;
    initState = state.copyWith(
      item: item,
      name: (item.name.isNotEmpty)
          ? NameInput.dirty(value: item.name)
          : NameInput.pure(),
      description: item.description,
      icon: item.icon,
    );
    emit(initState);
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: NameInput.dirty(value: value)));
  }

  void onIconChanged(String icon) {
    emit(state.copyWith(state: UpdateItemState(), icon: icon));
  }

  void onSaveClicked() async {
    final validate = Formz.validate([state.name]);
    if (validate) {
      PaymentCategory item = state.item!;
      item.name = state.name.value;
      item.description = state.description;
      item.icon = state.icon!;
      //item.color = state.color!.value;
      if (item.id == null) {
        int id = await useCase.insert(item);
        item.id = id;
      } else {
        await useCase.update(item);
      }
      if (isClosed) return;
      emit(state.copyWith(state: SaveItemSuccessful(), item: item));
    } else {
      emit(state.copyWith(name: NameInput.dirty(value: state.name.value)));
    }
  }
}
