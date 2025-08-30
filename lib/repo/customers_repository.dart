import 'package:injectable/injectable.dart';

import '../data/data.dart';
import '../domain/entity/entity.dart';

@LazySingleton()
class CustomersRepository {
  final DBHelper db;

  CustomersRepository({required this.db});

  Future<int> insert(Customer item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertCustomer(item);
  }

  Future<bool> delete(int id) {
    return db.deleteCustomer(id);
  }

  Future<Customer> get(int id) {
    return db.getCustomer(id);
  }

  Future<List<Customer>> getAllByStoreId(int storeId) {
    return db.getCustomers(storeId);
  }

  Future<bool> update(Customer item) {
    item.updatedDate = DateTime.now();
    return db.updateCustomer(item);
  }

  Future<int> getCount(int storeId) {
    return db.getCountCustomer(storeId);
  }
}
