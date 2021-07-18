import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/save_group/save_group_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/group.dart';

import '../base_save_item_controller.dart';

class SaveGroupController extends BaseSaveItemController<Group, SaveGroupPresenter>  {
  // Text field controller
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  TextEditingController barCodeTextController;



  SaveGroupController(repository, Group item)
      : super(SaveGroupPresenter(repository), item) {

    nameTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    barCodeTextController = TextEditingController();

    nameTextController.text = item.name;
    descriptionTextController.text = item.description;
    barCodeTextController.text = item.barCode;
  }

  @override
  void updateItem() {
    item.name = nameTextController.text;
    item.description = descriptionTextController.text;
    item.barCode = barCodeTextController.text;
  }

  void onInputBarCodePressed() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      if (barcodeScanRes != "-1"){
        barCodeTextController.text = barcodeScanRes;
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }
}
