
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/repositories/suppliers_repositories.dart';
import 'package:good_manager/domain/usecases/suppliers/suppliers_usecases.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SuppliersUseCase)
class SuppliersUseCaseImpl implements SuppliersUseCase{
  final SuppliersRepository repository;
  SuppliersUseCaseImpl({required this.repository});
  @override
  Future<int> insert(Supplier item) {
    return repository.insert(item);
  }
  @override
  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  @override
  Future<bool> update(Supplier item) {
    return repository.update(item);
  }

  @override
  Future<List<Supplier>> getAll() {
    return repository.getAll();
  }
  @override
  Future<List<Supplier>> getAllByStoreId(int storeId) {
    return repository.getAllByStoreId(storeId);
  }
  @override
  Future<int> getCount(int storeId) {
    return repository.getCount(storeId);
    
  }

  @override
  Future<Supplier> get(int id) {
    return repository.get(id);
  }
}