import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/save_good/save_good_presenter.dart';
import 'package:good_manager/domain/entities/good.dart';

class SaveGoodController extends Controller {
  // Text field controller
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  TextEditingController barCodeTextController;

  SaveGoodPresenter presenter;

  final bool _isInsert;
  Good _item;

  SaveGoodController(goodRepository, this._isInsert, this._item)
      : presenter = SaveGoodPresenter(goodRepository),
        super() {
    nameTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    barCodeTextController = TextEditingController();

    if (_item != null) {
      nameTextController.text = _item.name;
      descriptionTextController.text = _item.description;
      barCodeTextController.text = _item.barCode;
    }
  }

  @override
  void initListeners() {
    presenter.insertGoodOnComplete = () {
      Navigator.of(getContext()).pop(true);
    };
    presenter.insertGoodOnError = (e) {};

    presenter.updateGoodOnComplete = () {
      Navigator.of(getContext()).pop(true);
    };
    presenter.updateGoodOnError = (e) {};
  }

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }

  void checkForm(Map<String, dynamic> params) {
    dynamic formKey = params['formKey'];
    // Validate params
    //assert(formKey is GlobalKey<FormState>);
    if (formKey.currentState.validate()) {
      if (_item == null) {
        _item = Good();
      }
      _item.name = nameTextController.text;
      _item.description = descriptionTextController.text;
      _item.barCode = barCodeTextController.text;
      if (_isInsert) {
        presenter.insert(_item);
      } else {
        presenter.update(_item);
      }
    }
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
