import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/usecases/base/items_usecases.dart';
abstract class CustomersUseCase extends ItemsUseCase<Customer>{
  Future<List<Customer>> getAllByStoreId(int storeId);
  Future<int> getCount(int storeId);
}