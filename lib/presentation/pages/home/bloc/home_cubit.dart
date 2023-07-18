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
/*

  void openSaveOutgoingDocument() async {
    Document item = Document();
    item.storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    item.type = DocumentType.outgoing;

    var result = await Navigator.of(getContext())
        .pushNamed(Pages.save_document, arguments: {'item': item});
    if (result != null){
      loadData();
    }
  }

  void openStores() async {
    final result = await Navigator.of(getContext())
        .pushNamed(Pages.store_list, arguments: {'isSelection': true});
    if (result != null){
      Store store = result;
      appDataManager.sharedPrefsHelper.setSelectedStoreId(store.id);
      loadData();
    }
  }

  void openDocuments() {
    Navigator.of(getContext()).pushNamed(Pages.document_list);
  }


  void openExpenses() {
    Navigator.of(getContext()).pushNamed(Pages.expenses);
  }

  void openReport() {
    showInfoToast("under development");
  }*/

  void openCustomers(){
    //emit(state.copyWith(state: OpenCustomersState()));
  }
  void openSuppliers(){
    //emit(state.copyWith(state: OpenSuppliersState()));
  }
  void openExpenses(){
    //emit(state.copyWith(state: OpenExpensesState()));
  }
  void openReport(){
    //emit(state.copyWith(state: OpenReportState()));
  }
}
