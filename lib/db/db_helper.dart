import 'dart:async';
import 'dart:io' as io;

import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper.internal();

  factory DBHelper() => _instance;

  static Database _db;

  final String STORES_TABLE_NAME = "Stores";
  final String SUPPLIERS_TABLE_NAME = "Suppliers";
  final String CUSTOMERS_TABLE_NAME = "Customers";

  final String GROUPS_TABLE_NAME = "Groups";
  final String GOODS_TABLE_NAME = "Goods";

  final String DOCUMENTS_TABLE_NAME = "Documents";
  final String DOCUMENT_TRANSACTIONS_TABLE_NAME = "Transactions";

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
    await db.execute(
        "CREATE TABLE $SUPPLIERS_TABLE_NAME(id INTEGER PRIMARY KEY, supplierName TEXT, description TEXT, address TEXT, email TEXT, phone TEXT, taxID TEXT, bankDetail TEXT)");
    await db.execute(
        "CREATE TABLE $CUSTOMERS_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, address TEXT, email TEXT, phone TEXT, taxID TEXT, bankDetail TEXT)");

    await db.execute(
        "CREATE TABLE $DOCUMENTS_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, date INTEGER, type INTEGER, storeId INTEGER ,supplierId INTEGER, customerId INTEGER, " +
            "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id)," +
            "FOREIGN KEY(supplierId) REFERENCES $SUPPLIERS_TABLE_NAME(id)," +
            "FOREIGN KEY(customerId) REFERENCES $CUSTOMERS_TABLE_NAME(id))");

    await db.execute(
        "CREATE TABLE $GROUPS_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, barCode TEXT, storeId INTEGER NOT NULL, groupId INTEGER, " +
            "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id))");
    await db.execute(
        "CREATE TABLE $GOODS_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, barCode TEXT, storeId INTEGER NOT NULL, groupId INTEGER, " +
            "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id))");

    await db.execute(
        "CREATE TABLE $DOCUMENT_TRANSACTIONS_TABLE_NAME(id INTEGER PRIMARY KEY,documentId INTEGER NOT NULL, goodId INTEGER NOT NULL, quantity INTEGER, documentType INTEGER, " +
            "CONSTRAINT fk_transaction_document_id FOREIGN KEY(documentId) REFERENCES $DOCUMENTS_TABLE_NAME(id) ON DELETE CASCADE ON UPDATE CASCADE," +
            "CONSTRAINT fk_transaction_good_id FOREIGN KEY(goodId) REFERENCES $GOODS_TABLE_NAME(id) ON DELETE CASCADE ON UPDATE CASCADE)");
  }
  ///STORE
  Future<int> insertStore(Store store) async {
    var dbClient = await db;
    int res = await dbClient.insert(STORES_TABLE_NAME, store.toMap());
    return res;
  }

  Future<List<Store>> getStores() async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM $STORES_TABLE_NAME');
    List<Store> stores = new List();
    for (int i = 0; i < list.length; i++) {
      stores.add(Store.map(list[i]));
    }
    print(stores.length);
    return stores;
  }

  Future<bool> deleteStore(int id) async {
    var dbClient = await db;

    int res = await dbClient
        .rawDelete('DELETE FROM $STORES_TABLE_NAME WHERE id = ?', [id]);
    return res > 0;
  }

  Future<bool> updateStore(Store store) async {
    var dbClient = await db;
    int res = await dbClient.update(STORES_TABLE_NAME, store.toMap(),
        where: "id = ?", whereArgs: <int>[store.id]);
    return res == 1;
  }

  //SUPPLIER

  Future<List<Supplier>> getSuppliers() async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM $SUPPLIERS_TABLE_NAME');
    List<Supplier> suppliers = new List();
    for (int i = 0; i < list.length; i++) {
      Supplier supplier = Supplier.map(list[i]);
      supplier.numberDocument = await getCountDocumentBySupplierId(supplier.id);
      suppliers.add(supplier);
    }
    return suppliers;
  }

  Future<int> getCountDocumentBySupplierId(int supplierId) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $DOCUMENTS_TABLE_NAME WHERE supplierId = ?",
        [supplierId]);

    int value = result[0]["COUNT(*)"];
    return value == null ? 0 : value;
  }

  Future<int> insertSupplier(Supplier item) async {
    var dbClient = await db;
    int res = await dbClient.insert(SUPPLIERS_TABLE_NAME, item.toMap());
    return res;
  }

  Future<bool> updateSupplier(Supplier item) async {
    var dbClient = await db;
    int res = await dbClient.update(SUPPLIERS_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id]);
    return res == 1;
  }

  Future<Supplier> getSupplier(int id) async {
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

  //CUSTOMER
  Future<Customer> getCustomer(int id) async {
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
        where: "id = ?", whereArgs: <int>[item.id]);
    return res > 0;
  }

  Future<List<Group>> getGroups(int storeId,int groupId) async {
    var dbClient = await db;

    //int storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    List<Map> list = [];
    if (groupId == null) {
      list = await dbClient.rawQuery(
          'SELECT * FROM $GROUPS_TABLE_NAME where storeId = ? AND groupId IS NULL',
          [storeId]);
    } else {
      list = await dbClient.rawQuery(
          'SELECT * FROM $GROUPS_TABLE_NAME WHERE storeId = ? AND groupId = ?',
          [storeId, groupId]);
    }
    List<Group> groups = new List();
    for (int i = 0; i < list.length; i++) {
      var group = Group.map(list[i]);
      groups.add(group);
    }
    return groups;
  }
  //GOOD
  Future<Good> findGood(int id) async {
    var dbClient = await db;
    var list = await dbClient
        .rawQuery('SELECT * FROM $GOODS_TABLE_NAME where id = ?', [id]);
    if (list.isNotEmpty) {
      Map item = list.first;
      return Good.map(item);
    }
    return null;
  }

  Future<int> insertGood(Good item) async {
    var dbClient = await db;
    int res = await dbClient.insert(GOODS_TABLE_NAME, item.toMap());
    return res;
  }

  Future<bool> updateGood(Good item) async {
    var dbClient = await db;
    int res = await dbClient.update(GOODS_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id]);
    return res > 0;
  }
  Future<List<Good>> getGoods(int storeId, int groupId) async {
    var dbClient = await db;
   // int storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    List<Map> list = [];
    if (groupId == null) {
      list = await dbClient.rawQuery(
          'SELECT * FROM $GOODS_TABLE_NAME where storeId = ? AND groupId IS NULL',
          [storeId]);
    } else {
      list = await dbClient.rawQuery(
          'SELECT * FROM $GOODS_TABLE_NAME WHERE storeId = ? AND groupId = ?',
          [storeId, groupId]);
    }
    List<Good> goods = new List();
    for (int i = 0; i < list.length; i++) {
      var good = Good.map(list[i]);
      int incomingQuantity = await getQuantity(good.id, DocumentType.incoming);
      int outgoingQuantity = await getQuantity(good.id, DocumentType.outgoing);
      good.quantity = incomingQuantity - outgoingQuantity;
      goods.add(good);
    }
    return goods;
  }
  //DOCUMENT
  Future<int> insertDocument(Document item) async {
    var dbClient = await db;
    int res = await dbClient.insert(DOCUMENTS_TABLE_NAME, item.toMap());
    return res;
  }

  Future<bool> updateDocument(Document item) async {
    var dbClient = await db;
    int res = await dbClient.update(DOCUMENTS_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id]);
    return res > 0;
  }

  Future<bool> deleteDocument(int id) async {
    var dbClient = await db;
    int res = await dbClient
        .rawDelete('DELETE FROM $DOCUMENTS_TABLE_NAME WHERE id = ?', [id]);
    return res > 0;
  }

  Future<void> deleteTransactionByDocumentId(int documentId) async {
    var dbClient = await db;
    await dbClient.rawDelete(
        'DELETE FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE documentId =?',
        [documentId]);
  }

  Future<List<Document>> findDocumentBySupplierId(int supplierId) async {
    var dbClient = await db;

    final sql = "SELECT * FROM $DOCUMENTS_TABLE_NAME WHERE id = ?";
    List<Map> list = await dbClient.rawQuery(sql, [supplierId]);
    return list.map((e) => Document.map(e)).toList();
  }

  Future<List<Document>> getDocuments(int storeId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM $DOCUMENTS_TABLE_NAME where storeId = ?', [storeId]);
    List<Document> documents = new List();
    for (int i = 0; i < list.length; i++) {
      var document = Document.map(list[i]);
      document.quantity = await getQuantityByDocumentId(document.id);
      if (document.type == DocumentType.incoming) {
        if (document.supplierId != null) {
          document.supplierName = (await getSupplier(document.supplierId)).name;
        }
      } else if (document.type == DocumentType.outgoing) {
        if (document.customerId != null) {
          document.customerName = (await getCustomer(document.customerId)).name;
        }
      }
      documents.add(document);
    }
    return documents;
  }

  /*Future<List<Document>> getDocumentsByType(DocumentType type) async{
    var dbClient = await db;
    int storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM $DOCUMENTS_TABLE_NAME where storeId = ? AND type = ?',
        [storeId, type.index]);
    List<Document> documents = new List();
    for (int i = 0; i < list.length; i++) {
      var document = Document.map(list[i]);
      document.quantity = await getQuantityByDocumentId(document.id);
      if (document.type == DocumentType.incoming){
        document.supplierName = (await getSupplier(document.supplierId)).name;
      }else if (document.type == DocumentType.outgoing){
        document.customerName = (await getCustomer(document.customerId)).name;
      }
      documents.add(document);
    }
    return documents;
  }*/

  Future<int> getQuantityByDocumentId(int documentId) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT SUM(quantity) FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE documentId = ?',
        [documentId]);
    int value = result[0]["SUM(quantity)"];
    return value == null ? 0 : value;
  }

  Future<List<DocumentTransaction>> getTransactionsByDocumentId(
      int documentId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME where documentId = ?',
        [documentId]);

    List<DocumentTransaction> transactions = new List();
    for (int i = 0; i < list.length; i++) {
      var transaction = DocumentTransaction.map(list[i]);
      var good = await findGood(transaction.goodId);
      good.quantity = transaction.quantity;
      transaction.good = good;
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
        where: "id = ?", whereArgs: <int>[item.id]);
    return res == 1;
  }

  Future<bool> deleteTransaction(int id) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete(
        'DELETE FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE id =?', [id]);
    return res == 1;
  }

  Future<int> getQuantity(int goodId, DocumentType type) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT SUM(quantity) FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE goodId = ? AND documentType = ?',
        [goodId, type.index]);
    int value = result[0]["SUM(quantity)"];
    return value == null ? 0 : value;
  }
}
