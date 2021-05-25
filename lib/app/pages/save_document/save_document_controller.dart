import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/save_document/save_document_presenter.dart';
import 'package:good_manager/domain/entities/document.dart';

class SaveDocumentController extends Controller {
  // Text field controller
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  TextEditingController supplierTextController;
  TextEditingController dateTextController;

  final bool _isInsert;
  Document _item;

  SaveDocumentPresenter presenter;

  SaveDocumentController(
      _documentRepository, _transactionRepository, this._isInsert, this._item)
      : presenter =
            SaveDocumentPresenter(_documentRepository, _transactionRepository),
        super() {
    nameTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    supplierTextController = TextEditingController();
    dateTextController = TextEditingController();

    if (_item != null) {
      nameTextController.text = _item.name;
      descriptionTextController.text = _item.description;
      supplierTextController.text = _item.supplierName;
      dateTextController.text = _item.date.toString();
    }
  }

  @override
  void initListeners() {}

  void onSupplierTapped() {}

  void onSaveDocumentTapped() {}

  void onAddGood() {}
}
