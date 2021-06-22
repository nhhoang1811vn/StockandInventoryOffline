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

  Store get item => _item;

  SaveStoreController(storeRepository, this._item)
      : _presenter = SaveStorePresenter(storeRepository),
        super() {
    nameTextController = TextEditingController();
    descriptionTextController = TextEditingController();

    if (_item == null) {
      _item = Store();
    }
    nameTextController.text = _item.name;
    descriptionTextController.text = _item.description;
    isLoading = false;
  }

  @override
  void initListeners() {
    _presenter.insertStoreOnError = (e) {
      dismissLoading();
      showErrorToast(e.message);
    };
    _presenter.insertStoreOnNext = (storeId) {
      dismissLoading();
      _item.id = storeId;
      Navigator.of(getContext()).pop(_item);
    };

    _presenter.updateStoreOnError = (e) {
      dismissLoading();
      showErrorToast(e.message);
    };
    _presenter.updateStoreOnComplete = () {
      dismissLoading();
      Navigator.of(getContext()).pop(_item);
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
      updateItem();
      if (_item.id == null) {
        _presenter.insert(_item);
      } else {
        _presenter.update(_item);
      }
    }
  }

  void updateItem() {
    _item.name = nameTextController.text;
    _item.description = descriptionTextController.text;
  }
}
