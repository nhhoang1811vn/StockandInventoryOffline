import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/entities/stores_settings.dart';
import 'package:good_manager/domain/repositories/base_common_repository.dart';

abstract class StoreRepository
    extends BaseCommonRepository<Store, StoresSettings> {}
