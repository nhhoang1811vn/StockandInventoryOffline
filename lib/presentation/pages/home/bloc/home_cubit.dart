import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/storage.dart';
import '../../../../domain/usecases/documents/document_usecases.dart';
import '../../../../domain/usecases/expenses/expense_usercases.dart';
import '../../../../domain/usecases/goods/goods_usercases.dart';
import '../../../../domain/usecases/suppliers/suppliers_usecases.dart';
import '../../base/base_state.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final Storage storage;
  final GoodsUseCases goodsUseCases;
  final DocumentUseCases documentsUseCases;
  final SuppliersUseCase supplierUseCases;
  final ExpenseUseCases expenseUseCases;
  HomeCubit({
    required this.storage,
    required this.goodsUseCases,
    required this.documentsUseCases,
    required this.supplierUseCases,
    required this.expenseUseCases
  }) : super(HomeState.initial(state: InitialState()));

  void initState() async{
      int storeId = storage.getSelectedStoreId();
      int countGood = await goodsUseCases.getCount(storeId);
      int countDocument = await documentsUseCases.getCount(storeId);
      int countSupplier = await supplierUseCases.getCount(storeId);
      double sumExpense = await expenseUseCases.getSum(storeId);
      emit(state.copyWith(
          countGood: countGood,
          countDocument: countDocument,
          countSupplier: countSupplier,
          sumExpense: sumExpense
      ));
  }
}
