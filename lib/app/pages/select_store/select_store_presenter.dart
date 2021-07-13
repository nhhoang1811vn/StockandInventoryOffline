import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/usecases/base_get_items_usecase.dart';

class SelectStorePresenter extends Presenter {
  Function getStoresOnNext;
  Function getStoresOnError;

  BaseGetItemsUseCase<Store> getItemsUseCase;

  SelectStorePresenter(repository) : super() {
    getItemsUseCase = BaseGetItemsUseCase(repository);
  }

  @override
  void dispose() {
    getItemsUseCase.dispose();
  }

  void getStores() {
    getItemsUseCase.execute(GetStoresObserver(this));
  }
}

class GetStoresObserver extends Observer<List<Store>> {
  SelectStorePresenter presenter;

  GetStoresObserver(this.presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    presenter.getStoresOnError(e);
  }

  @override
  void onNext(List<Store> response) {
    presenter.getStoresOnNext(response);
  }
}
