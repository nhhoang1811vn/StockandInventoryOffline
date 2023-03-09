import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/base/base_save_item_controller.dart';
import 'package:good_manager/app/pages/save_good/save_good_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/app/widgets/receive_good_dialog.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';

import '../../../data/app_data_manager.dart';
import '../../utils/utils.dart';

class SaveGoodController extends BaseSaveItemController<Good, SaveGoodPresenter> {
  TextEditingController barCodeTextController;
  TextEditingController quantityTextController;
  List<String> files = [];

  SaveGoodController(goodRepository,documentRepository, Good item) :
        super(SaveGoodPresenter(goodRepository, documentRepository), item) {
    barCodeTextController = TextEditingController();
    quantityTextController = TextEditingController();

    barCodeTextController.text = item.barCode;
    quantityTextController.text = item.quantity.toString();
    files = item.files;
  }
  @override
  void initListeners() {
    // TODO: implement initListeners
    super.initListeners();
    presenter.quickInsertTransactionOnNext = (result){
      showInfoToast("Đã tạo Giao Dịch số 1");
    };
    presenter.quickInsertTransactionOnError = (e){
      showErrorToast(e.toString());
    };
  }

  /*@override
  void initListeners() {
    presenter.insertGoodOnNext = (goodId) {
      _item.id = goodId;
      Navigator.of(getContext()).pop(_item);
    };
    presenter.insertGoodOnError = (e) {
      showErrorToast(e.toString());
    };

    presenter.updateGoodOnComplete = () {
      if (_quantity != null) {
        Navigator.of(getContext()).pop({
          "item": _item,
          "quantity": int.parse(quantityTextController.text)
        });
      } else {
        Navigator.of(getContext()).pop({"item": _item});
      }
    };
    presenter.updateGoodOnError = (e) {
      showErrorToast(e.toString());
    };
  }*/
  @override
  void updateItem() {
    super.updateItem();
    if (barCodeTextController.text.isNotEmpty){
      item.barCode = barCodeTextController.text;
    }
    item.quantity = int.parse(quantityTextController.text);
    item.files = files;
  }

  void onInputBarCodePressed() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666",
          AppLocalizations.of(getContext()).action_cancel,
          true,
          ScanMode.BARCODE);
      if (barcodeScanRes != "-1") {
        barCodeTextController.text = barcodeScanRes;
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }
  void onAddQuantityButtonPressed(Map<String, dynamic> params) async{
    if (validate(params)){
      //show dialog
      Document document = new Document();
      document.type = DocumentType.incoming;
      document.date = DateTime.now();
      //document.storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
      document.name = await appDataManager.sharedPrefsHelper.getAutoDocumentName();
      int quantity = 1;
      showDialog(
          context: getContext(),
          builder: (_) => ReceiveGoodDialog(document, quantity, onSaveIncomingDocument),
          barrierDismissible: false);
    }
  }
  void onSaveIncomingDocument(Document document, int quantity){
    updateItem();
    presenter.quickInsertTransaction(item, document, quantity);
  }
  void onSubQuantityButtonPressed(Map<String, dynamic> params){

  }
  void onModifyQuantityButtonPressed(){
    /*final result = await showCalculator(context: getContext()) ?? 0;
    quantityTextController.text = result.toInt().toString();*/
  }
  void onImagesChanged(List<String> images){
    print("onImagesChanged ${images.length}");
    files = images;
  }

  @override
  Good getOriginalItem(Good item) {
    Good good = Good();
    good.name = item.name;
    good.description = item.description;
    good.barCode = item.barCode;
    good.files =  item.files.toList();
    return good;
  }

  @override
  bool hasChanged(Good item, Good originalItem) {
    return (item.name != originalItem.name ||
        item.description != originalItem.description ||
        item.barCode != originalItem.barCode ||
        !Utils.sameFiles(item.files, originalItem.files)
    );
  }
}
