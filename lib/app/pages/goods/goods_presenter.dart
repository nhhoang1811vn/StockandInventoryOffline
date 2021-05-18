import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/usecases/groups/get_group_usecase.dart';

class GoodsPresenter extends Presenter {
  Function getGroupsOnNext;
  Function getGroupsOnComplete;
  Function getGroupsOnError;

  GetGroupUseCase getGroupUseCase;
  GoodsPresenter(groupRepository){
    getGroupUseCase = GetGroupUseCase(groupRepository);
  }

  @override
  void dispose() {
    getGroupUseCase.dispose();
  }
  void getGroups(storeId, groupId) => getGroupUseCase.execute(_GetGroupsUseCaseObserver(this), GetGroupUseCaseParams(storeId, groupId));

/*Future<List<GoodItem>> getItems(int groupId){
    var completer = new Completer<List<GoodItem>>();
    db.getGroups(groupId).then((value) {
      List<GoodItem> data = [];
      value.forEach((element) {
        GoodItem item = new GoodItem();
        item.id = element.id;
        item.quality = 10;
        item.group = element;
        data.add(item);
      });
      db.getGoods(groupId).then((value){
        value.forEach((element) {
          GoodItem item = new GoodItem();
          item.id = element.id;
          item.quality = 5;
          item.good = element;
          data.add(item);
        });
        completer.complete(data);
      });
    });
    return completer.future;
  }*/
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