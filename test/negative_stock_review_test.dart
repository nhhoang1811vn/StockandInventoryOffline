import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/domain/exception/insufficient_stock_exception.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/save_good/bloc/save_good_cubit.dart';
import 'package:good_manager/presentation/pages/search/bloc/search_cubit.dart';
import 'package:good_manager/repo/repo.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeTxRepo extends Fake implements DocumentTransactionRepository {
  final List<DocumentTransaction> rows = [];
  int writes = 0;

  @override
  Future<int> insert(DocumentTransaction item) async {
    // A real DB write takes time: let other callers run in between.
    await Future<void>.delayed(Duration.zero);
    writes++;
    item.id = rows.length + 1;
    rows.add(item);
    return item.id!;
  }

  @override
  Future<double> getSumQuantityByGoodId(DocumentType type, int goodId) async {
    await Future<void>.delayed(Duration.zero);
    return rows
        .where((t) => t.type == type && t.goodId == goodId)
        .fold<double>(0, (sum, t) => sum + t.quantity);
  }
}

class _FakeDocRepo extends Fake implements DocumentRepository {}

class _RejectingDocUseCases extends Fake implements DocumentUseCases {
  int inserts = 0;

  @override
  Future<void> ensureTransactionAllowed(
    DocumentTransaction transaction, {
    int? goodId,
    bool isNewGood = false,
  }) async =>
      throw InsufficientStockException(goodId: 1, available: 0);

  @override
  Future<int> insertTransaction(DocumentTransaction item) async {
    inserts++;
    throw InsufficientStockException(goodId: 1, available: 0);
  }

  @override
  Future<bool> delete(int id) async =>
      throw InsufficientStockException(goodId: 1, available: 0);
}

class _CountingGoodsUseCases extends Fake implements GoodsUseCases {
  int writes = 0;

  @override
  Future<int> insert(Good item) async {
    writes++;
    return 1;
  }

  @override
  Future<bool> update(Good item) async {
    writes++;
    return true;
  }
}

class _FakePayments extends Fake implements PaymentUseCases {}

class _FakeGroups extends Fake implements GroupsUseCases {}

class _FakeWallets extends Fake implements WalletUseCases {}

class _FakeCustomers extends Fake implements CustomersUseCase {}

class _FakeSuppliers extends Fake implements SuppliersUseCase {}

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.createTempSync('nsr_test').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
    AppSettings.setSelectedStoreId(1);
    AppSettings.setGoodPropertiesSettings(
        GoodPropertiesSettings(allowNegativeStock: false),
        storeId: 1);
  });

  test('two concurrent issues of the last unit: only one is accepted',
      () async {
    final tx = _FakeTxRepo();
    tx.rows.add(DocumentTransaction()
      ..id = 100
      ..goodId = 1
      ..quantity = 1
      ..type = DocumentType.incoming
      ..storeId = 1
      ..documentId = 1);
    final useCase =
        DocumentUseCases(repository: _FakeDocRepo(), transactionRepository: tx);

    DocumentTransaction issue() => DocumentTransaction()
      ..goodId = 1
      ..quantity = 1
      ..type = DocumentType.outgoing
      ..storeId = 1
      ..documentId = 1;

    final results = await Future.wait([
      useCase.insertTransaction(issue()).then((_) => 'ok').catchError(
          (_) => 'rejected',
          test: (e) => e is InsufficientStockException),
      useCase.insertTransaction(issue()).then((_) => 'ok').catchError(
          (_) => 'rejected',
          test: (e) => e is InsufficientStockException),
    ]);

    expect(results.where((r) => r == 'ok').length, 1);
    expect(results.where((r) => r == 'rejected').length, 1);
    expect(tx.writes, 1);
  });

  test('SearchCubit.deleteDocument shows the error instead of throwing',
      () async {
    final cubit = SearchCubit(
      goodsUseCases: _CountingGoodsUseCases(),
      documentUseCases: _RejectingDocUseCases(),
      paymentUseCases: _FakePayments(),
      groupsUseCases: _FakeGroups(),
      walletUseCases: _FakeWallets(),
      customersUseCase: _FakeCustomers(),
      suppliersUseCase: _FakeSuppliers(),
    );
    await cubit.deleteDocument(5);
    expect(cubit.state.state, isA<InsufficientStockError>());
  });

  group('SaveGoodCubit', () {
    late _RejectingDocUseCases docs;
    late _CountingGoodsUseCases goods;
    late SaveGoodCubit cubit;

    setUp(() {
      docs = _RejectingDocUseCases();
      goods = _CountingGoodsUseCases();
      cubit = SaveGoodCubit(useCase: goods, documentsUseCases: docs);
    });

    test('insertTransaction returns false and emits the error on rejection',
        () async {
      final ok = await cubit.insertTransaction(DocumentTransaction()
        ..goodId = 1
        ..quantity = 1
        ..type = DocumentType.outgoing
        ..storeId = 1);
      expect(ok, isFalse);
      expect(cubit.state.state, isA<InsufficientStockError>());
    });

    test('canQuickInsert is false and emits the error on rejection', () async {
      cubit.init(
          Good()
            ..id = 1
            ..name = 'A'
            ..storeId = 1,
          null,
          null);
      expect(await cubit.canQuickInsert(DocumentType.outgoing, 2), isFalse);
      expect(cubit.state.state, isA<InsufficientStockError>());
    });

    test('a rejected line saves neither the Good nor the Document', () async {
      final good = Good()
        ..name = 'New'
        ..storeId = 1;
      final document = Document()
        ..type = DocumentType.outgoing
        ..storeId = 1;
      final transaction = DocumentTransaction()
        ..quantity = 1
        ..type = DocumentType.outgoing
        ..storeId = 1;
      cubit.init(good, document, transaction);
      cubit.onSaveClicked();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(cubit.state.state, isA<InsufficientStockError>());
      expect(goods.writes, 0);
      expect(docs.inserts, 0);
    });
  });
}
