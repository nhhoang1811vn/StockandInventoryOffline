
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/usecases/base_insert_item_usecase.dart';

class OnBoardingPresenter extends Presenter {
  Function insertStoreOnNext;
  Function insertStoreOnError;

  //var db = new DBHelper();
  BaseInsertItemUseCase<Store> insertItemUseCase;

  OnBoardingPresenter(storeRepository) {
    insertItemUseCase = BaseInsertItemUseCase(storeRepository);
  }

  void setFirstTime(bool value) {
    appDataManager.sharedPrefsHelper.setFirstTime(value);
  }

  void setSelectedStoreId(int storeId) async {
    appDataManager.sharedPrefsHelper.setSelectedStoreId(storeId);
  }

  void insert(Store store) => insertItemUseCase.execute(
      InsertStoreUseCaseObserver(this), BaseInsertItemUseCaseParam(store));

  @override
  void dispose() {
    insertItemUseCase.dispose();
  }
}

class InsertStoreUseCaseObserver extends Observer<int> {
  OnBoardingPresenter presenter;

  InsertStoreUseCaseObserver(this.presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    presenter.insertStoreOnError(e);
  }

  @override
  void onNext(response) {
    presenter.insertStoreOnNext(response);
  }
}