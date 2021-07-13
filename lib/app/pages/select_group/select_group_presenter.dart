import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/usecases/base_get_items_usecase.dart';

class SelectGroupPresenter extends Presenter {
  Function getGroupsOnNext;
  Function getGroupsOnError;

  BaseGetItemsUseCase<Group> getItemsUseCase;

  SelectGroupPresenter(repository) : super() {
    getItemsUseCase = BaseGetItemsUseCase(repository);
  }

  @override
  void dispose() {
    getItemsUseCase.dispose();
  }

  void getGroups() {
    getItemsUseCase.execute(GetGroupsObserver(this));
  }
}

class GetGroupsObserver extends Observer<List<Group>> {
  SelectGroupPresenter presenter;

  GetGroupsObserver(this.presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    presenter.getGroupsOnError(e);
  }

  @override
  void onNext(List<Group> response) {
    presenter.getGroupsOnNext(response);
  }
}
