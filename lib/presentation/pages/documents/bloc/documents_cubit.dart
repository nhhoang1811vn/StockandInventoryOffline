import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/documents_setting.dart';
import 'package:good_manager/domain/entities/search_documents_type.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';
import 'package:good_manager/domain/usecases/documents/document_usecases.dart';
import 'package:good_manager/presentation/pages/documents/document_ui.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../../../data/storage.dart';
import '../../base/base_sort_items.dart';
import '../../base/base_state.dart';
import '../sort/sort_by_date_documents.dart';

part 'documents_cubit.freezed.dart';
part 'documents_state.dart';

@injectable
class DocumentsCubit extends Cubit<DocumentsState> {
  final DocumentUseCases useCase;
  final Storage storage;
  DocumentsCubit({required this.storage,required this.useCase}) : super(DocumentsState.initial(state: InitialState(), settings: storage.getDocumentsSetting()));

  void initState(){
    loadItems();
  }
  void loadItems() async{
    int storeId = storage.getSelectedStoreId();
    List<Document> items = await useCase.getAllByStoreId(storeId);
    emit(state.copyWith(allDocuments: items));
    sort();
    filter();
  }

  void onSearchMenuClicked() {
    emit(state.copyWith(showSearchBar: !state.showSearchBar, textSearch: ""));
    filter();
  }

  void resetSearchText() {
    emit(state.copyWith(textSearch: ""));
    filter();
  }

  void onSearchTextChanged(String val) {
    emit(state.copyWith(textSearch: val));
    filter();
  }
  void sort(){
    List<Document> items = sortDocuments();
    emit(state.copyWith(allDocuments: items));
  }

  List<Document> sortDocuments() {
    List<SortItems> options = [];
    switch (state.settings.sortByDate) {
      case SortByNumber.ascending:
        {
          options.add(SortByDateAscendingDocument());
          break;
        }
      case SortByNumber.descending:
        {
          options.add(SortByDateDescendingDocument());
          break;
        }
      default:
        {}
    }

    if (options.isEmpty) {
      options.add(SortByCreatedDate());
    }
    List<Document> items = [];
    items.addAll(state.allDocuments);
    items.sort((item1, item2) {
      int compare = 0;
      for (final option in options) {
        compare = option.getResult(item1, item2);
        if (compare != 0) break;
      }
      return compare;
    });
    return items;
  }
  List<DocumentUI> getDocumentUIs(List<Document> data){
    List<DocumentUI> results = [];
    Set<String> set = {};
    for (var i = 0; i< data.length;i++){
      String dateText = Config.dateFormat.format(data[i].date);
      if (!set.contains(dateText)){
        results.add(DocumentUI(DocumentUIType.date, dateText, null));
        set.add(dateText);
      }
      results.add(DocumentUI(DocumentUIType.data, "", data[i]));
    }
    return results;
  }
  void filter() {
    List<Document> documents = state.allDocuments.where((element) => filterDocument(element)).toList();
    List<Document> incomingDocuments = documents
        .where((element) => element.type == DocumentType.incoming)
        .toList();
    List<Document> outgoingDocuments = documents
        .where((element) => element.type == DocumentType.outgoing)
        .toList();
    emit(state.copyWith(documents: documents,
        items: getDocumentUIs(documents),
        incomingDocuments: incomingDocuments,
        incomingItems: getDocumentUIs(incomingDocuments),
        outgoingDocuments: outgoingDocuments,
        outgoingItems: getDocumentUIs(outgoingDocuments)
    ));
  }

  bool filterDocument(Document document) {
    if (state.textSearch.trim().isEmpty) {
      return true;
    }
    switch (state.settings.searchDocumentsType) {
      case SearchDocumentsType.byName:
        return document.name.contains(state.textSearch);
      case SearchDocumentsType.byDescription:
        return document.description.contains(state.textSearch);
      case SearchDocumentsType.byCustomerSupplier:
        return (document.personName != null && document.personName!.contains(state.textSearch));
    }
  }

  void onMenuSortClicked(){
    emit(state.copyWith(state: OpenSortDialogListState()));
  }

  bool hasSortOptions() {
    if (state.settings.sortByDate != SortByNumber.no_sort) {
      return true;
    }
    return false;
  }

  void onMenuHelpClicked(){
    emit(state.copyWith(state: OpenHelpPageState()));
  }
  void setSearchDocumentsType(SearchDocumentsType type) {
    DocumentsSetting settings = state.settings.copyWith(searchDocumentsType: type);
    storage.setDocumentsSetting(settings);
    emit(state.copyWith(settings: settings));
    filter();
  }
  void delete(int id) async{
    await useCase.delete(id);
    loadItems();
  }
  void setSettings(DocumentsSetting settings) {
    storage.setDocumentsSetting(settings);
    emit(state.copyWith(settings: settings));
    sort();
    filter();
  }
}
