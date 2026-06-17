import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entity/entity.dart';
import '../../base/base_state.dart';

part 'payment_categories_cubit.freezed.dart';
part 'payment_categories_state.dart';

@injectable
class PaymentCategoriesCubit extends Cubit<PaymentCategoriesState> {
  final PaymentCategoryUseCases paymentCategoryUseCases;

  PaymentCategoriesCubit({required this.paymentCategoryUseCases})
      : super(PaymentCategoriesState.initial(state: InitialState()));

  void init() {
    emit(state.copyWith(state: LoadingState()));
    loadItems();
  }

  void loadItems() async {
    List<PaymentCategory> categories = await paymentCategoryUseCases.getAll();
    if (isClosed) return;
    List<PaymentCategory> inboundCategories = categories
        .where((category) => category.type == PaymentType.inbound)
        .toList();
    List<PaymentCategory> outboundCategories = categories
        .where((category) => category.type == PaymentType.outbound)
        .toList();
    emit(
      state.copyWith(
        state: LoadSuccessState(),
        inboundCategories: inboundCategories,
        outboundCategories: outboundCategories,
      ),
    );
  }

  void deleteCategory(int id) async {
    await paymentCategoryUseCases.delete(id);
    loadItems();
  }
}
