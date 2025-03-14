import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/repositories/base_repository.dart';

abstract class StoresRepository
    extends BaseRepository<Store> {
  Future<int> getCount();
  Future<Store> getFirstStore();
}
