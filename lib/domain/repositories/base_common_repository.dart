import 'package:good_manager/domain/entities/base_model.dart';
import 'package:good_manager/domain/entities/base_settings.dart';
import 'package:good_manager/domain/repositories/base_repository.dart';

abstract class BaseCommonRepository<M extends BaseModel, S extends BaseSettings>
    extends BaseRepository<M> {
  Future<S> getSettings();
  Future<void> setSettings(S settings);
}
