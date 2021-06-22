import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/usecases/stores/insert_store_usecase.dart';
import 'package:good_manager/domain/usecases/stores/update_store_usecase.dart';

class SaveStorePresenter extends Presenter {
  Function insertStoreOnNext;
  Function insertStoreOnError;

  Function updateStoreOnComplete;
  Function updateStoreOnError;

  InsertStoreUseCase _insertStoreUseCase;
  UpdateStoreUseCase _updateStoreUseCase;

  SaveStorePresenter(storeRepository) {
    _insertStoreUseCase = InsertStoreUseCase(storeRepository);
    _updateStoreUseCase = UpdateStoreUseCase(storeRepository);
  }

  void dispose() {
    _insertStoreUseCase.dispose();
    _updateStoreUseCase.dispose();
  }

  void insert(Store store) => _insertStoreUseCase.execute(
      _InsertStoreUseCaseObserver(this), InsertStoreUseCaseParams(store));

  void update(Store store) => _updateStoreUseCase.execute(
      _UpdateStoreUseCaseObserver(this), UpdateStoreUseCaseParams(store));
}

class _InsertStoreUseCaseObserver implements Observer<int> {
  SaveStorePresenter _presenter;

  _InsertStoreUseCaseObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.insertStoreOnError(e);
  }

  @override
  void onNext(int storeId) {
    _presenter.insertStoreOnNext(storeId);
  }
}
class _UpdateStoreUseCaseObserver implements Observer<void>{
  SaveStorePresenter _presenter;
  _UpdateStoreUseCaseObserver(this._presenter);
  @override
  void onComplete() {
    _presenter.updateStoreOnComplete();
  }

  @override
  void onError(e) {
    _presenter.updateStoreOnError(e);
  }

  @override
  void onNext(void response) {
  }
}