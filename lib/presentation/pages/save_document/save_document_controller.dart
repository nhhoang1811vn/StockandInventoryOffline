/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/goods/add_quantity_good_dialog.dart';
import 'package:good_manager/presentation/pages/help_content.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/barcode_scanner_settings.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/extension/date_time_apis.dart';
import 'package:sprintf/sprintf.dart';
import 'package:vibration/vibration.dart';

class SaveDocumentController extends Controller {
  bool isProcessBarcode = false;
  var dataMap = new Map();

  // Text field controller
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  TextEditingController supplierTextController;
  TextEditingController customerTextController;
  TextEditingController dateTextController;
  TextEditingController searchTextController;
  String _textSearch = "";

  String get textSearch => _textSearch;
  bool showSearchBar = false;
  bool isLoading = false;

  Document _item;
  Supplier supplier;
  Customer customer;

  List<DocumentTransaction> _allTransactions = [];

  List<DocumentTransaction> _transactions = [];

  List<DocumentTransaction> get transactions => _transactions;

  Document get item => _item;

  Document _originalItem;
  List<DocumentTransaction> _originalTransactions = [];

  BarcodeScannerSettings barcodeScannerSettings;

  SaveDocumentPresenter presenter;

  SaveDocumentController(_appRepository, _documentRepository,
      _transactionRepository, _goodRepository, this._item)
      : presenter = SaveDocumentPresenter(_appRepository, _documentRepository,
            _transactionRepository, _goodRepository),
        super() {
    nameTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    supplierTextController = TextEditingController();
    customerTextController = TextEditingController();
    dateTextController = TextEditingController();
    searchTextController = TextEditingController();

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

    retrieveSettings();
  }

  void retrieveSettings() {
    presenter.getBarcodeScannerSettings();
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
      if (e.toString().startsWith("error quantity")) {
        var goodName = e.toString().split(",")[1];
        showErrorToast(sprintf(
            AppLocalizations.of(getContext())
                .message_error_negative_quantity_save_document,
            [goodName]));
      } else {
        showErrorToast(e.toString());
      }
    };

    presenter.updateDocumentOnComplete = () async {
      Navigator.of(getContext()).pop(_item);
    };
    presenter.updateDocumentOnError = (e) {
      if (e.toString().startsWith("error quantity")) {
        var goodName = e.toString().split(",")[1];
        showErrorToast(sprintf(
            AppLocalizations.of(getContext())
                .message_error_negative_quantity_save_document,
            [goodName]));
      } else {
        showErrorToast(e.toString());
      }
    };

    presenter.getTransactionsByDocumentIdOnNext = (transactions) {
      isLoading = false;
      _allTransactions = transactions;
      _transactions = transactions;
      _originalTransactions = transactions;
      refreshUI();
    };
    presenter.getTransactionsByDocumentIdOnError = (e) {
      showErrorToast(e.toString());
    };

    presenter.getGoodByBarcodeOnNext = (good) {
      if (barcodeScannerSettings.batchModeScan == BatchModeScan.MANUALLY) {
        showInputQuantityDialog(good);
      } else {
        if (dataMap.containsKey(good.id)) {
          dataMap[good.id] = dataMap[good.id] + 1;
        } else {
          dataMap[good.id] = 1;
        }
        showShortInfoToast(
            sprintf("%s, %s, %d", [good.name, good.barCode, dataMap[good.id]]));
        onAddTransaction(good, 1);
        isProcessBarcode = false;
        refreshUI();
      }
    };
    presenter.getGoodByBarcodeOnError = (e) {
      showErrorToast(e.toString());
      isProcessBarcode = false;
    };

    presenter.getBarcodeScannerSettingsOnNext = (settings) {
      barcodeScannerSettings = settings;
    };
    presenter.getBarcodeScannerSettingsOnError = (e) {
      showErrorToast(e.toString());
    };
  }

  void showInputQuantityDialog(Good good) {
    showDialog(
        context: getContext(),
        builder: (_) => InputQuantityGoodDialog(
            good, (it) => {onQuantityAdded(good, it)}, () => {}),
        barrierDismissible: true);
  }

  void onAddTransaction(Good good, int quantity) {
    DocumentTransaction transaction = DocumentTransaction();
    transaction.goodId = good.id;
    transaction.currentQuantity = 0;
    transaction.quantity = quantity;
    transaction.type = item.type;

    good.quantity = quantity;
    transaction.good = good;

    transactions.add(transaction);
  }

  void onQuantityAdded(Good good, int quantity) {
    onAddTransaction(good, quantity);
    handleScanBarcodeManually();
    refreshUI();
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
        presenter.insert(_item, _allTransactions);
      } else {
        presenter.update(_item, _allTransactions);
      }
    }
  }

  void onAddGood() async {
    final result = await Navigator.of(getContext()).pushNamed(Pages.good_list,
        arguments: {
          "isSelection": true,
          "documentType": _item.type,
          "transactions": _allTransactions
    });
    if (result != null) {
      _allTransactions = result as List<DocumentTransaction>;
      filter();
      refreshUI();
    }
  }

  void onTransactionTapped(int index) async {
    */
/*final result = await Navigator.of(getContext()).pushNamed(Pages.save_good,
        arguments: {
          "item": transactions[index].good,
          "quantity": transactions[index].quantity
        });*//*

    final result = await Navigator.of(getContext())
        .pushNamed(Pages.save_good,
        arguments: {"item" : transactions[index].good, "enableAddTransactions": false});
    if (result != null) {
      var map = Map<String, dynamic>.from(result);
      Good good = map["item"];
      //int quantity = map["quantity"];
      transactions.forEach((transaction) {
        if (transaction.goodId == good.id) {
          transaction.good = good;
        }
      });
      transactions[index].quantity = good.quantity;
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
                  //_transactions.removeAt(index);
                  refreshUI();
                },
                child: Text(AppLocalizations.of(getContext()).action_delete),
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
    }
  }

  Future<bool> onWillPop() async {
    if (hasChanged()) {
      showDialog(
          context: getContext(),
          builder: (BuildContext builder) => AlertDialog(
                title: Text(AppLocalizations.of(getContext())
                    .dialog_title_data_not_save),
                content: Text(AppLocalizations.of(getContext())
                    .dialog_content_data_not_save),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(getContext()),
                    child:
                        Text(AppLocalizations.of(getContext()).action_cancel),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(getContext()).pop();
                      Navigator.of(getContext()).pop();
                    },
                    child: Text(AppLocalizations.of(getContext()).action_ok),
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
    if (_originalTransactions.length != _allTransactions.length) {
      return true;
    }
    _allTransactions.forEach((element) {
      if (element.id == null) {
        return true;
      }
    });
    for (var i = 0; i < _allTransactions.length; i++) {
      if (_allTransactions[i].quantity != _allTransactions[i].currentQuantity) {
        return true;
      }
    }
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

  void handleScanBarcodeManually() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666",
          AppLocalizations.of(getContext()).action_cancel,
          true,
          ScanMode.BARCODE);
      if (barcodeScanRes != "-1") {
        handleBeepAndVibrate();
        presenter.getGoodByBarcode(barcodeScanRes);
      }
    } on PlatformException {}
  }

  void handleScanBarcodeAuto() async {
    dataMap.clear();
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666",
            AppLocalizations.of(getContext()).action_cancel,
            false,
            ScanMode.DEFAULT)
        .listen((barcode) {
      /// barcode to be used
      if (!isProcessBarcode) {
        isProcessBarcode = true;
        handleBeepAndVibrate();
        presenter.getGoodByBarcode(barcode);
      }
    });
  }

  void handleBeepAndVibrate() async {
    if (barcodeScannerSettings.enableBeep) {
      FlutterBeep.beep();
    }
    if (barcodeScannerSettings.enableVibrate) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate();
      }
    }
  }

  onBatchScanPressed() async {
    if (barcodeScannerSettings.batchModeScan == BatchModeScan.MANUALLY) {
      handleScanBarcodeManually();
    } else {
      handleScanBarcodeAuto();
    }
  }

  //Search
  void onSearchChanged(String val) {
    _textSearch = val;
    filter();
    refreshUI();
  }

  void filter() {
    _transactions = _allTransactions
        .where((element) => filterTransaction(element))
        .toList();
  }

  filterTransaction(DocumentTransaction transaction) {
    if (_textSearch.trim().isEmpty) {
      return true;
    }
    //if (justScanCode){
    //  return group.barCode.contains(_textSearch);
    //}

    return transaction.good.name.contains(_textSearch) ||
        transaction.good.description.contains(_textSearch) ||
        transaction.good.barCode.contains(_textSearch);
  }

  void toggleSearchBar() {
    showSearchBar = !showSearchBar;
    resetSearchText();
  }

  void resetSearchText() {
    searchTextController.text = "";
    onSearchChanged("");
  }

  onSearchBarCode() async {
    try {
      var barcodeResult = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666",
          AppLocalizations.of(getContext()).action_cancel,
          true,
          ScanMode.BARCODE);
      if (barcodeResult != "-1") {
        searchTextController.text = barcodeResult;
        //justScanCode = true;
        onSearchChanged(barcodeResult);
        //justScanCode = false;
      }
    } on PlatformException {
      showErrorToast('Failed to get platform version.');
    }
  }

  void openHelpPage() async {
    String languageCode =
        await appDataManager.sharedPrefsHelper.getLanguageCode();
    Navigator.of(getContext()).pushNamed(Pages.help, arguments: {
      "title": AppLocalizations.of(getContext()).documents_title,
      "content": HelpUtils.getMarkdownData(languageCode, HelpType.DOCUMENTS)
    });
  }
}
*/
