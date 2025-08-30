import 'package:injectable/injectable.dart';

import '../data/data.dart';
import '../domain/entity/entity.dart';

@LazySingleton()
class StoresRepository {
  final DBHelper db;

  StoresRepository({required this.db});

  Future<bool> delete(int id) {
    return db.deleteStore(id);
  }

  Future<Store> get(int id) {
    return db.getStore(id);
  }

  Future<List<Store>> getAll() {
    return db.getStores();
  }

  Future<int> getCount() {
    return db.getCountStore();
  }

  Future<int> insert(Store item) {
    return db.insertStore(item);
  }

  Future<bool> update(Store item) {
    return db.updateStore(item);
  }

  Future<Store> getFirstStore() async {
    List<Store> stores = await db.getStores();
    return Future.value(stores.first);
  }
}
