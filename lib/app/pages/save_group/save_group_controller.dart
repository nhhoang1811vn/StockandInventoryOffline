import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/save_group/save_group_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/group.dart';

class SaveGroupController extends Controller {
  // Text field controller
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  TextEditingController barCodeTextController;

  SaveGroupPresenter presenter;
  Group _item;

  SaveGroupController(groupRepository, this._item)
      : presenter = SaveGroupPresenter(groupRepository),
        super() {
    nameTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    barCodeTextController = TextEditingController();

    nameTextController.text = _item.name;
    descriptionTextController.text = _item.description;
    barCodeTextController.text = _item.barCode;
  }

  @override
  void initListeners() {
    presenter.insertGroupOnNext = (groupId) {
      Navigator.of(getContext()).pop(true);
    };
    presenter.insertGroupOnError = (e) {
      showErrorToast(e.toString());
    };

    presenter.updateGroupOnComplete = () {
      Navigator.of(getContext()).pop(true);
    };
    presenter.updateGroupOnError = (e) {
      showErrorToast(e.toString());
    };
  }

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }

  void checkForm(Map<String, dynamic> params) {
    dynamic formKey = params['formKey'];
    if (formKey.currentState.validate()) {
      updateItem();
      if (_item.id == null) {
        presenter.insert(_item);
      } else {
        presenter.update(_item);
      }
    }
  }

  void updateItem() {
    _item.name = nameTextController.text;
    _item.description = descriptionTextController.text;
    _item.barCode = barCodeTextController.text;
  }

  void onInputBarCodePressed() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      barCodeTextController.text = barcodeScanRes;
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }
}
