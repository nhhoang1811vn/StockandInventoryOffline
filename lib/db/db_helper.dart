import 'dart:async';
import 'dart:io' as io;

import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/expense.dart';
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

  static Database? _db;

  static const String STORES_TABLE_NAME = "Stores";
  static const String SUPPLIERS_TABLE_NAME = "Suppliers";
  static const String CUSTOMERS_TABLE_NAME = "Customers";

  static const String GROUPS_TABLE_NAME = "Groups";
  static const String GOODS_TABLE_NAME = "Goods";

  static const String DOCUMENTS_TABLE_NAME = "Documents";
  static const String DOCUMENT_TRANSACTIONS_TABLE_NAME = "Transactions";
  static const String EXPENSES_TABLE_NAME = "Expenses";

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
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
        "CREATE TABLE $STORES_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, createdDate INTEGER, updatedDate INTEGER)");
    await db.execute(
        "CREATE TABLE $EXPENSES_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, date INTEGER, amount REAL,storeId INTEGER, createdDate INTEGER, updatedDate INTEGER, FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id))");
    await db.execute(
        "CREATE TABLE $SUPPLIERS_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, address TEXT, email TEXT, phone TEXT, taxID TEXT, bankDetail TEXT, storeId INTEGER, createdDate INTEGER, updatedDate INTEGER, FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id))");
    await db.execute(
        "CREATE TABLE $CUSTOMERS_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, address TEXT, email TEXT, phone TEXT, taxID TEXT, bankDetail TEXT, storeId INTEGER, createdDate INTEGER, updatedDate INTEGER, FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id))");

    await db.execute(
        "CREATE TABLE $DOCUMENTS_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, date INTEGER, type INTEGER, storeId INTEGER ,supplierId INTEGER, customerId INTEGER, createdDate INTEGER, updatedDate INTEGER, " +
            "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id)," +
            "FOREIGN KEY(supplierId) REFERENCES $SUPPLIERS_TABLE_NAME(id)," +
            "FOREIGN KEY(customerId) REFERENCES $CUSTOMERS_TABLE_NAME(id))");

    await db.execute(
        "CREATE TABLE $GROUPS_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, barCode TEXT, storeId INTEGER NOT NULL, directory TEXT, files TEXT, createdDate INTEGER, updatedDate INTEGER, " +
            "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id))");
    await db.execute(
        "CREATE TABLE $GOODS_TABLE_NAME(id INTEGER PRIMARY KEY, name TEXT, description TEXT, barCode TEXT, storeId INTEGER NOT NULL, directory TEXT, files TEXT, createdDate INTEGER, updatedDate INTEGER, " +
            "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id))");

    await db.execute(
        "CREATE TABLE $DOCUMENT_TRANSACTIONS_TABLE_NAME(id INTEGER PRIMARY KEY,documentId INTEGER NOT NULL, goodId INTEGER NOT NULL,storeId INTEGER NOT NULL, quantity INTEGER, documentType INTEGER, " +
            "FOREIGN KEY(documentId) REFERENCES $DOCUMENTS_TABLE_NAME(id) ON DELETE CASCADE, " +
            "FOREIGN KEY(goodId) REFERENCES $GOODS_TABLE_NAME(id) ON DELETE CASCADE, " +
            "FOREIGN KEY(storeId) REFERENCES $STORES_TABLE_NAME(id) ON DELETE CASCADE)");
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

    int res = await dbClient
        .rawDelete('DELETE FROM $STORES_TABLE_NAME WHERE id = ?', [id]);
    return res > 0;
  }

  Future<bool> updateStore(Store item) async {
    var dbClient = await db;
    item.updatedDate = DateTime.now();
    int res = await dbClient.update(STORES_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id]);
    return res == 1;
  }

  //SUPPLIER
  Future<List<Supplier>> getSuppliers(int storeId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $SUPPLIERS_TABLE_NAME WHERE storeId = ?', [storeId]);
    List<Supplier> suppliers = [];
    for (int i = 0; i < list.length; i++) {
      Supplier supplier = Supplier.map(list[i]);
      //supplier.numberDocument = await getCountDocumentBySupplierId(supplier.id);
      suppliers.add(supplier);
    }
    return suppliers;
  }

  /*Future<List<Supplier>> getSuppliers() async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM $SUPPLIERS_TABLE_NAME');
    List<Supplier> suppliers = [];
    for (int i = 0; i < list.length; i++) {
      Supplier supplier = Supplier.map(list[i]);
      supplier.numberDocument = await getCountDocumentBySupplierId(supplier.id);
      suppliers.add(supplier);
    }
    return suppliers;
  }*/

  /*Future<int> getCountSupplier() async {
    int storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $SUPPLIERS_TABLE_NAME WHERE storeId = ?",
        [storeId]);
    int? count = Sqflite.firstIntValue(result);
    return count == null ? 0 : count;
  }*/

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
        where: "id = ?", whereArgs: <int>[item.id]);
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
  Future<List<Customer>> getCustomers() async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM $CUSTOMERS_TABLE_NAME');
    List<Customer> customers = [];
    for (int i = 0; i < list.length; i++) {
      Customer customer = Customer.map(list[i]);
      customer.numberDocument = await getCountDocumentByCustomerId(customer.id);
      customers.add(customer);
    }
    return customers;
  }

  /*Future<int> getCountCustomer() async {
    int storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $CUSTOMERS_TABLE_NAME WHERE storeId = ?",
        [storeId]);

    int? count = Sqflite.firstIntValue(result);
    return count == null ? 0 : count;
  }*/

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
        where: "id = ?", whereArgs: <int>[item.id]);
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
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    var dbClient = await db;
    int res = await dbClient.insert(GROUPS_TABLE_NAME, item.toMap());
    return res;
  }

  Future<bool> updateGroup(Group item) async {
    item.updatedDate = DateTime.now();
    var dbClient = await db;
    int res = await dbClient.update(GROUPS_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id]);
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

  Future<List<Group>> getGroupsByDirectory(int storeId,String directory) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM $GROUPS_TABLE_NAME WHERE storeId = ? AND directory = ?',
        [storeId, directory]);
    List<Group> groups = [];
    for (int i = 0; i < list.length; i++) {
      var group = Group.map(list[i]);
      groups.add(group);
    }
    return groups;
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
    //item.createdDate = DateTime.now();
    //item.updatedDate = DateTime.now();
    int res = await dbClient.insert(GOODS_TABLE_NAME, item.toMap());
    return res;
  }

  Future<bool> updateGood(Good item) async {
    var dbClient = await db;
    //item.updatedDate = DateTime.now();
    int res = await dbClient.update(GOODS_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id]);
    return res > 0;
  }
  Future<List<Good>> getGoods(String storeId) async {
    var dbClient = await db;
    //int storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM $GOODS_TABLE_NAME WHERE storeId = ?',
        [storeId]);
    List<Good> goods = [];
    for (int i = 0; i < list.length; i++) {
      var good = Good.map(list[i]);
      int incomingQuantity = await getSumQuantityByGoodId(DocumentType.incoming, good.id);
      int outgoingQuantity = await getSumQuantityByGoodId(DocumentType.outgoing, good.id);
      good.quantity = incomingQuantity - outgoingQuantity;
      goods.add(good);
    }
    return goods;
  }
  Future<List<Good>> getGoodsByDirectory(int storeId,String directory) async {
    var dbClient = await db;
    //int storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM $GOODS_TABLE_NAME WHERE storeId = ? AND directory = ?',
        [storeId, directory]);
    List<Good> goods = [];
    for (int i = 0; i < list.length; i++) {
      var good = Good.map(list[i]);
      int incomingQuantity =
      await getSumQuantityByGoodId(DocumentType.incoming, good.id);
      int outgoingQuantity =
      await getSumQuantityByGoodId(DocumentType.outgoing, good.id);
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
      int incomingQuantity =
          await getSumQuantityByGoodId(DocumentType.incoming, good.id);
      int outgoingQuantity =
          await getSumQuantityByGoodId(DocumentType.outgoing, good.id);
      good.quantity = incomingQuantity - outgoingQuantity;
      return good;
    } else {
      throw Exception("not found barcode");
    }
  }

  Future<bool> deleteGood(int id) async {
    var dbClient = await db;
    int res = await dbClient
        .rawDelete('DELETE FROM $GOODS_TABLE_NAME WHERE id = ?', [id]);
    return res > 0;
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
    List<Document> documents = [];
    for (int i = 0; i < list.length; i++) {
      var document = Document.map(list[i]);
      document.quantity = await getQuantityByDocumentId(document.id);
      if (document.type == DocumentType.incoming) {
        if (document.personId != null) {
          document.personName = (await getSupplier(document.personId))?.name;
        }
      } else if (document.type == DocumentType.outgoing) {
        if (document.personId != null) {
          document.personName = (await getCustomer(document.personId))?.name;
        }
      }
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

  Future<int> getSumQuantity(String storeId,DocumentType type) async {
    //int storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT SUM(quantity) FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE storeId = ? AND documentType = ?',
        [storeId, type.index]);
    //int value = result[0]["SUM(quantity)"];
    //return value == null ? 0 : value;
    int? count = Sqflite.firstIntValue(result);
    return count == null ? 0 : count;
  }
  Future<int> getSumQuantityByGoodId(DocumentType type, int goodId) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT SUM(quantity) FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE goodId = ? AND documentType = ?',
        [goodId, type.index]);
    int? count = Sqflite.firstIntValue(result);
    return count == null ? 0 : count;
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
        where: "id = ?", whereArgs: <int>[item.id]);
    return res == 1;
  }
  Future<int> insertDocument(Document item) async {
    var dbClient = await db;
    int res = await dbClient.insert(DOCUMENTS_TABLE_NAME, item.toMap());
    return res;
  }
  Future<bool> updateDocument(Document item) async {
    var dbClient = await db;
    int res = await dbClient.update(DOCUMENTS_TABLE_NAME, item.toMap(),
        where: "id = ?", whereArgs: <int>[item.id]);
    return res == 1;
  }
  /*Future<int> insertDocument(Document document, List<DocumentTransaction> transactions) async{
    var dbClient = await db;
    return dbClient.transaction((txn) async{
      //insert document
      //document.createdDate = DateTime.now();
      //document.updatedDate = DateTime.now();
      //document.storeId = storeId;
      int documentId = await txn.insert(DOCUMENTS_TABLE_NAME, document.toMap());
      //insert transaction
      for (var transaction in transactions){
        transaction.documentId = documentId;
        //transaction.storeId = storeId;
        transaction.createdDate = DateTime.now();
        transaction.updatedDate = DateTime.now();
        await txn.insert(DOCUMENT_TRANSACTIONS_TABLE_NAME, transaction.toMap());
      }
      //check valid
      /*List<Map> list = await txn.rawQuery(
          'SELECT id, name FROM $GOODS_TABLE_NAME WHERE storeId = ?',
          [storeId]);
      for (int i = 0; i < list.length; i++) {
        var goodId = list[i]["id"];
        var goodName = list[i]["name"];
        var result1 = await txn.rawQuery(
            'SELECT SUM(quantity) FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE storeId = ? AND goodId = ? AND documentType = ?',
            [storeId,goodId, DocumentType.incoming.index]);
        var result2 = await txn.rawQuery(
            'SELECT SUM(quantity) FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE storeId = ? AND goodId = ? AND documentType = ?',
            [storeId,goodId, DocumentType.outgoing.index]);
        int incomingQuantity = result1[0]["SUM(quantity)"] == null ? 0 : result1[0]["SUM(quantity)"];
        int outgoingQuantity = result2[0]["SUM(quantity)"] == null ? 0 : result2[0]["SUM(quantity)"];
        int quantity = incomingQuantity - outgoingQuantity;
        if (quantity < 0){
          throw Exception("error quantity, $goodName");
        }
      }*/
      return documentId;
    });
  }*/
  //udpate document
  /*Future<bool> updateDocument(Document document, List<DocumentTransaction> transactions) async{
    //var storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    var dbClient = await db;
    return dbClient.transaction((txn) async{
      //update document
      document.updatedDate = DateTime.now();
      int res = await txn.update(DOCUMENTS_TABLE_NAME, document.toMap(),
          where: "id = ?", whereArgs: <int>[document.id]);
      //delete transaction
      await txn.rawDelete(
          'DELETE FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE documentId =?',
          [document.id]);
      //insert transaction
      for (var transaction in transactions){
        transaction.documentId = document.id;
        //transaction.storeId = storeId;
        await txn.insert(DOCUMENT_TRANSACTIONS_TABLE_NAME, transaction.toMap());
      }
      //check valid
      /*List<Map> list = await txn.rawQuery(
          'SELECT id, name FROM $GOODS_TABLE_NAME WHERE storeId = ?',
          [storeId]);
      for (int i = 0; i < list.length; i++) {
        var goodId = list[i]["id"];
        var goodName = list[i]["name"];
        var result1 = await txn.rawQuery(
            'SELECT SUM(quantity) FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE storeId = ? AND goodId = ? AND documentType = ?',
            [storeId,goodId, DocumentType.incoming.index]);
        var result2 = await txn.rawQuery(
            'SELECT SUM(quantity) FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE storeId = ? AND goodId = ? AND documentType = ?',
            [storeId,goodId, DocumentType.outgoing.index]);
        int incomingQuantity = result1[0]["SUM(quantity)"] == null ? 0 : result1[0]["SUM(quantity)"];
        int outgoingQuantity = result2[0]["SUM(quantity)"] == null ? 0 : result2[0]["SUM(quantity)"];
        int quantity = incomingQuantity - outgoingQuantity;
        if (quantity < 0){
          throw Exception("error quantity, $goodName");
        }
      }*/
      return res > 0;
    });
  }*/
  Future<bool> deleteDocument(int id) async{
    //var storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    var dbClient = await db;
    return dbClient.transaction((txn) async{
      //delete transactions
      await txn.rawDelete(
          'DELETE FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE documentId =?',
          [id]);
      //delete document
      int res = await txn.rawDelete('DELETE FROM $DOCUMENTS_TABLE_NAME WHERE id =?',[id]);
      //check valid
      /*List<Map> list = await txn.rawQuery(
          'SELECT id, name FROM $GOODS_TABLE_NAME WHERE storeId = ?',
          [storeId]);
      for (int i = 0; i < list.length; i++) {
        var goodId = list[i]["id"];
        var goodName = list[i]["name"];
        var result1 = await txn.rawQuery(
            'SELECT SUM(quantity) FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE storeId = ? AND goodId = ? AND documentType = ?',
            [storeId,goodId, DocumentType.incoming.index]);
        var result2 = await txn.rawQuery(
            'SELECT SUM(quantity) FROM $DOCUMENT_TRANSACTIONS_TABLE_NAME WHERE storeId = ? AND goodId = ? AND documentType = ?',
            [storeId,goodId, DocumentType.outgoing.index]);
        int? count1 = Sqflite.firstIntValue(result1);
        int incomingQuantity = count1 == null ? 0 : count1;

        int? count2 = Sqflite.firstIntValue(result2);
        int outgoingQuantity = count2 == null ? 0 : count2;


        //int incomingQuantity = result1[0]["SUM(quantity)"] == null ? 0 : result1[0]["SUM(quantity)"];
        //int outgoingQuantity = result2[0]["SUM(quantity)"] == null ? 0 : result2[0]["SUM(quantity)"];
        int quantity = incomingQuantity - outgoingQuantity;
        if (quantity < 0){
          throw Exception("error quantity, $goodName");
        }
      }*/
      return res > 0;
    });
  }
}
