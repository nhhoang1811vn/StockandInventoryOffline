import 'package:good_manager/domain/entities/Store.dart';

abstract class StoreRepository{
  Future<int> insert(Store store);
  Future<List<Store>> getAll();
}