/*
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/save_group/save_group_presenter.dart';
import 'package:good_manager/app/utils/utils.dart';
import 'package:good_manager/domain/entities/group.dart';

import '../base/base_save_item_controller.dart';

class SaveGroupController extends BaseSaveItemController<Group, SaveGroupPresenter>  {
  List<String> files = [];
  TextEditingController barCodeTextController;
  SaveGroupController(repository, Group item)
      : super(SaveGroupPresenter(repository), item) {
    barCodeTextController = TextEditingController();
    barCodeTextController.text = item.barCode;
    files = item.files;
  }


  @override
  void updateItem() {
    super.updateItem();
    if (barCodeTextController.text.isNotEmpty){
      item.barCode = barCodeTextController.text;
    }
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

  @override
  Group getOriginalItem(Group item) {
    Group group = Group();
    group.name = item.name;
    group.description = item.description;;
    group.barCode = item.barCode;
    group.files = item.files.toList();
    return group;
  }

  @override
  bool hasChanged(Group item, Group originalItem) {
    return (item.name != originalItem.name ||
        item.description != originalItem.description ||
        item.barCode != originalItem.barCode ||
        !Utils.sameFiles(item.files, originalItem.files)
    );
  }
  void onImagesChanged(List<String> images){
    print("onImagesChanged ${images.length}");
    files = images;
  }
}
*/
