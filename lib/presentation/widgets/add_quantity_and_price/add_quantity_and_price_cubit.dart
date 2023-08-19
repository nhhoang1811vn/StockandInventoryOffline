import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:injectable/injectable.dart';

import '../../pages/base/base_state.dart';

part 'add_quantity_and_price_cubit.freezed.dart';
part 'add_quantity_and_price_state.dart';

@injectable
class AddQuantityAndPriceCubit extends Cubit<AddQuantityAndPriceState> {

  AddQuantityAndPriceCubit() : super(AddQuantityAndPriceState.initial(state: InitialState()));

  void onQuantityChanged(String value){
    int? quantity = int.tryParse(value);
    if (quantity != null){
      double amount = quantity * state.price;
      emit(state.copyWith(quantity: quantity, amount: amount));
    }else{
      double amount = 0 * state.price;
      emit(state.copyWith(quantity: 0, amount: amount));
    }

  }
  void onPriceChanged(String value){
    if (value.isNotEmpty){
      num priceNum = Config.currencyFormat.parse(value);
      double price = priceNum.toDouble();
      double amount = state.quantity * price;
      emit(state.copyWith(price: price, amount: amount));
    }else{
      emit(state.copyWith(price: 0, amount: 0));
    }
  }

  void initState() {
    emit(state.copyWith(quantity: 1));
  }
  void onQuantityCalculatorPressed(){
    emit(state.copyWith(state: OpenCalculatorToInputQuantityState()));
  }
  void onPriceCalculatorPressed(){
    emit(state.copyWith(state: OpenCalculatorToInputPriceState()));
  }
}