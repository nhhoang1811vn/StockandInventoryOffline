
import 'package:good_manager/domain/entities/Supplier.dart';
import 'package:good_manager/domain/entities/SupplierSettings.dart';

abstract class SupplierRepository{
  Future<bool> insert(Supplier supplier);

  Future<bool> update(Supplier supplier);

  Future<bool> delete(int id);

  Future<List<Supplier>> getAll();

  Future<SupplierSettings> getSettings();

  Future<bool> setSettings(SupplierSettings settings);
}