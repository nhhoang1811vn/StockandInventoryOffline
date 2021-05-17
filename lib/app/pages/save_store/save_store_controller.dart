import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/save_store/save_store_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/store.dart';

class SaveStoreController extends Controller{
  // Text field controller
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;

  SaveStorePresenter _presenter;
  bool isLoading = false;
  Store _store;
  bool _isInsert;
  bool _validate = true;
  Store get store => _store;
  bool get validate => _validate;
  SaveStoreController(storeRepository, this._store,this._isInsert) : _presenter = SaveStorePresenter(storeRepository),
        super(){
    nameTextController = TextEditingController();
    descriptionTextController = TextEditingController();

    nameTextController.text = _store.name;
    descriptionTextController.text = _store.description;
    isLoading = false;
  }
  @override
  void initListeners() {
    _presenter.insertStoreOnError = (e){
      showGenericSnackbar(getStateKey(), e.message, isError: true);
      //showGenericSnackbar(getContext(),e.message, isError: true);
      dismissLoading();
    };
    _presenter.insertStoreOnComplete = (){
      dismissLoading();
      Navigator.of(getContext()).pop(true);
    };

    _presenter.updateStoreOnError = (e){
      //showGenericSnackbar(getContext(),getStateKey(), e.message, isError: true);
      dismissLoading();
    };
    _presenter.updateStoreOnComplete = (){
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
  void verify(){
    if (nameTextController.text.isEmpty){
      _validate = false;
      refreshUI();
      //invalid
    }else{
      _validate = true;
      //valid
      store.name = nameTextController.text;
      store.description = descriptionTextController.text;
      if (_isInsert){
        _presenter.insert(store);
      }else{
        _presenter.update(store);
      }
    }
  }
}