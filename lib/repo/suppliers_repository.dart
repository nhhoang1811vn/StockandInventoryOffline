import 'package:injectable/injectable.dart';

import '../data/data.dart';
import '../domain/entity/entity.dart';

@LazySingleton()
class SuppliersRepository {
  final DBHelper db;

  SuppliersRepository({required this.db});

  Future<int> insert(Supplier item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertSupplier(item);
  }

  Future<bool> delete(int id) {
    return db.deleteSupplier(id);
  }

  Future<Supplier> get(int id) {
    return db.getSupplier(id);
  }

  Future<List<Supplier>> getAllByStoreId(int storeId) {
    return db.getSuppliers(storeId);
  }

  Future<bool> update(Supplier item) {
    item.updatedDate = DateTime.now();
    return db.updateSupplier(item);
  }

  Future<int> getCount(int storeId) {
    return db.getCountSupplier(storeId);
  }
}
