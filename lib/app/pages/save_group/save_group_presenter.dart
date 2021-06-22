import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/usecases/groups/insert_group_usecase.dart';
import 'package:good_manager/domain/usecases/groups/update_group_usecase.dart';

class SaveGroupPresenter extends Presenter {
  Function insertGroupOnNext;
  Function insertGroupOnError;

  Function updateGroupOnComplete;
  Function updateGroupOnError;

  InsertGroupUseCase _insertGroupUseCase;
  UpdateGroupUseCase _updateGroupUseCase;

  SaveGroupPresenter(_repository) {
    _insertGroupUseCase = InsertGroupUseCase(_repository);
    _updateGroupUseCase = UpdateGroupUseCase(_repository);
  }

  insert(Group item) => _insertGroupUseCase.execute(
      _InsertGroupUseCaseObserver(this), InsertGroupUseCaseParams(item));

  update(Group item) => _updateGroupUseCase.execute(
      _UpdateGroupUseCaseObserver(this), UpdateGroupUseCaseParams(item));

  @override
  void dispose() {
    _insertGroupUseCase.dispose();
    _updateGroupUseCase.dispose();
  }
}

class _InsertGroupUseCaseObserver implements Observer<int> {
  SaveGroupPresenter _presenter;

  _InsertGroupUseCaseObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.insertGroupOnError(e);
  }

  @override
  void onNext(int groupId) {
    _presenter.insertGroupOnNext(groupId);
  }
}

class _UpdateGroupUseCaseObserver implements Observer<void> {
  SaveGroupPresenter _presenter;

  _UpdateGroupUseCaseObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.updateGroupOnComplete();
  }

  @override
  void onError(e) {
    _presenter.updateGroupOnError(e);
  }

  @override
  void onNext(void response) {}
}
