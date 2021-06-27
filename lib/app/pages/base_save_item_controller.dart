import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/base_save_item_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/base_model.dart';

abstract class BaseSaveItemController<M extends BaseModel,
    P extends BaseSaveItemPresenter> extends Controller {
  P _presenter;

  P get presenter => _presenter;

  M _item;

  M get item => _item;

  BaseSaveItemController(this._presenter, this._item) : super();

  void updateItem();

  @override
  void initListeners() {
    _presenter.insertItemOnError = (e) {
      showErrorToast(e.toString());
    };
    _presenter.insertItemOnNext = (id) {
      _item.id = id;
      Navigator.of(getContext()).pop(_item);
    };

    _presenter.updateItemOnError = (e) {
      showErrorToast(e.toString());
    };
    _presenter.updateItemOnComplete = () {
      Navigator.of(getContext()).pop(_item);
    };
  }

  void checkForm(Map<String, dynamic> params) {
    dynamic formKey = params['formKey'];
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

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }
}
