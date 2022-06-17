import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/base_model.dart';
import 'package:good_manager/domain/entities/base_settings.dart';
import 'package:good_manager/domain/usecases/base_delete_item_usecase.dart';
import 'package:good_manager/domain/usecases/base_get_items_usecase.dart';
import 'package:good_manager/domain/usecases/base_get_settings_usecase.dart';
import 'package:good_manager/domain/usecases/base_set_settings_usecase.dart';

class BaseListPresenter<M extends BaseModel, S extends BaseSettings>
    extends Presenter {
  Function getItemsOnNext;
  Function getItemsOnError;

  Function getSettingsOnNext;
  Function getSettingsOnError;

  Function setSettingsOnComplete;
  Function setSettingsOnError;

  Function deleteItemOnComplete;
  Function deleteItemOnError;

  BaseGetItemsUseCase<M> _getItemsUseCase;
  BaseGetSettingsUseCase<S> _getSettingsUseCase;
  BaseSetSettingsUseCase<S> _setSettingsUseCase;
  BaseDeleteItemUseCase _deleteItemUseCase;

  int deletedId;

  BaseListPresenter(repository) {
    _getItemsUseCase = BaseGetItemsUseCase(repository);
    _getSettingsUseCase = BaseGetSettingsUseCase(repository);
    _setSettingsUseCase = BaseSetSettingsUseCase(repository);
    _deleteItemUseCase = BaseDeleteItemUseCase(repository);
  }

  void getSettings() {
    _getSettingsUseCase.execute(GetSettingsUseCaseObserver<S>(this));
  }

  void setSettings(S settings) {
    _setSettingsUseCase.execute(SetSettingsUseCaseObserver<S>(this),
        BaseSetSettingsUseCaseParam(settings));
  }

  void getItems() {
    _getItemsUseCase.execute(GetItemsUseCaseObserver<M>(this));
  }

  void delete(int id) {
    deletedId = id;
    _deleteItemUseCase.execute(
        _DeleteItemUseCaseObserver(this), BaseDeleteItemUseCaseParam((id)));
  }

  @override
  void dispose() {
    _getItemsUseCase.dispose();
    _getSettingsUseCase.dispose();
    _setSettingsUseCase.dispose();
    _deleteItemUseCase.dispose();
  }
}

class GetItemsUseCaseObserver<M extends BaseModel>
    implements Observer<List<M>> {
  BaseListPresenter presenter;

  GetItemsUseCaseObserver(this.presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    presenter.getItemsOnError(e);
  }

  @override
  void onNext(List<M> response) {
    presenter.getItemsOnNext(response);
  }
}

class GetSettingsUseCaseObserver<S extends BaseSettings>
    implements Observer<S> {
  BaseListPresenter presenter;

  GetSettingsUseCaseObserver(this.presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    presenter.getSettingsOnError(e);
  }

  @override
  void onNext(S settings) {
    presenter.getSettingsOnNext(settings);
  }
}

class SetSettingsUseCaseObserver<S extends BaseSettings>
    implements Observer<void> {
  BaseListPresenter presenter;

  SetSettingsUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    presenter.setSettingsOnComplete();
  }

  @override
  void onError(e) {
    presenter.setSettingsOnError(e);
  }

  @override
  void onNext(void _) {}
}

class _DeleteItemUseCaseObserver implements Observer<void> {
  BaseListPresenter _presenter;

  _DeleteItemUseCaseObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.deleteItemOnComplete();
  }

  @override
  void onError(e) {
    _presenter.deleteItemOnError(e);
  }

  @override
  void onNext(void response) {}
}
