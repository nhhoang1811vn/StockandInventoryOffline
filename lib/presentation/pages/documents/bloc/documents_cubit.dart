import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/search_documents_type.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';
import 'package:good_manager/presentation/pages/base/base_cubit.dart';
import 'package:good_manager/presentation/pages/documents/bloc/documents_data.dart';

class DocumentsCubit extends BaseCubit<DocumentsData> {
  DocumentsCubit(super.initialData);

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

  Future<void> onAddDocument(index) async {
    /*switch (index) {
      case 0:
        showDialog(
            context: getContext(),
            builder: (_) =>
                AddDocumentDialogWidget((it) => {_onAddDocumentWithType(it)}),
            barrierDismissible: true);
        break;
      case 1:
        _onAddDocumentWithType(DocumentType.incoming);
        break;
      case 2:
        _onAddDocumentWithType(DocumentType.outgoing);
        break;*/
    //case 3:
    //  _onAddDocumentWithType(DocumentType.stock_taking);
    //  break;
    }

  @override
  void dispose() {
    // TODO: implement dispose
  }


  void _onAddDocumentWithType(DocumentType type) async {
    /*Document item = Document();
    item.storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    item.type = type;
    item.name = await appDataManager.sharedPrefsHelper.getAutoDocumentName();

    var result = await Navigator.of(getContext())
        .pushNamed(Pages.save_document, arguments: {'item': item});
    if (result != null) {
      allDocuments.add(result);
      refreshItems();
    }*/
  }

  void onDocumentTapped(Document item) async {
    /*var result = await Navigator.of(getContext())
        .pushNamed(Pages.save_document, arguments: {'item': item});
    if (result != null) {
      int index = allDocuments.indexWhere((element) => element.id == item.id);
      allDocuments[index] = result;
      refreshItems();
    }*/
  }

  void onDocumentLongPressed(Document item) {
    /*showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(getContext());
                  showDeleteDocumentConfirm(item);
                },
                child: Text(AppLocalizations.of(getContext()).action_delete),
              ),
            ],
          );
        },
        barrierDismissible: true);*/
  }

  void showDeleteDocumentConfirm(Document document) {
    /*showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(getContext()).notification_dialog_title),
            content: Text(sprintf(
                AppLocalizations.of(getContext())
                    .message_confirm_delete_document,
                [document.name])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(getContext()),
                  child: Text(AppLocalizations.of(getContext()).action_cancel)),
              TextButton(
                onPressed: () {
                  Navigator.pop(getContext());
                  presenter.delete(document.id);
                },
                child: Text(AppLocalizations.of(getContext()).action_ok),
              )
            ],
          );
        });*/
  }

  void toggleSearchBar() {
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
    if (state.settings.sortByName != SortByText.no_sort ||
        state.settings.sortByDate != SortByNumber.no_sort ||
        state.settings.sortByQuantity != SortByNumber.no_sort) {
      return true;
    }
    return false;
  }

  void onOpenHelpPage() async{
    /*String code = await appDataManager.sharedPrefsHelper.getLanguageCode();
    Navigator.of(getContext()).pushNamed(Pages.help, arguments: {
      "title": AppLocalizations.of(getContext()).documents_title,
      "content": HelpUtils.getMarkdownData(code, HelpType.DOCUMENTS)
    });*/
  }


  void setSearchDocumentsType(SearchDocumentsType type) {
    /*_settings.searchDocumentsType = type;
    presenter.setSettings(_settings);

    resetSearchText();*/
  }
}
