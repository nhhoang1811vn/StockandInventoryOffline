import 'package:good_manager/domain/entities/general_infomation.dart';
import 'package:good_manager/presentation/pages/base/base_cubit.dart';
import 'package:good_manager/presentation/pages/home/bloc/home_data.dart';
import 'package:good_manager/presentation/pages/home/bloc/home_state.dart';
import 'package:injectable/injectable.dart';

import '../../base/base_state.dart';

@injectable
class HomeCubit extends BaseCubit<HomeData> {
  HomeCubit() : super(
      HomeData(state: InitialState(), info: GeneralInformation()));

  //bool isLoading = false;
  //GeneralInformation info;

  /*void openSaveIncomingDocument() async {
    Document item = Document();
    item.storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    item.type = DocumentType.incoming;

    var result = await Navigator.of(getContext())
        .pushNamed(Pages.save_document, arguments: {'item': item});
    if (result != null){
      loadData();
    }
  }

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

  @override
  void dispose() {
    // TODO: implement dispose
  }
  void openGoods(){
    emit(state.copyWith(state: OpenGoodsState()));
  }
  void openDocuments(){
    emit(state.copyWith(state: OpenDocumentsState()));
  }
  void openSaveIncomingDocument(){

  }
  void openSaveOutgoingDocument(){

  }
  void openCustomers(){
    emit(state.copyWith(state: OpenCustomersState()));
  }
  void openSuppliers(){
    emit(state.copyWith(state: OpenSuppliersState()));
  }
  void openExpenses(){
    emit(state.copyWith(state: OpenExpensesState()));
  }
  void openReport(){
    emit(state.copyWith(state: OpenReportState()));
  }
}
