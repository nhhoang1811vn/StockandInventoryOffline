import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/repositories/base_repository.dart';

abstract class CustomersRepository extends BaseRepository<Customer>{
  Future<List<Customer>> getAllByStoreId(int storeId);
  Future<int> getCount(int storeId);
}
