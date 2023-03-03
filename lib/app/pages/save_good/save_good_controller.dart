import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/base/base_save_item_controller.dart';
import 'package:good_manager/app/pages/save_good/save_good_presenter.dart';
import 'package:good_manager/domain/entities/good.dart';

import '../../utils/utils.dart';

class SaveGoodController extends BaseSaveItemController<Good, SaveGoodPresenter> {
  TextEditingController barCodeTextController;
  TextEditingController quantityTextController;

  int _quantity;
  int get quantity => _quantity;

  List<String> files = [];

  SaveGoodController(goodRepository, Good item, this._quantity) :
        super(SaveGoodPresenter(goodRepository), item) {
    barCodeTextController = TextEditingController();
    quantityTextController = TextEditingController();
    barCodeTextController.text = item.barCode;
    files = item.files;
    if (_quantity != null) {
      quantityTextController.text = _quantity.toString();
    }
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
    item.barCode = barCodeTextController.text;
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

  void onInputQuantityPressed() async {
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
