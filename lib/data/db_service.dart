import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:good_manager/data/data.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  final Database db;
  DbService(this.db);

  final STORES_KEY = "stores";
  final SUPPLIERS_KEY = "suppliers";
  final CUSTOMERS_KEY = "customers";
  final GOODS_KEY = "goods";
  final GROUPS_KEY = "groups";
  final DOCUMENTS_KEY = "documents";
  final DOCUMENT_TRANSACTIONS_KEY = "documentTransactions";
  final PAYMENTS_KEY = "payments";
  final PAYMENT_CATEGORIES_KEY = "paymentCategories";

  final WALLETS_KEY = "wallets";
  final MEDIA_KEY = "media";


  Future<File> exportToJson() async {
    final Map<String, dynamic> data = {
      'meta': {
        'version': 1,
        'exportedAt': DateTime.now().millisecondsSinceEpoch,
      },
      STORES_KEY : await _readTable(DBHelper.STORES_TABLE_NAME),
      SUPPLIERS_KEY: await _readTable(DBHelper.SUPPLIERS_TABLE_NAME),
      CUSTOMERS_KEY: await _readTable(DBHelper.CUSTOMERS_TABLE_NAME),
      GROUPS_KEY: await _readTable(DBHelper.GROUPS_TABLE_NAME),
      GOODS_KEY: await _readTable(DBHelper.GOODS_TABLE_NAME),
      DOCUMENTS_KEY: await _readTable(DBHelper.DOCUMENTS_TABLE_NAME),
      DOCUMENT_TRANSACTIONS_KEY: await _readTable(DBHelper.DOCUMENT_TRANSACTIONS_TABLE_NAME),
      PAYMENTS_KEY: await _readTable(DBHelper.PAYMENTS_TABLE_NAME),
      PAYMENT_CATEGORIES_KEY: await _readTable(DBHelper.PAYMENTS_CATEGORY_TABLE_NAME),
      WALLETS_KEY: await _readTable(DBHelper.WALLET_TABLE_NAME),
      MEDIA_KEY: await _readMediaTable(),
    };

    final jsonString = jsonEncode(data);

    final dir = await getApplicationDocumentsDirectory();
    final now = DateTime.now();
    final formatter = DateFormat('ddMMyyyy_HH_mm');
    final formattedDate = formatter.format(now);

    final file = File(
      '${dir.path}/stock_inventory_backup_$formattedDate.json',
    );
    return file.writeAsString(jsonString);
  }

  /// Generic table reader
  Future<List<Map<String, dynamic>>> _readTable(String table) async {
    final rows = await db.query(table);
    return rows.map((row) => Map<String, dynamic>.from(row)).toList();
  }

  /// Media table with BLOB → base64
  Future<List<Map<String, dynamic>>> _readMediaTable() async {
    final rows = await db.query(DBHelper.MEDIA_TABLE_NAME);

    return rows.map((row) {
      final map = Map<String, dynamic>.from(row);
      final blob = map['media'];

      if (blob != null && blob is Uint8List) {
        map['media'] = base64Encode(blob);
      }
      return map;
    }).toList();
  }

  Future<Map<String, dynamic>> readJson(File file) async {
    final jsonString = await file.readAsString();
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<void> importFromFile(File file) async {
    Map<String, dynamic> json = await readJson(file);
    await db.transaction((transaction) async {
      // Optional: clear old data
      await transaction.delete(DBHelper.DOCUMENT_TRANSACTIONS_TABLE_NAME);
      await transaction.delete(DBHelper.GOODS_TABLE_NAME);
      await transaction.delete(DBHelper.GROUPS_TABLE_NAME);
      await transaction.delete(DBHelper.SUPPLIERS_TABLE_NAME);
      await transaction.delete(DBHelper.CUSTOMERS_TABLE_NAME);
      await transaction.delete(DBHelper.PAYMENTS_CATEGORY_TABLE_NAME);
      await transaction.delete(DBHelper.WALLET_TABLE_NAME);
      await transaction.delete(DBHelper.PAYMENTS_TABLE_NAME);
      await transaction.delete(DBHelper.MEDIA_TABLE_NAME);
      await transaction.delete(DBHelper.STORES_TABLE_NAME);

      insertDB(transaction, DBHelper.STORES_TABLE_NAME, json[STORES_KEY] as List<dynamic>);
      insertDB(transaction, DBHelper.CUSTOMERS_TABLE_NAME, json[CUSTOMERS_KEY] as List<dynamic>);
      insertDB(transaction, DBHelper.SUPPLIERS_TABLE_NAME, json[SUPPLIERS_KEY] as List<dynamic>);
      insertGroup(transaction, json);
      insertDB(transaction, DBHelper.GOODS_TABLE_NAME, json[GOODS_KEY] as List<dynamic>);
      insertMedia(transaction, json);
      //insertDB(transaction, DBHelper.MEDIA_TABLE_NAME, json[MEDIA_KEY] as List<dynamic>);

      insertDB(transaction, DBHelper.DOCUMENTS_TABLE_NAME, json[DOCUMENTS_KEY] as List<dynamic>);
      insertDB(transaction, DBHelper.DOCUMENT_TRANSACTIONS_TABLE_NAME, json[DOCUMENT_TRANSACTIONS_KEY] as List<dynamic>);

      insertDB(transaction, DBHelper.WALLET_TABLE_NAME, json[WALLETS_KEY] as List<dynamic>);
      insertDB(transaction, DBHelper.PAYMENTS_CATEGORY_TABLE_NAME, json[PAYMENT_CATEGORIES_KEY] as List<dynamic>);
      insertDB(transaction, DBHelper.PAYMENTS_TABLE_NAME, json[PAYMENTS_KEY] as List<dynamic>);
    });
  }

  void insertDB(Transaction txn, String tableName, List<dynamic> items) async {
    for (final item in items) {
      await txn.insert(
        tableName,
        Map<String, Object?>.from(item),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  void insertGroup(Transaction txn, Map<String, dynamic> json) async {
    final raw = json[GROUPS_KEY] as List<dynamic>;
    final groups = [];
    for (final item in raw) {
      groups.add(Group.map(item));
    }
    groups.sort((a, b) => a.createdDate.compareTo(b.createdDate));
    for (final item in groups) {
      await txn.insert(
        DBHelper.GROUPS_TABLE_NAME,
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  void insertMedia(Transaction txn, Map<String, dynamic> json) async {
    final items = json[MEDIA_KEY] as List<dynamic>;
    for (final item in items) {
      var map = new Map<String, dynamic>();
      map["id"] = item["id"];
      map["goodId"] = item["goodId"];
      map["media"] = base64Decode(item["media"]);
      await txn.insert(
        DBHelper.MEDIA_TABLE_NAME,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
