import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../constant/constant.dart';
import '../../pages/base/base_state.dart';

part 'add_quantity_and_price_cubit.freezed.dart';
part 'add_quantity_and_price_state.dart';

@injectable
class AddQuantityAndPriceCubit extends Cubit<AddQuantityAndPriceState> {
  AddQuantityAndPriceCubit()
      : super(AddQuantityAndPriceState.initial(state: InitialState()));

  void onQuantityChanged(String value) {
    double? quantity = double.tryParse(value);
    if (quantity != null) {
      if (state.price != null) {
        emit(
          state.copyWith(
            quantity: quantity,
            amount: quantity * state.price!,
          ),
        );
      } else {
        emit(state.copyWith(quantity: quantity));
      }
    } else {
      emit(state.copyWith(quantity: 0, amount: null));
    }
  }

  void onPriceChanged(String value) {
    if (value.isNotEmpty) {
      double price;
      try {
        price = Config.simpleCurrencyFormat.parse(value).toDouble();
      } on FormatException {
        // Unparsable input (e.g. "." or "-"): keep the previous price.
        return;
      }
      if (state.quantity != null) {
        emit(state.copyWith(price: price, amount: state.quantity! * price));
      } else {
        emit(state.copyWith(price: price));
      }
    } else {
      emit(state.copyWith(price: null, amount: null));
    }
  }

  void initState(double quantity, double? price) {
    if (price != null) {
      emit(
        state.copyWith(
          quantity: quantity,
          price: price,
          amount: quantity * price,
        ),
      );
    } else {
      emit(state.copyWith(quantity: quantity, price: price));
    }
  }

  void onQuantityCalculatorPressed() {
    emit(state.copyWith(state: OpenCalculatorToInputQuantityState()));
  }

  void onPriceCalculatorPressed() {
    emit(state.copyWith(state: OpenCalculatorToInputPriceState()));
  }
}
