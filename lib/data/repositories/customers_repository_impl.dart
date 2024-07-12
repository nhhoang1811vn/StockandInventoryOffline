import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/repositories/customer_repositories.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CustomersRepository)
class CustomersRepositoryImpl implements CustomersRepository {
  CustomersRepositoryImpl();

  var db = new DBHelper();
  @override
  Future<int> insert(Customer item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertCustomer(item);
  }

  @override
  Future<bool> delete(int id) {
    return db.deleteCustomer(id);
  }

  @override
  Future<Customer> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<Customer>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }
  @override
  Future<List<Customer>> getAllByStoreId(int storeId) {
    return db.getCustomers(storeId);
  }

  @override
  Future<bool> update(Customer item) {
    item.updatedDate = DateTime.now();
    return db.updateCustomer(item);
  }

  @override
  Future<int> getCount(int storeId) {
    return db.getCountCustomer(storeId);
  }
}
