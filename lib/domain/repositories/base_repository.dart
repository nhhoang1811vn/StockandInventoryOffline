import 'package:good_manager/domain/entities/base_model.dart';

abstract class BaseRepository<M extends BaseModel> {
  Future<int> insert(M item);

  Future<bool> update(M item);

  Future<List<M>> getAll();

  Future<bool> delete(int id);
}
