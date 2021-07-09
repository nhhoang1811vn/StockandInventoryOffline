import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/goods_settings.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/usecases/goods/delete_good_usecase.dart';
import 'package:good_manager/domain/usecases/goods/get_good_usecase.dart';
import 'package:good_manager/domain/usecases/goods/get_goods_settings_usecase.dart';
import 'package:good_manager/domain/usecases/goods/set_goods_settings_usecase.dart';
import 'package:good_manager/domain/usecases/groups/get_group_usecase.dart';

class GoodsPresenter extends Presenter {
  Function getGroupsOnNext;
  Function getGroupsOnComplete;
  Function getGroupsOnError;

  Function getGoodsOnNext;
  Function getGoodsOnComplete;
  Function getGoodsOnError;

  Function getGoodsSettingsOnNext;
  Function getGoodsSettingsOnError;

  Function deleteGoodOnComplete;
  Function deleteGoodOnError;

  GetGroupUseCase getGroupUseCase;
  GetGoodsUseCase getGoodsUseCase;
  GetGoodsSettingsUseCase getGoodsSettingsUseCase;
  SetGoodsSettingsUseCase setGoodsSettingsUseCase;

  DeleteGoodUseCase deleteGoodUseCase;

  GoodsPresenter(groupRepository, goodRepository, transactionRepository) {
    getGroupUseCase = GetGroupUseCase(groupRepository);
    getGoodsUseCase = GetGoodsUseCase(goodRepository);

    getGoodsSettingsUseCase = GetGoodsSettingsUseCase(goodRepository);
    setGoodsSettingsUseCase = SetGoodsSettingsUseCase(goodRepository);

    deleteGoodUseCase =
        DeleteGoodUseCase(goodRepository, transactionRepository);
  }

  @override
  void dispose() {
    getGroupUseCase.dispose();
    getGoodsUseCase.dispose();
    getGoodsSettingsUseCase.dispose();
    setGoodsSettingsUseCase.dispose();
  }

  void getGroups(groupId) => getGroupUseCase.execute(
      _GetGroupsUseCaseObserver(this), GetGroupUseCaseParams(groupId));

  void getGoods(groupId) => getGoodsUseCase.execute(
      _GetGoodsUseCaseObserver(this), GetGoodsUseCaseParams(groupId));

  void getSettings() =>
      getGoodsSettingsUseCase.execute(_GetGoodsSettingsUseCaseObserver(this));

  void setSettings(settings) => setGoodsSettingsUseCase.execute(
      _SetGoodsSettingsUseCaseObserver(this),
      SetGoodsSettingsUseCaseParams(settings));

  void deleteGood(int id) => deleteGoodUseCase.execute(
      DeleteGoodUseCaseObserver(this), DeleteGoodUseCaseParam(id));
}

class _GetGroupsUseCaseObserver implements Observer<List<Group>>{
  GoodsPresenter _presenter;
  _GetGroupsUseCaseObserver(this._presenter);
  @override
  void onComplete() {
    _presenter.getGroupsOnComplete();
  }

  @override
  void onError(e) {
    _presenter.getGroupsOnError(e);
  }

  @override
  void onNext(response) {
    _presenter.getGroupsOnNext(response);
  }
}
class _GetGoodsUseCaseObserver implements Observer<List<Good>>{
  GoodsPresenter _presenter;
  _GetGoodsUseCaseObserver(this._presenter);
  @override
  void onComplete() {
    _presenter.getGoodsOnComplete();
  }

  @override
  void onError(e) {
    _presenter.getGoodsOnError(e);
  }

  @override
  void onNext(response) {
    _presenter.getGoodsOnNext(response);
  }
}

class _GetGoodsSettingsUseCaseObserver implements Observer<GoodsSettings> {
  GoodsPresenter _presenter;

  _GetGoodsSettingsUseCaseObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.getGoodsSettingsOnError(e);
  }

  @override
  void onNext(settings) {
    _presenter.getGoodsSettingsOnNext(settings);
  }
}

class _SetGoodsSettingsUseCaseObserver implements Observer<void> {
  GoodsPresenter _presenter;

  _SetGoodsSettingsUseCaseObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {}

  @override
  void onNext(settings) {}
}

class DeleteGoodUseCaseObserver implements Observer<void> {
  GoodsPresenter _presenter;

  DeleteGoodUseCaseObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.deleteGoodOnComplete();
  }

  @override
  void onError(e) {
    _presenter.deleteGoodOnError(e);
  }

  @override
  void onNext(response) {}
}
