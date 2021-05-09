import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/Supplier.dart';
import 'package:good_manager/domain/repositories/supplier_repositories.dart';

class DataSupplierRepository implements SupplierRepository{
  //Singleton object of 'DataStoreRepository'
  static DataSupplierRepository _instance = DataSupplierRepository._internal();
  //Constructor
  DataSupplierRepository._internal(){

  }
  factory DataSupplierRepository() => _instance;

  var db = new DBHelper();

  @override
  Future<List<Supplier>> getAll() {
    return db.getSuppliers();
  }
  @override
  Future<bool> insert(Supplier supplier) {
    return db.insertSupplier(supplier);
  }

  @override
  Future<bool> update(Supplier supplier) {
    return db.updateSupplier(supplier);
  }

}