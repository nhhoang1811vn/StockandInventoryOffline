import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/stores_repositories.dart';

@Injectable(as: StoresRepository)
class StoresRepositoryImpl implements StoresRepository {
  StoresRepositoryImpl();

  var db = new DBHelper();

  @override
  Future<bool> delete(int id) {
    return db.deleteStore(id);
  }

  @override
  Future<Store> get(int id) {
    return db.getStore(id);
  }

  @override
  Future<List<Store>> getAll() {
    return db.getStores();
  }

  @override
  Future<int> getCount() {
    return db.getCountStore();
  }

  @override
  Future<int> insert(Store item) {
    return db.insertStore(item);
  }

  @override
  Future<bool> update(Store item) {
    return db.updateStore(item);
  }

  @override
  Future<Store> getFirstStore() async{
    List<Store> stores = await db.getStores();
    return Future.value(stores.first);
  }
}
