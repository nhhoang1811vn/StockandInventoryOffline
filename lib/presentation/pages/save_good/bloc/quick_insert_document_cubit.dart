import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../constant/constant.dart';

part 'quick_insert_document_cubit.freezed.dart';
part 'quick_insert_document_state.dart';

@injectable
class QuickInsertDocumentCubit extends Cubit<QuickInsertDocumentState> {
  QuickInsertDocumentCubit()
      : super(
          QuickInsertDocumentState.initial(
            state: InitialState(),
            date: DateTime.now(),
          ),
        );

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
      num priceNum = Config.currencyFormat.parse(value);
      double price = priceNum.toDouble();
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

  void dateChanged(DateTime date) {
    emit(state.copyWith(date: date));
  }

  void onPersonChanged(int id) {
    emit(state.copyWith(personId: id));
  }

  void onPersonNameChanged(String name) {
    emit(state.copyWith(personName: name));
  }

  void onPersonClicked() {
    emit(state.copyWith(state: OpenPersonListState()));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }
}
