/*
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/base/base_save_item_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/base_model.dart';

abstract class BaseSaveItemController<M extends BaseModel,
    P extends BaseSaveItemPresenter> extends Controller {
  P _presenter;

  P get presenter => _presenter;

  M _item;

  M get item => _item;

  M _originalItem;

  TextEditingController nameTextController;
  TextEditingController descriptionTextController;

  BaseSaveItemController(this._presenter, this._item) : super() {
    nameTextController = TextEditingController();
    descriptionTextController = TextEditingController();

    nameTextController.text = item.name;
    descriptionTextController.text = item.description;

    _originalItem = getOriginalItem(item);
  }

  M getOriginalItem(M item);

  bool hasChanged(M item, M originalItem);

  void updateItem(){
    item.name = nameTextController.text;
    item.description = descriptionTextController.text;
  }

  Future<bool> onWillPop() async {
    updateItem();
    if (hasChanged(_item, _originalItem)) {
      showDialog(
          context: getContext(),
          builder: (BuildContext builder) => AlertDialog(
                title: Text(AppLocalizations.of(getContext())
                    .dialog_title_data_not_save),
                content: Text(AppLocalizations.of(getContext())
                    .dialog_content_data_not_save),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(getContext()),
                    child:
                        Text(AppLocalizations.of(getContext()).action_cancel),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(getContext()).pop();
                      Navigator.of(getContext()).pop();
                    },
                    child: Text(AppLocalizations.of(getContext()).action_ok),
                  ),
                ],
              ));
    } else {
      Navigator.of(getContext()).pop();
    }
  }

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
    if (validate(params)) {
      updateItem();
      if (_item.id == null) {
        _presenter.insert(_item);
      } else {
        _presenter.update(_item);
      }
    }
  }
  bool validate(Map<String, dynamic> params){
    dynamic formKey = params['formKey'];
    return formKey.currentState.validate();
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }
}
*/
