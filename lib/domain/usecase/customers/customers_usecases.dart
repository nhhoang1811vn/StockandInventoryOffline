import 'package:injectable/injectable.dart';

import '../../../repo/repo.dart';
import '../../entity/entity.dart';
import '../base/items_usecases.dart';

@LazySingleton()
class CustomersUseCase extends ItemsUseCase<Customer> {
  final CustomersRepository repository;

  CustomersUseCase({required this.repository});

  Future<int> insert(Customer item) {
    return repository.insert(item);
  }

  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  Future<bool> update(Customer item) {
    return repository.update(item);
  }

  Future<List<Customer>> getAllByStoreId(int storeId) {
    return repository.getAllByStoreId(storeId);
  }

  Future<int> getCount(int storeId) {
    return repository.getCount(storeId);
  }

  Future<Customer> get(int id) {
    return repository.get(id);
  }
}
