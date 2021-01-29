import 'dart:async';
import 'dart:io' as io;


import 'package:good_manager/model/Store.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

class DBHelper{
  static final DBHelper _instance = DBHelper.internal();

  factory DBHelper() => _instance;

  static Database _db;

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
        "CREATE TABLE Store(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");
  }
  Future<int> insertStore(Store store) async {
    var dbClient = await db;
    int res = await dbClient.insert("Store", store.toMap());
    return res;
  }

  Future<List<Store>> getStore() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Store');
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
    await dbClient.rawDelete('DELETE FROM Store WHERE id = ?', [store.id]);
    return res;
  }

  Future<bool> updateStore(Store store) async {
    var dbClient = await db;
    int res =   await dbClient.update("Store", store.toMap(),
        where: "id = ?", whereArgs: <int>[store.id]);
    return res > 0 ? true : false;
  }

}