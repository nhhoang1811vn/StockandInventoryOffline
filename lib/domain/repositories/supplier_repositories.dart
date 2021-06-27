
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/supplier_settings.dart';
import 'package:good_manager/domain/repositories/base_common_repository.dart';

abstract class SupplierRepository
    extends BaseCommonRepository<Supplier, SupplierSettings> {}