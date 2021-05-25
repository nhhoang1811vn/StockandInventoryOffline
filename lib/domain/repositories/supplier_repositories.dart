
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/supplier_settings.dart';

import 'base_repository.dart';

abstract class SupplierRepository extends BaseRepository<Supplier>{
  Future<SupplierSettings> getSettings();
  Future<bool> setSettings(SupplierSettings settings);
}