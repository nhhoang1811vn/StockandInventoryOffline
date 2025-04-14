import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/payment_category.dart';
import 'package:good_manager/domain/usecases/documents/document_usecases.dart';
import 'package:good_manager/domain/usecases/payment_category/payment_category_usercases.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/storage.dart';
import '../../../../domain/entities/payment.dart';
import '../../../../domain/usecases/payment/payment_usercases.dart';
import '../../base/base_state.dart';

part 'payment_categories_cubit.freezed.dart';
part 'payment_categories_state.dart';

@injectable
class PaymentCategoriesCubit extends Cubit<PaymentCategoriesState> {

  final PaymentCategoryUseCases paymentCategoryUseCases;
  PaymentCategoriesCubit({

    required this.paymentCategoryUseCases
  }) : super(PaymentCategoriesState.initial(state: InitialState()));
  void init(){
    emit(state.copyWith(state: LoadingState()));
    loadItems();
  }


  void loadItems() async{
    List<PaymentCategory> categories = await paymentCategoryUseCases.getAll();
    List<PaymentCategory> inboundCategories = categories.where((category) => category.type == PaymentType.inbound).toList();
    List<PaymentCategory> outboundCategories = categories.where((category) => category.type == PaymentType.outbound).toList();
    emit(state.copyWith(
        state: LoadSuccessState(),
        inboundCategories: inboundCategories,
        outboundCategories: outboundCategories
    ));
  }
  void deleteCategory(int id) async {
    await paymentCategoryUseCases.delete(id);
  }

  // delete(int id) async{
  //   await useCase.delete(id);
  //   loadItems();
  // }
}
