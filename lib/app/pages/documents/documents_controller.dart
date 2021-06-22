import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/documents/documents_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/document.dart';

import '../pages.dart';
import 'add_document_dialog.dart';

class DocumentsController extends Controller {
  bool isLoadingAll = true;
  List<Document> allDocuments = [];
  List<Document> incomingDocuments = [];
  List<Document> outgoingDocuments = [];
  DocumentsPresenter presenter;

  DocumentsController(documentRepository)
      : presenter = DocumentsPresenter(documentRepository),
        super() {
    retrieveDocuments();
  }

  void retrieveDocuments() async {
    isLoadingAll = true;
    int storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    presenter.getDocuments(storeId);
  }

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }

  @override
  void initListeners() {
    presenter.getDocumentsOnNext = (documents) {
      isLoadingAll = false;
      this.allDocuments = documents;
      refreshItems();
    };
    presenter.getDocumentsOnError = (e) {
      showErrorToast(e.toString());
    };

    presenter.deleteDocumentOnComplete = () {
      int index = allDocuments
          .indexWhere((element) => element.id == presenter.deletedId);
      allDocuments.removeAt(index);
      refreshItems();
    };
    presenter.deleteDocumentOnError = (e) {
      showErrorToast(e.toString());
    };
  }

  void refreshItems() {
    this.incomingDocuments = this
        .allDocuments
        .where((element) => element.type == DocumentType.incoming)
        .toList();
    this.outgoingDocuments = this
        .allDocuments
        .where((element) => element.type == DocumentType.outgoing)
        .toList();
    refreshUI();
  }

  Future<void> onAddDocument(index) async {
    switch (index) {
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
        break;
      //case 3:
      //  _onAddDocumentWithType(DocumentType.stock_taking);
      //  break;
    }
  }

  void _onAddDocumentWithType(DocumentType type) async {
    Document item = Document();
    item.storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    item.type = type;

    var result = await Navigator.of(getContext())
        .pushNamed(Pages.save_document, arguments: {'item': item});
    if (result != null) {
      allDocuments.add(result);
      refreshItems();
    }
  }

  void onDocumentTapped(Document item) async {
    var result = await Navigator.of(getContext())
        .pushNamed(Pages.save_document, arguments: {'item': item});
    if (result != null) {
      int index = allDocuments.indexWhere((element) => element.id == item.id);
      allDocuments[index] = result;
      refreshItems();
    }
  }

  void onDocumentLongPressed(Document item) {
    showDialog(
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
        barrierDismissible: true);
  }

  void showDeleteDocumentConfirm(Document document) {
    showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(getContext()).notification_dialog_title),
            content: Text(AppLocalizations.of(getContext())
                .message_confirm_delete_document),
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
        });
  }
}
