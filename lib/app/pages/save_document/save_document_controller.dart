import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/save_document/save_document_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/extension/date_time_apis.dart';

class SaveDocumentController extends Controller {
  // Text field controller
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  TextEditingController supplierTextController;
  TextEditingController customerTextController;
  TextEditingController dateTextController;
  bool isLoading = false;

  Document _item;
  Supplier supplier;
  Customer customer;

  List<DocumentTransaction> _transactions = [];

  List<DocumentTransaction> get transactions => _transactions;

  Document get item => _item;

  Document _originalItem;
  List<DocumentTransaction> _originalTransactions = [];

  SaveDocumentPresenter presenter;

  SaveDocumentController(
      _documentRepository, _transactionRepository, this._item)
      : presenter =
            SaveDocumentPresenter(_documentRepository, _transactionRepository),
        super() {
    nameTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    supplierTextController = TextEditingController();
    customerTextController = TextEditingController();
    dateTextController = TextEditingController();

    nameTextController.text = _item.name;
    descriptionTextController.text = _item.description;
    supplierTextController.text = _item.supplierName;
    customerTextController.text = _item.customerName;
    dateTextController.text = _item.date.toString();

    if (_item.id != null) {
      retrieveTransactions();
    } else {
      _originalTransactions = [];
    }
    _originalItem = _item.clone();
  }

  void retrieveTransactions() {
    isLoading = true;
    presenter.getTransactionByDocumentId(_item.id);
  }

  @override
  void initListeners() {
    presenter.insertDocumentOnNext = (documentId) {
      _item.id = documentId;
      Navigator.of(getContext()).pop(_item);
    };
    presenter.insertDocumentOnError = (e) {
      showErrorToast(e.toString());
    };

    presenter.updateDocumentOnComplete = () async {
      Navigator.of(getContext()).pop(_item);
    };
    presenter.updateDocumentOnError = (e) {
      showErrorToast(e.toString());
    };

    presenter.getTransactionsByDocumentIdOnNext = (transactions) {
      isLoading = false;
      this._transactions = transactions;
      _originalTransactions = _transactions;
      refreshUI();
    };
    presenter.getTransactionsByDocumentIdOnError = (e) {
      showErrorToast(e.toString());
    };
  }

  void onSupplierTapped() async {
    final result = await Navigator.of(getContext())
        .pushNamed(Pages.supplier_list, arguments: {"isSelection": true});
    if (result != null) {
      this.supplier = result;
      supplierTextController.text = this.supplier.name;
    }
  }

  void onCustomerTapped() async {
    final result = await Navigator.of(getContext())
        .pushNamed(Pages.customer_list, arguments: {"isSelection": true});
    if (result != null) {
      this.customer = result;
      customerTextController.text = this.customer.name;
    }
  }

  void onSaveDocumentTapped(Map<String, dynamic> params) {
    dynamic formKey = params['formKey'];
    if (formKey.currentState.validate()) {
      updateItem();
      if (_item.id == null) {
        presenter.insert(_item, _transactions);
      } else {
        presenter.update(_item, _transactions);
      }
    }
  }

  void onAddGood() async {
    final result = await Navigator.of(getContext()).pushNamed(Pages.good_list,
        arguments: {"isSelection": true, "documentType": _item.type});
    if (result != null) {
      List<DocumentTransaction> newTransactions =
          result as List<DocumentTransaction>;
      if (newTransactions.isNotEmpty) {
        transactions.addAll(result);
        refreshUI();
      }
    }
  }

  void onTransactionTapped(int index) async {
    final result = await Navigator.of(getContext()).pushNamed(Pages.save_good,
        arguments: {
          "item": transactions[index].good,
          "quantity": transactions[index].quantity
        });
    if (result != null) {
      var map = Map<String, dynamic>.from(result);
      Good good = map["item"];
      int quantity = map["quantity"];
      transactions.forEach((transaction) {
        if (transaction.goodId == good.id) {
          transaction.good = good;
        }
      });
      transactions[index].quantity = quantity;
      refreshUI();
    }
  }

  void onTransactionLongPress(int index) {
    showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  _transactions.removeAt(index);
                  refreshUI();
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
        barrierDismissible: true);
  }

  String getTitleText() {
    switch (_item.type) {
      case DocumentType.incoming:
        return AppLocalizations.of(getContext()).save_document_incoming_title;
      case DocumentType.outgoing:
        return AppLocalizations.of(getContext()).save_document_outgoing_title;
      //case DocumentType.stock_taking:
      //  return AppLocalizations
      //     .of(getContext())
      //     .save_document_stock_taking_title;
    }
  }

  Future<bool> onWillPop() async {
    if (hasChanged()) {
      showDialog(
          context: getContext(),
          builder: (BuildContext builder) => AlertDialog(
                title: const Text('Attention!'),
                content: const Text('Close without saving'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(getContext(), 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(getContext()).pop();
                      Navigator.of(getContext()).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ));
    } else {
      Navigator.of(getContext()).pop();
    }
  }

  bool hasChanged() {
    updateItem();
    return (_item.name != _originalItem.name ||
        !_item.date.isSameDate(_originalItem.date) ||
        _item.supplierId != _originalItem.supplierId ||
        _item.description != _originalItem.description ||
        areTransactionsChanged());
  }

  bool areTransactionsChanged() {
    if (_originalTransactions.length != _transactions.length) {
      return true;
    }
    _transactions.forEach((element) {
      if (element.id == null) {
        return true;
      }
    });
    return false;
  }

  void updateItem() {
    _item.name = nameTextController.text;
    _item.description = descriptionTextController.text;
    _item.date = DateTime.parse(dateTextController.text);
    if (supplier != null) {
      _item.supplierId = supplier.id;
      _item.supplierName = supplier.name;
    }
    if (customer != null) {
      _item.customerId = customer.id;
      _item.customerName = customer.name;
    }
    int quantity = 0;
    transactions.forEach((element) {
      quantity += element.quantity;
    });
    _item.quantity = quantity;
  }
}
