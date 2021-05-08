import 'package:good_manager/domain/entities/Store.dart';
import 'package:good_manager/domain/entities/Supplier.dart';

abstract class SupplierRepository{
  Future<bool> insert(Supplier supplier);
  Future<bool> update(Supplier supplier);
  Future<List<Supplier>> getAll();
}