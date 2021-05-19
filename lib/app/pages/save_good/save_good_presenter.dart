import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/usecases/goods/insert_good_usecase.dart';
import 'package:good_manager/domain/usecases/goods/update_group_usecase.dart';


class SaveGoodPresenter extends Presenter {
  Function insertGoodOnComplete;
  Function insertGoodOnError;

  Function updateGoodOnComplete;
  Function updateGoodOnError;

  InsertGoodUseCase _insertGoodUseCase;
  UpdateGoodUseCase _updateGoodUseCase;

  SaveGoodPresenter(_repository) {
    _insertGoodUseCase = InsertGoodUseCase(_repository);
    _updateGoodUseCase = UpdateGoodUseCase(_repository);
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

class _InsertGoodUseCaseObserver implements Observer<void> {
  SaveGoodPresenter _presenter;

  _InsertGoodUseCaseObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.insertGoodOnComplete();
  }

  @override
  void onError(e) {
    _presenter.insertGoodOnError(e);
  }

  @override
  void onNext(void response) {}
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
