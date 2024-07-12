import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/repositories/base_repository.dart';

abstract class SuppliersRepository extends BaseRepository<Supplier>{
  Future<List<Supplier>> getAllByStoreId(int storeId);
  Future<int> getCount(int storeId);
}