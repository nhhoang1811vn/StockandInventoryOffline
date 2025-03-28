import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:good_manager/common/path_utils.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../domain/entities/payment.dart';
class DBHelper {
  static final DBHelper _instance = DBHelper.internal();

  factory DBHelper() => _instance;

  static Database? _db;

  static const String STORES_TABLE_NAME = "Stores";
  static const String SUPPLIERS_TABLE_NAME = "Suppliers";
  static const String CUSTOMERS_TABLE_NAME = "Customers";

  static const String GROUPS_TABLE_NAME = "Groups";
  static const String GOODS_TABLE_NAME = "Goods";

  static const String DOCUMENTS_TABLE_NAME = "Documents";
  static const String DOCUMENT_TRANSACTIONS_TABLE_NAME = "Transactions";
  static const String EXPENSES_TABLE_NAME = "Expenses";
  static const String PAYMENTS_TABLE_NAME = "Payments";

  static const String MEDIA_TABLE_NAME = "Medias";

  Future<Database> get db async {
    if (_db != null) return _db!;
    if (Platform.isWindows) {
      _db = await initDBWindow();
    }else{
      _db = await initDb();
    }
    return _db!;
  }

  DBHelper.internal();

  Map<int, List<String>> migrationScripts = {
    //version 2 alter quantity from INT to REAL
    2: [
      //create temp table
      "CREATE TABLE IF NOT EXISTS Temp(id INTEGER PRIMARY KEY,createdDate INTEGER, updatedDate INTEGER, documentId INTEGER NOT NULL, goodId INTEGER NOT NULL,storeId INTEGER NOT NULL, quantity REAL, price REAL,documentType INTEGER, " +
          "FOREIGN KEY(documentId) REFERENCES $DOCUMENTS_TABLE_NAME(id) ON DELETE CASCADE, " +
          "FOREIGN KEY(goodId) REFERENCES $GOODS_TABLE_NAME(id) ON DELETE CASCADE," +
          "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id) ON DELETE CASCADE)",
      //copy data
      "INSERT INTO Temp(id, createdDate, updatedDate, documentId, goodId, storeId, quantity, price, documentType) " +
          "SELECT id, createdDate, updatedDate, documentId, goodId, storeId, quantity, price, documentType FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME",
      //remove
      "DROP TABLE $DOCUMENT_TRANSACTIONS_TABLE_NAME",
      //rename
      "ALTER TABLE Temp RENAME TO $DOCUMENT_TRANSACTIONS_TABLE_NAME",

      "CREATE TABLE IF NOT EXISTS $MEDIA_TABLE_NAME(id INTEGER PRIMARY KEY, goodId INTEGER NOT NULL, media BLOB, "
          "FOREIGN KEY(goodId) REFERENCES $GOODS_TABLE_NAME(id) ON DELETE CASCADE)"
    ],
    3: [
      "DROP TABLE $PAYMENTS_TABLE_NAME",
      "CREATE TABLE IF NOT EXISTS $PAYMENTS_TABLE_NAME(id INTEGER PRIMARY KEY,name TEXT, description TEXT, createdDate INTEGER, updatedDate INTEGER,date INTEGER, amount REAL, type INTEGER NOT NULL, documentId INTEGER, storeId INTEGER NOT NULL, " +
          "FOREIGN KEY(documentId) REFERENCES $DOCUMENTS_TABLE_NAME(id) ON DELETE CASCADE, " +
          "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id) ON DELETE CASCADE)"
    ]
  };

  reopen() async{
    _db?.close();
    _db = await initDb();
  }
  reset() async{
    await _db?.close();
    String? path = _db?.path;
    if (path != null){
      await deleteDatabase(path);
    }
    _db = await initDb();
  }

  initDb() async {
    String path = await PathUtils().getDatabasePath();
    var theDb = await openDatabase(path, version: 3, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return theDb;
  }
  initDBWindow() async{
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    String path = await PathUtils().getDatabasePath();
    var db = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 3,
        onCreate: (db, version) async {
          _onCreate(db, version);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          try {
            _onUpgrade(db, oldVersion, newVersion);
          } catch (e) {
            // Delete the existing database
            await deleteDatabase(path);
            // Reinitialize the database
            return await initDBWindow();
          }
        }
      )
    );
    return db;
  }
  void _onUpgrade(Database db, int oldVersion, int newVersion) async{
    for (int i = oldVersion + 1; i <= newVersion; i++) {
      var scripts = migrationScripts[i]!;
      for (int j = 0; j< scripts.length; j++){
        await db.execute(scripts[j]);
      }
    }
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $STORES_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, createdDate INTEGER, updatedDate INTEGER)");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $EXPENSES_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, date INTEGER, amount REAL,storeId INTEGER, createdDate INTEGER, updatedDate INTEGER, " +
            "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id) ON DELETE CASCADE)");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $SUPPLIERS_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, address TEXT, email TEXT, phone TEXT, taxID TEXT, bankDetail TEXT, storeId INTEGER, createdDate INTEGER, updatedDate INTEGER, " +
            "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id) ON DELETE CASCADE)");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $CUSTOMERS_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, address TEXT, email TEXT, phone TEXT, taxID TEXT, bankDetail TEXT, storeId INTEGER, createdDate INTEGER, updatedDate INTEGER, " +
            "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id) ON DELETE CASCADE)");

    await db.execute(
        "CREATE TABLE IF NOT EXISTS $DOCUMENTS_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, date INTEGER, type INTEGER,paymentStatus INTEGER, storeId INTEGER ,supplierId INTEGER, customerId INTEGER, createdDate INTEGER, updatedDate INTEGER, " +
            "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id) ON DELETE CASCADE," +
            "FOREIGN KEY(supplierId) REFERENCES $SUPPLIERS_TABLE_NAME(id) ON DELETE SET NULL," +
            "FOREIGN KEY(customerId) REFERENCES $CUSTOMERS_TABLE_NAME(id) ON DELETE SET NULL)");

    await db.execute(
        "CREATE TABLE IF NOT EXISTS $GROUPS_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, barCode TEXT UNIQUE, storeId INTEGER NOT NULL, groupId INTEGER, files TEXT, createdDate INTEGER, updatedDate INTEGER, " +
            "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id) ON DELETE CASCADE," + ""
            "FOREIGN KEY(groupId) REFERENCES $GROUPS_TABLE_NAME(id) ON DELETE CASCADE)");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $GOODS_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, barCode TEXT UNIQUE, purchasePrice REAL, salePrice REAL,  storeId INTEGER NOT NULL, groupId INTEGER, files TEXT, createdDate INTEGER, updatedDate INTEGER, " +
            "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id) ON DELETE CASCADE," +
            "FOREIGN KEY(groupId) REFERENCES $GROUPS_TABLE_NAME(id) ON DELETE CASCADE)");

    await db.execute(
        "CREATE TABLE IF NOT EXISTS $DOCUMENT_TRANSACTIONS_TABLE_NAME(id INTEGER PRIMARY KEY,createdDate INTEGER, updatedDate INTEGER, documentId INTEGER NOT NULL, goodId INTEGER NOT NULL,storeId INTEGER NOT NULL, quantity REAL, price REAL,documentType INTEGER, " +
            "FOREIGN KEY(documentId) REFERENCES $DOCUMENTS_TABLE_NAME(id) ON DELETE CASCADE, " +
            "FOREIGN KEY(goodId) REFERENCES $GOODS_TABLE_NAME(id) ON DELETE CASCADE," +
            "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id) ON DELETE CASCADE)");

    await db.execute(
      "CREATE TABLE IF NOT EXISTS $PAYMENTS_TABLE_NAME(id INTEGER PRIMARY KEY,name TEXT, description TEXT, createdDate INTEGER, updatedDate INTEGER,date INTEGER, amount REAL, type INTEGER NOT NULL,documentId INTEGER, storeId INTEGER NOT NULL, " +
      "FOREIGN KEY(documentId) REFERENCES $DOCUMENTS_TABLE_NAME(id) ON DELETE CASCADE," +
      "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id) ON DELETE CASCADE)"
    );

    await db.execute(
      "CREATE TABLE IF NOT EXISTS $MEDIA_TABLE_NAME(id INTEGER PRIMARY KEY, goodId INTEGER NOT NULL, media BLOB, "
          "FOREIGN KEY(goodId) REFERENCES $GOODS_TABLE_NAME(id) ON DELETE CASCADE)"
    );
  }
  ///STORE
  Future<int> insertStore(Store item) async {
    var dbClient = await db;
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    int res = await dbClient.insert(STORES_TABLE_NAME, item.toMap());
    return res;
  }

  Future<Store> getStore(int id) async {
    var dbClient = await db;
    var list = await dbClient
        .rawQuery('SELECT * FROM $STORES_TABLE_NAME where id = ?', [id]);
    if (list.isNotEmpty) {
      return Store.map(list.first);
    }
    throw Exception("");
    //return null;
  }

  Future<List<Store>> getStores() async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM $STORES_TABLE_NAME');
    List<Store> stores = [];
    for (int i = 0; i < list.length; i++) {
      Store store = Store();
      store.map(list[i]);
      stores.add(store);
    }
    print(stores.length);
    return stores;
  }

  Future<bool> deleteStore(int id) async {
    var dbClient = await db;
    dbClient.execute("PRAGMA foreign_keys = ON;");
    int res = await dbClient
        .rawDelete('DELETE FROM $STORES_TABLE_NAME WHERE id = ?', [id]);
    return res > 0;
  }

  Future<bool> updateStore(Store item) async {
    var dbClient = await db;
    item.updatedDate = DateTime.now();
    int res = await dbClient.update(STORES_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id!]);
    return res == 1;
  }

  //SUPPLIER
  Future<List<Supplier>> getSuppliers(int storeId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $SUPPLIERS_TABLE_NAME WHERE storeId = ?', [storeId]);
    List<Supplier> suppliers = [];
    for (int i = 0; i < list.length; i++) {
      Supplier supplier = Supplier.map(list[i]);
      supplier.numberDocument = await getCountDocumentBySupplierId(supplier.id!);
      suppliers.add(supplier);
    }
    return suppliers;
  }

  Future<int> getCountDocumentBySupplierId(int supplierId) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $DOCUMENTS_TABLE_NAME WHERE supplierId = ?",
        [supplierId]);

    int? count = Sqflite.firstIntValue(result);
    return count == null ? 0 : count;
  }

  Future<int> insertSupplier(Supplier item) async {
    var dbClient = await db;
    int res = await dbClient.insert(SUPPLIERS_TABLE_NAME, item.toMap());
    return res;
  }

  Future<bool> updateSupplier(Supplier item) async {
    var dbClient = await db;
    int res = await dbClient.update(SUPPLIERS_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id!]);
    return res == 1;
  }

  Future<Supplier?> getSupplier(int? id) async {
    var dbClient = await db;
    var list = await dbClient
        .rawQuery('SELECT * FROM $SUPPLIERS_TABLE_NAME where id = ?', [id]);
    if (list.isNotEmpty) {
      return Supplier.map(list.first);
    }
    return null;
  }

  Future<bool> deleteSupplier(int id) async {
    var dbClient = await db;

    int res = await dbClient
        .rawDelete('DELETE FROM $SUPPLIERS_TABLE_NAME WHERE id = ?', [id]);
    return res == 1;
  }
  Future<int> getCountSupplier(int storeId) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $SUPPLIERS_TABLE_NAME WHERE storeId = ?", [storeId]);

    int? count = Sqflite.firstIntValue(result);
    return count == null ? 0 : count;
  }

  //CUSTOMER
  Future<List<Customer>> getCustomers(int storeId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $CUSTOMERS_TABLE_NAME WHERE storeId = ?', [storeId]);
    List<Customer> customers = [];
    for (int i = 0; i < list.length; i++) {
      Customer customer = Customer.map(list[i]);
      customer.numberDocument = await getCountDocumentByCustomerId(customer.id!);
      customers.add(customer);
    }
    return customers;
  }
  Future<int> getCountCustomer(int storeId) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $CUSTOMERS_TABLE_NAME WHERE storeId = ?", [storeId]);

    int? count = Sqflite.firstIntValue(result);
    return count == null ? 0 : count;
  }

  Future<int> getCountDocumentByCustomerId(int customerId) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $DOCUMENTS_TABLE_NAME WHERE customerId = ?",
        [customerId]);

    int? count = Sqflite.firstIntValue(result);
    return count == null ? 0 : count;
  }

  Future<int> insertCustomer(Customer item) async {
    var dbClient = await db;
    int res = await dbClient.insert(CUSTOMERS_TABLE_NAME, item.toMap());
    return res;
  }

  Future<bool> updateCustomer(Customer item) async {
    var dbClient = await db;
    item.updatedDate = DateTime.now();
    int res = await dbClient.update(CUSTOMERS_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id!]);
    return res == 1;
  }

  Future<bool> deleteCustomer(int id) async {
    var dbClient = await db;

    int res = await dbClient
        .rawDelete('DELETE FROM $CUSTOMERS_TABLE_NAME WHERE id = ?', [id]);
    return res == 1;
  }

  Future<Customer?> getCustomer(int? id) async {
    var dbClient = await db;
    var list = await dbClient
        .rawQuery('SELECT * FROM $CUSTOMERS_TABLE_NAME where id = ?', [id]);
    if (list.isNotEmpty) {
      return Customer.map(list.first);
    }
    return null;
  }

  //GROUP
  Future<int> insertGroup(Group item) async {
    var dbClient = await db;
    int res = await dbClient.insert(GROUPS_TABLE_NAME, item.toMap());
    return res;
  }

  Future<bool> updateGroup(Group item) async {
    var dbClient = await db;
    int res = await dbClient.update(GROUPS_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id!]);
    return res > 0;
  }

  Future<List<Group>> getGroups(int storeId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM $GROUPS_TABLE_NAME where storeId = ?', [storeId]);
    List<Group> groups = [];
    for (int i = 0; i < list.length; i++) {
      var group = Group.map(list[i]);
      groups.add(group);
    }
    return groups;
  }
  Future<List<Group>> getGroupsByGroupId(int storeId,int? groupId) async {
    var dbClient = await db;
    List<Map> list = [];
    if (groupId == null){
      list = await dbClient.rawQuery(
          'SELECT * FROM $GROUPS_TABLE_NAME WHERE storeId = ? AND groupId IS NULL',
          [storeId]);
    }else{
      list = await dbClient.rawQuery(
          'SELECT * FROM $GROUPS_TABLE_NAME WHERE storeId = ? AND groupId = ?',
          [storeId, groupId]);
    }
    List<Group> groups = [];
    for (int i = 0; i < list.length; i++) {
      var group = Group.map(list[i]);
      groups.add(group);
    }
    return groups;
  }

  //STORES
  Future<int> getCountStore() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $STORES_TABLE_NAME");

    int? count = Sqflite.firstIntValue(result);
    return count == null ? 0 : count;
  }

  //GOOD
  Future<int> getCountGood(int storeId) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $GOODS_TABLE_NAME WHERE storeId = ?", [storeId]);

    int? count = Sqflite.firstIntValue(result);
    return count == null ? 0 : count;
  }


  Future<Good> findGood(int id) async {
    var dbClient = await db;
    var list = await dbClient
        .rawQuery('SELECT * FROM $GOODS_TABLE_NAME where id = ?', [id]);
    if (list.isNotEmpty) {
      return Good.map(list.first);
    }
    throw Exception("No Good");
  }

  Future<int> insertGood(Good item) async {
    var dbClient = await db;
    int goodId = await dbClient.insert(GOODS_TABLE_NAME, item.toMap());
    await insertMedia(goodId, item.files);
    return goodId;
  }

  Future<bool> updateGood(Good item) async {
    var dbClient = await db;
    int res = await dbClient.update(GOODS_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id!]);
    await insertMedia(item.id!, item.files);
    return res > 0;
  }
  Future<void> insertMedia(int goodId, List<Uint8List> files) async{
    var dbClient = await db;
    await dbClient
        .rawDelete('DELETE FROM $MEDIA_TABLE_NAME WHERE goodId = ?', [goodId]);
    for (int i = 0; i<files.length;i++){
      var map = new Map<String, dynamic>();
      map["goodId"] = goodId;
      if (Platform.isWindows){
        map["media"] = files[i];
      }else{
        map["media"] = await compress(files[i]);
      }
      await dbClient.insert(MEDIA_TABLE_NAME, map);
    }
  }
  Future<Uint8List> compress(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 500,
      minWidth: 500,
      quality: 80
    );
    return result;
  }


  Future<List<Good>> getGoods(int storeId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM $GOODS_TABLE_NAME WHERE storeId = ?',
        [storeId]);
    List<Good> goods = [];
    for (int i = 0; i < list.length; i++) {
      var good = Good.map(list[i]);
      good.files = await getFiles(good.id!);
      double incomingQuantity = await getSumQuantityByGoodId(DocumentType.incoming, good.id!);
      double outgoingQuantity = await getSumQuantityByGoodId(DocumentType.outgoing, good.id!);
      good.quantity = incomingQuantity - outgoingQuantity;
      goods.add(good);
    }
    return goods;
  }
  Future<List<Uint8List>> getFiles(int goodId) async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM $MEDIA_TABLE_NAME WHERE goodId = ?',
        [goodId]);
    List<Uint8List> medias = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i]["media"] != null){
        medias.add(list[i]["media"]);
      }

    }
    return medias;
  }
  Future<List<Good>> getGoodsByGroupId(int storeId,int? groupId) async {
    var dbClient = await db;
    List<Map> list = [];
    if (groupId == null){
      list = await dbClient.rawQuery(
          'SELECT * FROM $GOODS_TABLE_NAME WHERE storeId = ? AND groupId IS NULL',
          [storeId]);
    }else{
      list = await dbClient.rawQuery(
          'SELECT * FROM $GOODS_TABLE_NAME WHERE storeId = ? AND groupId = ?',
          [storeId, groupId]);
    }
    List<Good> goods = [];
    for (int i = 0; i < list.length; i++) {
      var good = Good.map(list[i]);
      good.files = await getFiles(good.id!);
      double incomingQuantity =
      await getSumQuantityByGoodId(DocumentType.incoming, good.id!);
      double outgoingQuantity =
      await getSumQuantityByGoodId(DocumentType.outgoing, good.id!);
      good.quantity = incomingQuantity - outgoingQuantity;
      goods.add(good);
    }
    return goods;
  }

  Future<Good> getGoodByBarcode(String barcode) async {
    var dbClient = await db;
    //int storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM $GOODS_TABLE_NAME WHERE barcode = ?',
        [barcode]);
    if (list.length > 0) {
      var good = Good.map(list[0]);
      double incomingQuantity =
          await getSumQuantityByGoodId(DocumentType.incoming, good.id!);
      double outgoingQuantity =
          await getSumQuantityByGoodId(DocumentType.outgoing, good.id!);
      good.quantity = incomingQuantity - outgoingQuantity;
      return good;
    } else {
      throw Exception("not found barcode");
    }
  }

  Future<bool> deleteGood(int id) async {
    var dbClient = await db;
    dbClient.execute("PRAGMA foreign_keys = ON;");
    int res = await dbClient
        .rawDelete('DELETE FROM $GOODS_TABLE_NAME WHERE id = ?', [id]);
    return res > 0;
  }
  Future<bool> deleteGroup(int id) async {
    var dbClient = await db;
    dbClient.execute("PRAGMA foreign_keys = ON;");
    int res = await dbClient
        .rawDelete('DELETE FROM $GROUPS_TABLE_NAME WHERE id = ?', [id]);
    return res > 0;
  }
  Future<Group> findGroup(int id) async {
    var dbClient = await db;
    var list = await dbClient
        .rawQuery('SELECT * FROM $GROUPS_TABLE_NAME where id = ?', [id]);
    if (list.isNotEmpty) {
      return Group.map(list.first);
    }
    throw Exception("No Group");
  }

  //DOCUMENT

  Future<void> deleteTransactionByDocumentId(int documentId) async {
    var dbClient = await db;
    await dbClient.rawDelete(
        'DELETE FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE documentId =?',
        [documentId]);
  }

  Future<void> deleteTransactionByGoodId(int goodId) async {
    var dbClient = await db;
    await dbClient.rawDelete(
        'DELETE FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE goodId =?',
        [goodId]);
  }

  // Future<List<Document>> findDocumentBySupplierId(int supplierId) async {
  //   var dbClient = await db;
  //   final sql = "SELECT * FROM $DOCUMENTS_TABLE_NAME WHERE id = ?";
  //   List<Map> list = await dbClient.rawQuery(sql, [supplierId]);
  //   return list.map((e) => Document.map(e)).toList();
  // }

  Future<List<Document>> getDocuments(int storeId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        "SELECT A.id, " +
            "A.name, " +
            "A.description, " +
            "A.createdDate, " +
            "A.updatedDate, " +
            "A.date, " +
            "A.type, " +
            "A.paymentStatus, " +
            "A.supplierId, " +
            "A.customerId, " +
            "A.storeId, " +
            "B.name AS supplierName, " +
            "C.name AS customerName, " +
            "SUM(D.quantity) AS quantity, " +
            "SUM(D.quantity * D.price) AS amount " +
            "FROM $DOCUMENTS_TABLE_NAME A " +
            "LEFT JOIN $SUPPLIERS_TABLE_NAME B ON A.supplierId = B.id " +
            "LEFT JOIN $CUSTOMERS_TABLE_NAME C ON A.customerId = C.id " +
            "LEFT JOIN $DOCUMENT_TRANSACTIONS_TABLE_NAME D ON A.id = D.documentId " +
            "WHERE A.storeId = ? GROUP BY A.id", [storeId]);
    List<Document> documents = [];
    for (int i = 0; i < list.length; i++) {
      var document = Document.map(list[i]);
      var payments = await getPaymentByDocumentId(document.id!);
      document.paid = payments.fold(0.0, (sum, item) => sum += item.amount??0.0);
      documents.add(document);
    }
    return documents;
  }
  Future<List<Document>> getDocumentsInRange(int storeId, DateTime start, DateTime end) async {
    var dbClient = await db;
    int startInt = start.millisecondsSinceEpoch;
    int endInt = end.millisecondsSinceEpoch;
    String query = "SELECT A.id, " +
        "A.name, " +
        "A.description, " +
        "A.createdDate, " +
        "A.updatedDate, " +
        "A.date, " +
        "A.type, " +
        "A.paymentStatus, " +
        "A.supplierId, " +
        "A.customerId, " +
        "A.storeId, " +
        "B.name AS supplierName, " +
        "C.name AS customerName, " +
        "SUM(D.quantity) AS quantity, " +
        "SUM(D.quantity * D.price) AS amount " +
        "FROM $DOCUMENTS_TABLE_NAME A " +
        "LEFT JOIN $SUPPLIERS_TABLE_NAME B ON A.supplierId = B.id " +
        "LEFT JOIN $CUSTOMERS_TABLE_NAME C ON A.customerId = C.id " +
        "LEFT JOIN $DOCUMENT_TRANSACTIONS_TABLE_NAME D ON A.id = D.documentId " +
        "WHERE A.storeId = ? AND A.date BETWEEN ? AND ? GROUP BY A.id";
    List<Map> list = await dbClient.rawQuery(query, [storeId, startInt, endInt]);
    List<Document> documents = [];
    for (int i = 0; i < list.length; i++) {
      var document = Document.map(list[i]);
      var payments = await getPaymentByDocumentId(document.id!);
      document.paid = payments.fold(0.0, (sum, item) => sum += item.amount??0.0);
      documents.add(document);
    }
    return documents;
  }

  Future<int> getCountDocument(int storeId) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $DOCUMENTS_TABLE_NAME WHERE storeId = ?",
        [storeId]);

    int? count = Sqflite.firstIntValue(result);
    return count == null ? 0 : count;
  }

  Future<int> getQuantityByDocumentId(int documentId) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT SUM(quantity) FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE documentId = ?',
        [documentId]);
    int? count = Sqflite.firstIntValue(result);
    return count == null ? 0 : count;
  }

  Future<List<DocumentTransaction>> getTransactionsByDocumentId(
      int documentId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME where documentId = ?',
        [documentId]);

    List<DocumentTransaction> transactions = [];
    for (int i = 0; i < list.length; i++) {
      var transaction = DocumentTransaction.map(list[i]);
      var good = await findGood(transaction.goodId);
      good.quantity = transaction.quantity;
      transaction.good = good;
      transactions.add(transaction);
    }
    return transactions;
  }
  Future<List<DocumentTransaction>> getTransactionsByDocumentIdAndGoodId(
      int documentId, int goodId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME where documentId = ? AND goodId = ?',
        [documentId, goodId]);

    List<DocumentTransaction> transactions = [];
    for (int i = 0; i < list.length; i++) {
      var transaction = DocumentTransaction.map(list[i]);
      //var good = await findGood(transaction.goodId);
      //good.quantity = transaction.quantity;
      //transaction.good = good;
      transactions.add(transaction);
    }
    return transactions;
  }

  //TRANSACTION
  Future<int> insertTransaction(DocumentTransaction item) async {
    var dbClient = await db;
    int res =
        await dbClient.insert(DOCUMENT_TRANSACTIONS_TABLE_NAME, item.toMap());
    return res;
  }

  Future<bool> updateTransaction(DocumentTransaction item) async {
    var dbClient = await db;
    int res = await dbClient.update(
        DOCUMENT_TRANSACTIONS_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id!]);
    return res == 1;
  }

  Future<bool> deleteTransaction(int id) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete(
        'DELETE FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE id =?', [id]);
    return res == 1;
  }

  /*Future<int> getSumQuantity(String storeId,DocumentType type) async {
    //int storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT SUM(quantity) FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE storeId = ? AND documentType = ?',
        [storeId, type.index]);
    //int value = result[0]["SUM(quantity)"];
    //return value == null ? 0 : value;
    int? count = Sqflite.firstIntValue(result);
    return count == null ? 0 : count;
  }*/
  Future<double> getSumQuantityByGoodId(DocumentType type, int goodId) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT SUM(quantity) FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE goodId = ? AND documentType = ?',
        [goodId, type.index]);
    //resul
    var a = result[0]["SUM(quantity)"];
    if (a == null){
      return 0.0;
    }else{
      double value = double.parse(a.toString());
      return value;
    }
  }
  Future<double> getSumQuantityByGoodIdAndDocumentId(DocumentType type, int goodId, int documentId) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT SUM(quantity) FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE goodId = ? AND documentId = ? AND documentType = ?',
        [goodId, documentId ,type.index]);
    var a = result[0]["SUM(quantity)"];
    if (a == null){
      return 0.0;
    }else{
      double value = double.parse(a.toString());
      return value;
    }
  }

  //EXPENSES
  Future<double> getSumExpense(int storeId) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT SUM(amount) FROM $EXPENSES_TABLE_NAME WHERE storeId = ?',
        [storeId]);
    var value = result[0]["SUM(amount)"];
    if (value == null){
      return 0.0;
    }else{
      return value as double;
    }
  }

  Future<List<Expense>> getExpenses(int storeId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM $EXPENSES_TABLE_NAME where storeId = ?', [storeId]);
    List<Expense> items = [];
    for (int i = 0; i < list.length; i++) {
      Expense item = Expense.map(list[i]);
      items.add(item);
    }
    return items;
  }

  Future<int> insertExpense(Expense item) async {
    var dbClient = await db;
    int res = await dbClient.insert(EXPENSES_TABLE_NAME, item.toMap());
    return res;
  }

  Future<bool> deleteExpense(int id) async {
    var dbClient = await db;
    int res = await dbClient
        .rawDelete('DELETE FROM $EXPENSES_TABLE_NAME WHERE id = ?', [id]);
    return res > 0;
  }

  Future<bool> updateExpense(Expense item) async {
    var dbClient = await db;
    int res = await dbClient.update(EXPENSES_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id!]);
    return res == 1;
  }
  //payment
  Future<int> insertPayment(Payment item) async {
    var dbClient = await db;
    int res = await dbClient.insert(PAYMENTS_TABLE_NAME, item.toMap());
    return res;
  }
  Future<bool> deletePayment(int id) async {
    var dbClient = await db;
    int res = await dbClient
        .rawDelete('DELETE FROM $PAYMENTS_TABLE_NAME WHERE id = ?', [id]);
    return res > 0;
  }
  Future<bool> updatePayment(Payment item) async {
    var dbClient = await db;
    int res = await dbClient.update(PAYMENTS_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id!]);
    return res == 1;
  }
  //document
  Future<int> insertDocument(Document item) async {
    var dbClient = await db;
    int res = await dbClient.insert(DOCUMENTS_TABLE_NAME, item.toMap());
    return res;
  }
  Future<bool> updateDocument(Document item) async {
    var dbClient = await db;
    int res = await dbClient.update(DOCUMENTS_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id!]);
    return res == 1;
  }

  Future<bool> deleteDocument(int id) async{
    var dbClient = await db;
    dbClient.execute("PRAGMA foreign_keys = ON;");
    int res = await dbClient
        .rawDelete('DELETE FROM $DOCUMENTS_TABLE_NAME WHERE id = ?', [id]);
    return res > 0;
  }

  Future<List<Expense>> getExpensesInRange(int storeId, DateTime start, DateTime end) async{
    var dbClient = await db;
    int startInt = start.millisecondsSinceEpoch;
    int endInt = end.millisecondsSinceEpoch;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM $EXPENSES_TABLE_NAME where storeId = ? AND date BETWEEN ? AND ?', [storeId, startInt, endInt]);
    List<Expense> items = [];
    for (int i = 0; i < list.length; i++) {
      Expense item = Expense.map(list[i]);
      items.add(item);
    }
    return items;
  }
  Future<List<Payment>> getPaymentsInRange(int storeId, DateTime start, DateTime end) async{
    var dbClient = await db;
    int startInt = start.millisecondsSinceEpoch;
    int endInt = end.millisecondsSinceEpoch;
    List<Map> list = await dbClient.rawQuery(
        "SELECT A.id, A.name, A.description, A.createdDate, A.updatedDate, A.date, A.amount,A.type, A.documentId, A.storeId, " +
            "B.name as documentName FROM $PAYMENTS_TABLE_NAME A LEFT JOIN $DOCUMENTS_TABLE_NAME B ON A.documentId = B.id where A.storeId = ? AND A.date BETWEEN ? AND ? ORDER BY A.date DESC", [storeId, startInt, endInt]);
    List<Payment> items = [];
    for (int i = 0; i < list.length; i++) {
      Payment item = Payment.map(list[i]);
      items.add(item);
    }
    return items;
  }
  Future<List<Payment>> getPaymentByStoreId(int storeId) async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        "SELECT A.id, A.name, A.description, A.createdDate, A.updatedDate, A.date, A.amount, A.type, A.documentId, A.storeId, " +
            "B.name as documentName FROM $PAYMENTS_TABLE_NAME A LEFT JOIN $DOCUMENTS_TABLE_NAME B ON A.documentId = B.id where A.storeId = ? ORDER BY A.date DESC", [storeId]);
    List<Payment> items = [];
    for (int i = 0; i < list.length; i++) {
      Payment item = Payment.map(list[i]);
      items.add(item);
    }
    return items;
  }

  Future<List<Payment>> getPaymentByDocumentId(int documentId) async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM $PAYMENTS_TABLE_NAME where documentId = ? ORDER BY date DESC', [documentId]);

    List<Payment> items = [];
    for (int i = 0; i < list.length; i++) {
      Payment item = Payment.map(list[i]);
      items.add(item);
    }
    return items;
  }
  Future<List<Map>> rawQuery(String query,List<Object?>? arguments) async{
    var dbClient = await db;
    return await dbClient.rawQuery(query, arguments);
  }
}
