import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/usecases/goods/insert_good_usecase.dart';
import 'package:good_manager/domain/usecases/goods/update_good_usecase.dart';

class SaveGoodPresenter extends Presenter {
  Function insertGoodOnNext;
  Function insertGoodOnError;

  Function updateGoodOnComplete;
  Function updateGoodOnError;

  InsertGoodUseCase _insertGoodUseCase;
  UpdateGoodUseCase _updateGoodUseCase;

  SaveGoodPresenter(_goodRepository, _transactionRepository) {
    _insertGoodUseCase = InsertGoodUseCase(_goodRepository);
    _updateGoodUseCase = UpdateGoodUseCase(_goodRepository);
  }

  insert(Good item) => _insertGoodUseCase.execute(
      _InsertGoodUseCaseObserver(this), InsertGoodUseCaseParams(item));

  update(Good item) => _updateGoodUseCase.execute(
      _UpdateGoodUseCaseObserver(this), UpdateGoodUseCaseParams(item));

  @override
  void dispose() {
    _insertGoodUseCase.dispose();
    _updateGoodUseCase.dispose();
  }
}

class _InsertGoodUseCaseObserver implements Observer<int> {
  SaveGoodPresenter _presenter;

  _InsertGoodUseCaseObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.insertGoodOnError(e);
  }

  @override
  void onNext(int goodId) {
    _presenter.insertGoodOnNext(goodId);
  }
}

class _UpdateGoodUseCaseObserver implements Observer<void> {
  SaveGoodPresenter _presenter;

  _UpdateGoodUseCaseObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.updateGoodOnComplete();
  }

  @override
  void onError(e) {
    _presenter.updateGoodOnError(e);
  }

  @override
  void onNext(void response) {}
}
