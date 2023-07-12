/*
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/base_model.dart';
import 'package:good_manager/domain/usecases/base_insert_item_usecase.dart';
import 'package:good_manager/domain/usecases/base_update_item_usecase.dart';

class BaseSaveItemPresenter<M extends BaseModel> extends Presenter {
  Function insertItemOnNext;
  Function insertItemOnError;

  Function updateItemOnComplete;
  Function updateItemOnError;

  BaseInsertItemUseCase<M> _insertItemUseCase;
  BaseUpdateItemUseCase<M> _updateSupplierUseCase;

  BaseSaveItemPresenter(repository) {
    _insertItemUseCase = BaseInsertItemUseCase(repository);
    _updateSupplierUseCase = BaseUpdateItemUseCase(repository);
  }

  insert(M item) => _insertItemUseCase.execute(
      _InsertItemUseCaseObserver(this), BaseInsertItemUseCaseParam(item));

  update(M item) => _updateSupplierUseCase.execute(
      _UpdateItemUseCaseObserver(this), BaseUpdateItemUseCaseParam(item));

  @override
  void dispose() {
    _insertItemUseCase.dispose();
    _updateSupplierUseCase.dispose();
  }
}

class _InsertItemUseCaseObserver implements Observer<int> {
  BaseSaveItemPresenter _presenter;

  _InsertItemUseCaseObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.insertItemOnError(e);
  }

  @override
  void onNext(int id) {
    _presenter.insertItemOnNext(id);
  }
}

class _UpdateItemUseCaseObserver implements Observer<void> {
  BaseSaveItemPresenter _presenter;

  _UpdateItemUseCaseObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.updateItemOnComplete();
  }

  @override
  void onError(e) {
    _presenter.updateItemOnError(e);
  }

  @override
  void onNext(void response) {}
}
*/
