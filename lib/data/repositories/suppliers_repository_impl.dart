import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/repositories/suppliers_repositories.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SuppliersRepository)
class SuppliersRepositoryImpl implements SuppliersRepository {
  SuppliersRepositoryImpl();

  var db = new DBHelper();
  @override
  Future<int> insert(Supplier item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertSupplier(item);
  }

  @override
  Future<bool> delete(int id) {
    return db.deleteSupplier(id);
  }

  @override
  Future<Supplier> get(int id) {
    return db.getSupplier(id);
  }

  @override
  Future<List<Supplier>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }
  @override
  Future<List<Supplier>> getAllByStoreId(int storeId) {
    return db.getSuppliers(storeId);
  }

  @override
  Future<bool> update(Supplier item) {
    item.updatedDate = DateTime.now();
    return db.updateSupplier(item);
  }

  @override
  Future<int> getCount(int storeId) {
    return db.getCountSupplier(storeId);
  }
}
