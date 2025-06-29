import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/app_settings.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/documents_setting.dart';
import 'package:good_manager/domain/usecases/customers/customers_usecases.dart';
import 'package:good_manager/domain/usecases/documents/document_usecases.dart';
import 'package:good_manager/domain/usecases/suppliers/suppliers_usecases.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/models/list_item.dart';
import 'package:good_manager/presentation/pages/documents/criteria/by_search_text_criteria.dart';
import 'package:good_manager/presentation/pages/documents/criteria/by_status_criteria.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/storage.dart';
import '../../../../domain/entities/payment.dart';
import '../../../criteria/and_criteria.dart';
import '../../../criteria/criteria.dart';
import '../../../criteria/or_criteria.dart';
import '../../base/base_state.dart';
import '../criteria/by_type_criteria.dart';

part 'documents_cubit.freezed.dart';
part 'documents_state.dart';

@injectable
class DocumentsCubit extends Cubit<DocumentsState> {
  final DocumentUseCases useCase;
  final CustomersUseCase customersUseCase;
  final SuppliersUseCase suppliersUseCase;
  final Storage storage;
  final AppSettings appSettings;
  DocumentsCubit({
    required this.storage,
    required this.appSettings,
    required this.useCase,
    required this.customersUseCase,
    required this.suppliersUseCase

  })
      : super(DocumentsState.initial(
      state: InitialState()
  ));
  void initState({DocumentsSetting? setting = null}) {
    DocumentsSetting applySetting;
    if (setting == null){
      applySetting = appSettings.getDocumentsSetting();
    }else{
      applySetting = setting;
    }
    emit(state.copyWith(
        state: LoadingState(),
        setting: applySetting,
        incomingColor: appSettings.getIncomingDocumentColor(),
        outgoingColor: appSettings.getOutgoingDocumentColor()
    ));
    loadItems();
  }
  void loadItems() async {
    int storeId = storage.getSelectedStoreId();
    List<Document> items = await useCase.getAllByStoreId(storeId);
    emit(state.copyWith(allDocuments: items));
    update();
  }

  void onSearchMenuClicked() {
    emit(state.copyWith(showSearchBar: !state.showSearchBar, textSearch: ""));
    update();
  }

  void resetSearchText() {
    emit(state.copyWith(textSearch: ""));
    update();
  }

  void onSearchTextChanged(String val) {
    emit(state.copyWith(textSearch: val));
    update();
  }

  List<ListItem> getDocumentUIs(List<Document> data) {
    List<ListItem> results = [];
    Set<String> set = {};
    for (var i = 0; i < data.length; i++) {
      String dateText = DateFormatFactory.getDateFormat().format(data[i].date);
      if (!set.contains(dateText)) {
        results.add(HeaderItem(data[i].date));// DocumentUI(DocumentUIType.date, dateText, null));
        set.add(dateText);
      }
      results.add(DocumentListItem(data[i]));
    }
    return results;
  }
  void onMenuHelpClicked() {
    emit(state.copyWith(state: OpenHelpPageState()));
  }
  void delete(int id) async {
    await useCase.delete(id);
    loadItems();
  }

  getSelectedStoreId(){
    return storage.getSelectedStoreId();
  }
  String getAutoDocumentNo() {
    return storage.getAutoDocumentNo(getSelectedStoreId()).toString();
  }

  void resetAllFilter() {
    var setting = DocumentsSetting.getDefault();
    emit(state.copyWith(setting: setting));
    appSettings.setDocumentsSetting(setting);
    update();
  }
  void applyFilter(DocumentsSetting setting){
    emit(state.copyWith(setting: setting));
    appSettings.setDocumentsSetting(setting);
    update();
  }
  void update(){
    List<Criteria<Document>> commonCriteria = [];
    if (state.setting!.selectedStatus.isNotEmpty){
      List<Criteria<Document>> statusCriteria = [];
      state.setting!.selectedStatus.forEach((status) {
        statusCriteria.add(ByStatusCriteria(status));;
      });
      commonCriteria.add(OrCriteria(statusCriteria));
    }

    if (state.textSearch.isNotEmpty){
      commonCriteria.add(BySearchTextCriteria(state.textSearch));
    }
    List<Criteria<Document>> incomingCriteria = List.from(commonCriteria);
    incomingCriteria.add(ByTypeCriteria(DocumentType.incoming));

    List<Criteria<Document>> outgoingCriteria = List.from(commonCriteria);
    outgoingCriteria.add(ByTypeCriteria(DocumentType.outgoing));


    List<Document> documents = AndCriteria<Document>(commonCriteria).meetCriteria(state.allDocuments);
    List<Document> incomingDocuments = AndCriteria<Document>(incomingCriteria).meetCriteria(state.allDocuments);
    List<Document> outgoingDocuments = AndCriteria<Document>(outgoingCriteria).meetCriteria(state.allDocuments);

    emit(state.copyWith(
        state: LoadSuccessState(),
        documents: documents,
        incomingDocuments: incomingDocuments,
        outgoingDocuments: outgoingDocuments
    ));
  }

  Future<void> onCreateAPayment(Document item) async{
    var payment = Payment();
    payment.type = item.type == DocumentType.incoming ? PaymentType.outbound : PaymentType.inbound;
    payment.storeId = storage.getSelectedStoreId();
    payment.walletId = appSettings.getSavePaymentLastSelectedWalletId();
    payment.documentId = item.id;
    payment.document = item;

    if (item.type == DocumentType.incoming){
      if (item.personId != null){
        payment.supplierId = item.personId;
        payment.supplier = await suppliersUseCase.get(item.personId!);
      }
    }else{
      if (item.personId != null){
        payment.customerId = item.personId;
        payment.customer = await customersUseCase.get(item.personId!);
      }
    }
    emit(state.copyWith(state: OpenSavePaymentPageState(payment)));
  }
  void onViewLinkedPayments(Document item){
    emit(state.copyWith(state: OpenPaymentHistoryPageState(item.id!)));
  }
}
