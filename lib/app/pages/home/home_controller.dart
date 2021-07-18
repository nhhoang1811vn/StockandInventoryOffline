import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/home/home_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/general_infomation.dart';
import 'package:good_manager/domain/entities/store.dart';

import '../pages.dart';

class HomeController extends Controller {
  bool isLoading = false;
  GeneralInformation info;
  HomePresenter presenter;

  HomeController(
      storeRepository,
      goodRepository,
      documentRepository,
      transactionRepository,
      supplierRepository,
      customerRepository,
      expenseRepository)
      : presenter = HomePresenter(
            storeRepository,
            goodRepository,
            documentRepository,
            transactionRepository,
            supplierRepository,
            customerRepository,
            expenseRepository),
        super() {
    loadData();
  }

  void loadData() {
    isLoading = true;
    info = GeneralInformation();
    presenter.getGeneralInformation();
  }

  @override
  void initListeners() {
    presenter.getGeneralInformationOnNext = (generalInformation) {
      info = generalInformation;
      isLoading = false;
      refreshUI();
    };
    presenter.getGeneralInformationOnError = (e) {
      showErrorToast(e.toString());
    };
  }

  @override
  void dispose() {
    presenter.dispose();
  }

  void openSaveIncomingDocument() async {
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

  void openGoods() {
    Navigator.of(getContext())
        .pushNamed(Pages.good_list, arguments: {'isSelection': false});
  }

  void openDocuments() {
    Navigator.of(getContext()).pushNamed(Pages.document_list);
  }

  void openCustomers() {
    Navigator.of(getContext())
        .pushNamed(Pages.customer_list, arguments: {'isSelection': false});
  }

  void openSuppliers() {
    Navigator.of(getContext())
        .pushNamed(Pages.supplier_list, arguments: {'isSelection': false});
  }

  void openExpenses() {
    Navigator.of(getContext()).pushNamed(Pages.expenses);
  }

  void openReport() {
    showInfoToast("under development");
  }
}
