import 'package:good_manager/domain/entities/base_model.dart';

abstract class ItemsUseCase<M extends BaseModel>{
  Future<List<M>> getAll();
  Future<int> insert(M item);
  Future<bool> update(M item);
  Future<bool> delete(int id);
  Future<M> get(int id);
}