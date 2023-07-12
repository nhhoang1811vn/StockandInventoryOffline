
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/repositories/stores_repositories.dart';
import 'package:good_manager/domain/usecases/stores/stores_usecases.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: StoresUseCase)
class StoresUseCaseImpl implements StoresUseCase{
  final StoresRepository repository;
  StoresUseCaseImpl({required this.repository});
  @override
  Future<int> insert(Store item) {
    return repository.insert(item);
  }
  @override
  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  @override
  Future<bool> update(Store item) {
    return repository.update(item);
  }

  @override
  Future<List<Store>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }
}