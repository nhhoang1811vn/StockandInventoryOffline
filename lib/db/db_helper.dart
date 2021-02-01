import 'dart:async';
import 'dart:io' as io;


import 'package:good_manager/model/Store.dart';
import 'package:good_manager/model/Supplier.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

class DBHelper{
  static final DBHelper _instance = DBHelper.internal();

  factory DBHelper() => _instance;

  static Database _db;

  final String STORES_TABLE_NAME = "Stores";
  final String SUPPLIERS_TABLE_NAME = "Suppliers";

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DBHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE $STORES_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");
    await db.execute(""
        "CREATE TABLE $SUPPLIERS_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");
  }
  Future<int> insertStore(Store store) async {
    var dbClient = await db;
    int res = await dbClient.insert(STORES_TABLE_NAME, store.toMap());
    return res;
  }

  Future<List<Store>> getStore() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $STORES_TABLE_NAME');
    List<Store> stores = new List();
    for (int i = 0; i < list.length; i++) {
      var store = new Store(list[i]["name"], list[i]["description"]);
      store.setId(list[i]["id"]);
      stores.add(store);
    }
    print(stores.length);
    return stores;
  }
  Future<int> deleteStore(Store store) async {
    var dbClient = await db;

    int res =
    await dbClient.rawDelete('DELETE FROM $STORES_TABLE_NAME WHERE id = ?', [store.id]);
    return res;
  }

  Future<bool> updateStore(Store store) async {
    var dbClient = await db;
    int res =   await dbClient.update(STORES_TABLE_NAME, store.toMap(),
        where: "id = ?", whereArgs: <int>[store.id]);
    return res > 0 ? true : false;
  }

  //SUPPLIER

  Future<List<Supplier>> getSuppliers() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $SUPPLIERS_TABLE_NAME');
    List<Supplier> suppliers = new List();
    for (int i = 0; i < list.length; i++) {
      var supplier = new Supplier(list[i]["name"], list[i]["description"]);
      supplier.setId(list[i]["id"]);
      suppliers.add(supplier);
    }
    //print(suppliers.length);
    return suppliers;
  }
  Future<int> insertSupplier(Supplier item) async {
    var dbClient = await db;
    int res = await dbClient.insert(SUPPLIERS_TABLE_NAME, item.toMap());
    return res;
  }
  Future<bool> updateSupplier(Supplier item) async {
    var dbClient = await db;
    int res =   await dbClient.update(SUPPLIERS_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id]);
    return res > 0 ? true : false;
  }
}