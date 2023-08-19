import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/usecases/payment/payment_usercases.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/entities/payment.dart';

part 'save_payment_cubit.freezed.dart';
part 'save_payment_state.dart';

@injectable
class SavePaymentCubit extends Cubit<SavePaymentState> {
  final PaymentUseCases useCase;
  SavePaymentCubit({required this.useCase}) : super(SavePaymentState.initial(state: InitialState()));

  void init(Payment item) {
    SavePaymentState initState;
    if (item.id == null) {
      initState = state.copyWith(item: item, date: DateTime.now());
    } else {
      initState = state.copyWith(item: item,
          description: item.description,
          amount: item.amount,
          date: item.date
      );
    }
    emit(initState);
  }
  void descriptionChanged(String value){
    emit(state.copyWith(description: value));
  }
  void amountChanged(String value){
    if (value.isNotEmpty){
      emit(state.copyWith(amount: double.parse(value)));
    }
  }
  void dateChanged(DateTime date) {
    emit(state.copyWith(date: date));
  }
  void onSaveClicked() async {
      Payment item = state.item!;
      item.description = state.description;
      item.date = state.date!;
      item.amount = state.amount;
      if (item.id == null){
        await useCase.insert(item);
      }else{
        await useCase.update(item);
      }
      //Future.delayed(Duration(seconds: 2));
      emit(state.copyWith(state: SaveItemSuccessful()));
  }
}