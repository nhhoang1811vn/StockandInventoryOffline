
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/repositories/stores_repositories.dart';
import 'package:good_manager/domain/usecases/stores/stores_usecases.dart';
import 'package:injectable/injectable.dart';

import '../../../data/storage.dart';

@Injectable(as: StoresUseCase)
class StoresUseCaseImpl implements StoresUseCase{
  final StoresRepository repository;
  final Storage storage;
  StoresUseCaseImpl({required this.repository, required this.storage});
  @override
  Future<int> insert(Store item) {
    return repository.insert(item);
  }
  @override
  Future<bool> delete(int id) async{
    int count = await repository.getCount();
    if (count == 1){
      return Future.value(false);
    }else{
      bool result = await repository.delete(id);
      int selectedStoreId = storage.getSelectedStoreId();
      if (id == selectedStoreId && result){
        Store firstStore = await repository.getFirstStore();
        storage.setSelectedStoreId(firstStore.id!);
        storage.setSelectedStoreName(firstStore.name);
      }
      return Future.value(result);

    }
  }

  @override
  Future<bool> update(Store item) async{
    bool result = await repository.update(item);
    int selectedStoreId = storage.getSelectedStoreId();
    if (selectedStoreId == item.id && result){
      storage.setSelectedStoreName(item.name);
    }
    return Future.value(result);
  }

  @override
  Future<List<Store>> getAll() {
    return repository.getAll();
  }
}