import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/domain/exception/insufficient_stock_exception.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit.dart';
import 'package:good_manager/repo/repo.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _CountingGoods extends Fake implements GoodsUseCases {
  int loads = 0;

  @override
  Future<List<Good>> getAllByStoreId(int storeId) async {
    loads++;
    return [];
  }
}

class _Groups extends Fake implements GroupsUseCases {
  @override
  Future<List<Group>> getAllByStoreId(int storeId) async => [];
}

class _Docs extends Fake implements DocumentUseCases {}

class _Stores extends Fake implements StoresUseCase {}

class _TxRepo extends Fake implements DocumentTransactionRepository {
  final List<DocumentTransaction> rows = [];

  @override
  Future<int> insert(DocumentTransaction item) async {
    item.id = rows.length + 1;
    rows.add(item);
    return item.id!;
  }

  @override
  Future<bool> update(DocumentTransaction item) async => true;

  @override
  Future<bool> delete(int id) async => true;

  @override
  Future<double> getSumQuantityByGoodId(DocumentType type, int goodId) async =>
      rows
          .where((t) => t.type == type && t.goodId == goodId)
          .fold<double>(0, (sum, t) => sum + t.quantity);

  @override
  Future<List<DocumentTransaction>> getTransactions(int documentId) async =>
      rows.where((t) => t.documentId == documentId).toList();
}

class _DocRepo extends Fake implements DocumentRepository {
  @override
  Future<Document> get(int id) async => Document()
    ..type = DocumentType.outgoing
    ..storeId = 1;

  @override
  Future<bool> delete(int id) async => true;
}

DocumentTransaction _tx(DocumentType type, double q) => DocumentTransaction()
  ..documentId = 1
  ..goodId = 1
  ..quantity = q
  ..type = type
  ..storeId = 1;

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.createTempSync('inv_test').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
    AppSettings.setSelectedStoreId(1);
  });

  group('stock revision of DocumentUseCases', () {
    late _TxRepo tx;
    late DocumentUseCases useCase;

    setUp(() {
      tx = _TxRepo();
      useCase =
          DocumentUseCases(repository: _DocRepo(), transactionRepository: tx);
    });

    test('goes up after a transaction is added, saved or deleted', () async {
      var before = DocumentUseCases.stockRevision.value;
      final id = await useCase.insertTransaction(_tx(DocumentType.incoming, 5));
      expect(DocumentUseCases.stockRevision.value, greaterThan(before));

      before = DocumentUseCases.stockRevision.value;
      await useCase.updateTransaction(_tx(DocumentType.incoming, 6)..id = id);
      expect(DocumentUseCases.stockRevision.value, greaterThan(before));

      before = DocumentUseCases.stockRevision.value;
      await useCase.deleteTransaction(_tx(DocumentType.incoming, 6)..id = id);
      expect(DocumentUseCases.stockRevision.value, greaterThan(before));
    });

    test('goes up after a Document is deleted', () async {
      final before = DocumentUseCases.stockRevision.value;
      await useCase.delete(1);
      expect(DocumentUseCases.stockRevision.value, greaterThan(before));
    });

    test('does not change when the change is rejected', () async {
      AppSettings.setGoodPropertiesSettings(
          GoodPropertiesSettings(allowNegativeStock: false),
          storeId: 1);
      final before = DocumentUseCases.stockRevision.value;
      await expectLater(
          useCase.insertTransaction(_tx(DocumentType.outgoing, 1)),
          throwsA(isA<InsufficientStockException>()));
      expect(DocumentUseCases.stockRevision.value, before);
    });
  });

  group('GoodsCubit', () {
    GoodsCubit build(_CountingGoods goods) => GoodsCubit(
          goodsUseCase: goods,
          groupsUseCase: _Groups(),
          documentsUseCases: _Docs(),
          storesUseCase: _Stores(),
        );

    Future<void> settle() =>
        Future<void>.delayed(const Duration(milliseconds: 50));

    test('the Inventory tab reloads its goods when the stock changes',
        () async {
      final goods = _CountingGoods();
      final cubit = build(goods)..initState(false, null);
      await settle();
      final loadsAfterInit = goods.loads;
      expect(loadsAfterInit, greaterThan(0));

      DocumentUseCases.stockRevision.value++;
      await settle();
      expect(goods.loads, greaterThan(loadsAfterInit));
      await cubit.close();
    });

    test('the Select Good screen does not reload on its own', () async {
      final goods = _CountingGoods();
      final cubit = build(goods)
        ..initState(true, Document()..type = DocumentType.outgoing);
      await settle();
      final loadsAfterInit = goods.loads;

      DocumentUseCases.stockRevision.value++;
      await settle();
      expect(goods.loads, loadsAfterInit);
      await cubit.close();
    });

    test('a closed cubit stops listening', () async {
      final goods = _CountingGoods();
      final cubit = build(goods)..initState(false, null);
      await settle();
      await cubit.close();
      final loads = goods.loads;
      DocumentUseCases.stockRevision.value++;
      await settle();
      expect(goods.loads, loads);
    });
  });
}
