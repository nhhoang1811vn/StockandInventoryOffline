import 'package:good_manager/domain/entities/Store.dart';

abstract class StoreRepository{
  Future<bool> insert(Store store);
  Future<bool> update(Store store);
  Future<List<Store>> getAll();
}