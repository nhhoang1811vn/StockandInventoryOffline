import 'package:injectable/injectable.dart';

import '../../../data/app_settings.dart';
import '../../../repo/repo.dart';
import '../../entity/entity.dart';
import '../base/items_usecases.dart';

@LazySingleton()
class StoresUseCase extends ItemsUseCase<Store> {
  final StoresRepository repository;

  StoresUseCase({required this.repository});

  Future<int> insert(Store item) {
    return repository.insert(item);
  }

  Future<bool> delete(int id) async {
    int count = await repository.getCount();
    if (count == 1) {
      return Future.value(false);
    } else {
      bool result = await repository.delete(id);
      int selectedStoreId = AppSettings.getSelectedStoreId();
      if (id == selectedStoreId && result) {
        Store firstStore = await repository.getFirstStore();
        AppSettings.setSelectedStoreId(firstStore.id!);
        AppSettings.setSelectedStoreName(firstStore.name);
      }
      return Future.value(result);
    }
  }

  Future<bool> update(Store item) async {
    bool result = await repository.update(item);
    int selectedStoreId = AppSettings.getSelectedStoreId();
    if (selectedStoreId == item.id && result) {
      AppSettings.setSelectedStoreName(item.name);
    }
    return Future.value(result);
  }

  Future<List<Store>> getAll() {
    return repository.getAll();
  }

  Future<int> getCount() {
    return repository.getCount();
  }
}
