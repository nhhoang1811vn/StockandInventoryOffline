import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_calculator/flutter_calculator.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/save_good/save_good_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/good.dart';

class SaveGoodController extends Controller {
  // Text field controller
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  TextEditingController barCodeTextController;
  TextEditingController quantityTextController;

  SaveGoodPresenter presenter;
  Good _item;

  Good get item => _item;

  int _quantity;

  int get quantity => _quantity;

  PageController imagesPageController;
  List<String> files = [];

  SaveGoodController(
      goodRepository, transactionRepository, this._item, this._quantity)
      : presenter = SaveGoodPresenter(goodRepository, transactionRepository),
        super() {
    nameTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    barCodeTextController = TextEditingController();
    quantityTextController = TextEditingController();
    imagesPageController = PageController(initialPage: 0);

    if (_item == null) {
      _item = Good();
    }
    nameTextController.text = _item.name;
    descriptionTextController.text = _item.description;
    barCodeTextController.text = _item.barCode;
    files = _item.files;

    if (_quantity != null) {
      quantityTextController.text = _quantity.toString();
    }
  }

  @override
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
    _item.files = files;
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

  void onInputQuantityPressed() async {
    final result = await showCalculator(context: getContext()) ?? 0;
    quantityTextController.text = result.toInt().toString();
  }

  void onTakeAPicture() async {
    final result =
        await Navigator.of(getContext()).pushNamed(Pages.take_picture);
    if (result != null) {
      files.add(result);
      refreshUI();
    }
  }

  void onLoadFromGallery() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);

    if (result != null) {
      //List<File> outputFiles = result.paths.map((path) => File(path)).toList();
      files.addAll(result.paths);
      refreshUI();
    } else {
      // User canceled the picker
    }
  }

  void onBrowseFile() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      //List<File> outputFiles = result.paths.map((path) => File(path)).toList();
      files.addAll(result.paths);
      refreshUI();
    } else {
      // User canceled the picker
    }
  }

  void onAddFile() async {
    showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(getContext());
                  onTakeAPicture();
                },
                child:
                    Text(AppLocalizations.of(getContext()).action_take_picture),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(getContext());
                  onLoadFromGallery();
                },
                child: Text(
                    AppLocalizations.of(getContext()).action_load_from_gallery),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(getContext());
                  onBrowseFile();
                },
                child:
                    Text(AppLocalizations.of(getContext()).action_browse_file),
              )
            ],
          );
        },
        barrierDismissible: true);
  }
}
