
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/usecases/customers/customers_usecases.dart';
import 'package:injectable/injectable.dart';

import '../../repositories/customer_repositories.dart';

@Injectable(as: CustomersUseCase)
class CustomersUseCaseImpl implements CustomersUseCase{
  final CustomersRepository repository;
  CustomersUseCaseImpl({required this.repository});
  @override
  Future<int> insert(Customer item) {
    return repository.insert(item);
  }
  @override
  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  @override
  Future<bool> update(Customer item) {
    return repository.update(item);
  }

  @override
  Future<List<Customer>> getAll() {
    return repository.getAll();
  }
  @override
  Future<List<Customer>> getAllByStoreId(int storeId) {
    return repository.getAllByStoreId(storeId);
  }
  @override
  Future<int> getCount(int storeId) {
    return repository.getCount(storeId);
    
  }
}