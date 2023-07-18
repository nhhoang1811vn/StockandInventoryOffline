import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/documents_setting.dart';
import 'package:good_manager/domain/entities/search_documents_type.dart';
import 'package:good_manager/domain/usecases/documents/document_usecases.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/storage.dart';
import '../../base/base_state.dart';

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

    List<Document> incomingItems = items
        .where((element) => element.type == DocumentType.incoming)
        .toList();
    List<Document> outgoingItems = items
        .where((element) => element.type == DocumentType.outgoing)
        .toList();

    emit(state.copyWith(items: items, incomingItems: incomingItems, outgoingItems: outgoingItems));
  }

  //TextEditingController searchTextController;
  //bool isLoading = true;
  //List<Document> allDocuments = [];
  //List<Document> items = [];
  //List<Document> incomingItems = [];
  //List<Document> outgoingItems = [];
  //DocumentsPresenter presenter;

  //bool showSearchBar = false;
  //String _textSearch = "";
  //DocumentSettings _settings;

  //String get textSearch => _textSearch;
  /*@override
  void initListeners() {
    presenter.getDocumentsOnNext = (documents) {
      isLoading = false;
      this.allDocuments = documents;
      refreshItems();
    };
    presenter.getDocumentsOnError = (e) {
      showErrorToast(e.toString());
      isLoading = false;
      refreshUI();
    };

    presenter.deleteDocumentOnComplete = () {
      int index = allDocuments
          .indexWhere((element) => element.id == presenter.deletedId);
      allDocuments.removeAt(index);
      refreshItems();
    };
    presenter.deleteDocumentOnError = (e) {
      if (e.toString().startsWith("error quantity")){
        var goodName = e.toString().split(",")[1];
        showErrorToast(sprintf(AppLocalizations.of(getContext()).message_error_negative_quantity_save_document, [goodName]));
      }else{
        showErrorToast(e.toString());
      }
    };
    presenter.getDocumentSettingsOnNext = (settings) {
      _settings = settings;
      retrieveDocuments();
    };
    presenter.getDocumentSettingsOnError = (e) {
      showErrorToast(e.message.toString());
    };
    presenter.setDocumentSettingsOnComplete = () {};
    presenter.setDocumentSettingsOnError = (e) {
      showErrorToast(e.message.toString());
    };
  }*/

  void refreshItems() {
    /*sort();
    filter();
    refreshUI();*/
  }

  void reloadIncomingOutgoingItems() {
    /*incomingItems = items
        .where((element) => element.type == DocumentType.incoming)
        .toList();
    outgoingItems = items
        .where((element) => element.type == DocumentType.outgoing)
        .toList();*/
  }

  void toggleSearchBar() {
    emit(state.copyWith(showSearchBar: !state.showSearchBar));
    /*showSearchBar = !showSearchBar;
    resetSearchText();*/
  }

  void resetSearchText() {
    /*searchTextController.text = "";
    onSearchChanged("");*/
  }

  void onSearchChanged(String val) {
    /*_textSearch = val;
    filter();
    refreshUI();*/
  }

  void sort() {
    /*List<SortItems<Document>> sortOptions = [];
    switch (_settings.sortByName) {
      case SortByText.a_to_z:
        {
          sortOptions.add(SortByNameAToZ<Document>());
          break;
        }
      case SortByText.z_to_a:
        {
          sortOptions.add(SortByNameZToA<Document>());
          break;
        }
      default:
        {}
    }
    switch (_settings.sortByDate) {
      case SortByNumber.ascending:
        {
          sortOptions.add(SortByDateAscendingDocument());
          break;
        }
      case SortByNumber.descending:
        {
          sortOptions.add(SortByDateDescendingDocument());
          break;
        }
      default:
        {}
    }
    switch (_settings.sortByQuantity) {
      case SortByNumber.ascending:
        {
          sortOptions.add(SortByQuantityAscendingDocument());
          break;
        }
      case SortByNumber.descending:
        {
          sortOptions.add(SortByQuantityDescendingDocument());
          break;
        }
      default:
        {}
    }
    if (sortOptions.isEmpty) {
      sortOptions.add(SortByCreatedDate());
    }
    allDocuments.sort((item1, item2) {
      int compare = 0;
      for (final option in sortOptions) {
        compare = option.getResult(item1, item2);
        if (compare != 0) break;
      }
      return compare;
    });*/
  }
  void filter() {
    /*items = allDocuments.where((element) => filterDocument(element)).toList();
    reloadIncomingOutgoingItems();*/
  }

  bool filterDocument(Document document) {
    return false;
    /*if (_textSearch.trim().isEmpty) {
      return true;
    }
    switch (_settings.searchDocumentsType) {
      case SearchDocumentsType.byName:
        return document.name.contains(_textSearch);
        break;
      case SearchDocumentsType.byDescription:
        return document.description.contains(_textSearch);
        break;
      default:
        if (document.supplierName != null &&
            document.supplierName.contains(_textSearch)) {
          return true;
        }
        if (document.customerName != null &&
            document.customerName.contains(_textSearch)) {
          return true;
        }
        return false;
    }*/
  }

  void onShowSortDialog() async {
    /*showDialog(
        context: getContext(),
        builder: (_) => SortDocumentsDialog(_settings, () {
              presenter.setSettings(_settings);
              refreshItems();
            }),
        barrierDismissible: true);*/
  }

  bool hasSortOptions() {
    /*if (state.settings.sortByName != SortByText.no_sort ||
        state.settings.sortByDate != SortByNumber.no_sort ||
        state.settings.sortByQuantity != SortByNumber.no_sort) {
      return true;
    }
    return false;*/
    return true;
  }

  void onOpenHelpPage() async{
    emit(state.copyWith(state: OpenHelpPageState()));
  }
  void setSearchDocumentsType(SearchDocumentsType type) {
    /*_settings.searchDocumentsType = type;
    presenter.setSettings(_settings);

    resetSearchText();*/
  }
}
