import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/save_store/save_store_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/store.dart';

class SaveStoreController extends Controller {
  // Text field controller
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;

  SaveStorePresenter _presenter;
  bool isLoading = false;
  Store _item;
  bool _isInsert;

  Store get item => _item;

  SaveStoreController(storeRepository, this._item, this._isInsert)
      : _presenter = SaveStorePresenter(storeRepository),
        super() {
    nameTextController = TextEditingController();
    descriptionTextController = TextEditingController();

    if (_item != null) {
      nameTextController.text = _item.name;
      descriptionTextController.text = _item.description;
    }
    isLoading = false;
  }

  @override
  void initListeners() {
    _presenter.insertStoreOnError = (e) {
      dismissLoading();
      showErrorToast(e.message);
    };
    _presenter.insertStoreOnComplete = () {
      dismissLoading();
      Navigator.of(getContext()).pop(true);
    };

    _presenter.updateStoreOnError = (e) {
      dismissLoading();
      showErrorToast(e.message);
    };
    _presenter.updateStoreOnComplete = () {
      dismissLoading();
      Navigator.of(getContext()).pop(true);
    };
  }

  void dismissLoading() {
    isLoading = false;
    refreshUI();
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }

  void checkForm(Map<String, dynamic> params) {
    dynamic formKey = params['formKey'];
    // Validate params
    assert(formKey is GlobalKey<FormState>);
    if (formKey.currentState.validate()) {
      if (_item == null) {
        _item = Store();
      }
      _item.name = nameTextController.text;
      _item.description = descriptionTextController.text;
      if (_isInsert) {
        _presenter.insert(_item);
      } else {
        _presenter.update(_item);
      }
    }
  }
}
