import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/domain/exception/insufficient_stock_exception.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/repo/repo.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keeps its own copy of every line (like the DB) and counts the writes.
class _FakeTxRepo extends Fake implements DocumentTransactionRepository {
  final Map<int, DocumentTransaction> rows = {};
  int _next = 1;
  int writes = 0;

  DocumentTransaction _copy(DocumentTransaction t) => DocumentTransaction()
    ..id = t.id
    ..documentId = t.documentId
    ..goodId = t.goodId
    ..quantity = t.quantity
    ..price = t.price
    ..type = t.type
    ..storeId = t.storeId
    ..good = (Good()..name = 'Good ${t.goodId}');

  /// A line that already exists (not a write of the code under test).
  int seed(DocumentTransaction t) {
    t.id = _next++;
    rows[t.id!] = _copy(t);
    return t.id!;
  }

  @override
  Future<int> insert(DocumentTransaction item) async {
    writes++;
    return seed(item);
  }

  @override
  Future<bool> update(DocumentTransaction item) async {
    writes++;
    rows[item.id!] = _copy(item);
    return true;
  }

  @override
  Future<bool> delete(int id) async {
    writes++;
    return rows.remove(id) != null;
  }

  @override
  Future<double> getSumQuantityByGoodId(DocumentType type, int goodId) async =>
      rows.values
          .where((t) => t.type == type && t.goodId == goodId)
          .fold<double>(0, (sum, t) => sum + t.quantity);

  @override
  Future<List<DocumentTransaction>> getTransactions(int documentId) async =>
      rows.values.where((t) => t.documentId == documentId).map(_copy).toList();
}

class _FakeDocRepo extends Fake implements DocumentRepository {
  final Map<int, Document> docs = {};
  final List<int> deleted = [];

  @override
  Future<Document> get(int id) async => docs[id]!;

  @override
  Future<bool> delete(int id) async {
    deleted.add(id);
    return true;
  }
}

DocumentTransaction _tx(
  DocumentType type,
  double quantity, {
  int goodId = 1,
  int documentId = 1,
  int storeId = 1,
}) =>
    DocumentTransaction()
      ..documentId = documentId
      ..goodId = goodId
      ..quantity = quantity
      ..type = type
      ..storeId = storeId;

void main() {
  late SharedPreferences prefs;
  late _FakeTxRepo txRepo;
  late _FakeDocRepo docRepo;
  late DocumentUseCases useCase;

  setUpAll(() {
    Hive.init(Directory.systemTemp.createTempSync('neg_test').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
    txRepo = _FakeTxRepo();
    docRepo = _FakeDocRepo();
    useCase =
        DocumentUseCases(repository: docRepo, transactionRepository: txRepo);
  });

  void setAllowNegative(bool value, {int storeId = 1}) =>
      AppSettings.setGoodPropertiesSettings(
          GoodPropertiesSettings(allowNegativeStock: value),
          storeId: storeId);

  const incoming = DocumentType.incoming;
  const outgoing = DocumentType.outgoing;

  group('adding a transaction', () {
    test('switch on (default): issuing more than the stock is allowed',
        () async {
      txRepo.seed(_tx(incoming, 3));
      await useCase.insertTransaction(_tx(outgoing, 5));
      expect(txRepo.writes, 1);
    });

    test('switch off: issuing more than the stock is rejected, nothing written',
        () async {
      setAllowNegative(false);
      txRepo.seed(_tx(incoming, 3));
      await expectLater(
        useCase.insertTransaction(_tx(outgoing, 5)),
        throwsA(isA<InsufficientStockException>()
            .having((e) => e.available, 'available', 3)
            .having((e) => e.goodId, 'goodId', 1)),
      );
      expect(txRepo.writes, 0);
    });

    test('switch off: issuing exactly the stock is allowed', () async {
      setAllowNegative(false);
      txRepo.seed(_tx(incoming, 3));
      await useCase.insertTransaction(_tx(outgoing, 3));
      expect(txRepo.writes, 1);
    });

    test('switch off in another Store does not affect this Store', () async {
      setAllowNegative(false, storeId: 2);
      txRepo.seed(_tx(incoming, 3));
      await useCase.insertTransaction(_tx(outgoing, 5, storeId: 1));
      expect(txRepo.writes, 1);
    });

    test('switch off: receiving stock is always allowed', () async {
      setAllowNegative(false);
      await useCase.insertTransaction(_tx(incoming, 5));
      expect(txRepo.writes, 1);
    });

    test(
        'switch off, Good already negative: receiving is allowed, issuing '
        'is rejected', () async {
      setAllowNegative(false);
      txRepo.seed(_tx(incoming, 1));
      txRepo.seed(_tx(outgoing, 3)); // stock is -2
      await useCase.insertTransaction(_tx(incoming, 1)); // still -1: allowed
      expect(txRepo.writes, 1);
      await expectLater(useCase.insertTransaction(_tx(outgoing, 1)),
          throwsA(isA<InsufficientStockException>()));
      expect(txRepo.writes, 1);
    });

    test('float noise is not a negative stock (0.1 + 0.2 - 0.3)', () async {
      setAllowNegative(false);
      txRepo.seed(_tx(incoming, 0.1));
      txRepo.seed(_tx(incoming, 0.2));
      await useCase.insertTransaction(_tx(outgoing, 0.3));
      expect(txRepo.writes, 1);
    });

    test('ensureTransactionAllowed: a brand-new Good has stock 0', () async {
      setAllowNegative(false);
      await expectLater(
          useCase.ensureTransactionAllowed(_tx(outgoing, 1), isNewGood: true),
          throwsA(isA<InsufficientStockException>()));
      await useCase.ensureTransactionAllowed(_tx(incoming, 1), isNewGood: true);
    });
  });

  group('editing a transaction', () {
    setUp(() => setAllowNegative(false));

    test('raising an outgoing quantity beyond the stock is rejected', () async {
      txRepo.seed(_tx(incoming, 3));
      final id = txRepo.seed(_tx(outgoing, 2)); // stock 1
      final edit = _tx(outgoing, 4)..id = id; // needs 2 more
      await expectLater(useCase.updateTransaction(edit),
          throwsA(isA<InsufficientStockException>()));
      expect(txRepo.writes, 0);
    });

    test('raising an outgoing quantity within the stock is allowed', () async {
      txRepo.seed(_tx(incoming, 3));
      final id = txRepo.seed(_tx(outgoing, 1)); // stock 2
      await useCase.updateTransaction(_tx(outgoing, 3)..id = id);
      expect(txRepo.writes, 1);
    });

    test('lowering an outgoing quantity is always allowed', () async {
      txRepo.seed(_tx(incoming, 1));
      final id = txRepo.seed(_tx(outgoing, 3)); // already -2
      await useCase.updateTransaction(_tx(outgoing, 2)..id = id);
      expect(txRepo.writes, 1);
    });

    test('lowering an incoming quantity below what was issued is rejected',
        () async {
      final id = txRepo.seed(_tx(incoming, 5));
      txRepo.seed(_tx(outgoing, 4)); // stock 1
      // 5 -> 4 leaves the stock at exactly 0: allowed.
      await useCase.updateTransaction(_tx(incoming, 4)..id = id);
      expect(txRepo.writes, 1);
      // 4 -> 0.5 would leave -3.5: rejected, nothing more is written.
      await expectLater(useCase.updateTransaction(_tx(incoming, 0.5)..id = id),
          throwsA(isA<InsufficientStockException>()));
      expect(txRepo.writes, 1);
    });

    test('raising an incoming quantity is allowed', () async {
      final id = txRepo.seed(_tx(incoming, 1));
      txRepo.seed(_tx(outgoing, 1));
      await useCase.updateTransaction(_tx(incoming, 5)..id = id);
      expect(txRepo.writes, 1);
    });

    test('the stored line is used, not the in-memory object', () async {
      txRepo.seed(_tx(incoming, 3));
      final id = txRepo.seed(_tx(outgoing, 1)); // stock 2
      // The screen already changed the object to 3 in memory; the stored line
      // is still 1, so the real change is +2 and it fits the stock of 2.
      final inMemory = _tx(outgoing, 3)..id = id;
      await useCase.updateTransaction(inMemory);
      expect(txRepo.writes, 1);
    });
  });

  group('deleting', () {
    setUp(() => setAllowNegative(false));

    test('an incoming line that backs issued stock cannot be deleted',
        () async {
      final id = txRepo.seed(_tx(incoming, 5));
      txRepo.seed(_tx(outgoing, 4));
      final line =
          (await txRepo.getTransactions(1)).firstWhere((t) => t.id == id);
      await expectLater(
          useCase.deleteTransaction(line),
          throwsA(isA<InsufficientStockException>()
              .having((e) => e.goodName, 'goodName', 'Good 1')));
      expect(txRepo.writes, 0);
    });

    test('an incoming line with enough spare stock can be deleted', () async {
      txRepo.seed(_tx(incoming, 5));
      final id = txRepo.seed(_tx(incoming, 2));
      txRepo.seed(_tx(outgoing, 4));
      final line =
          (await txRepo.getTransactions(1)).firstWhere((t) => t.id == id);
      expect(await useCase.deleteTransaction(line), isTrue);
    });

    test('an outgoing line can always be deleted', () async {
      final id = txRepo.seed(_tx(outgoing, 9));
      final line =
          (await txRepo.getTransactions(1)).firstWhere((t) => t.id == id);
      expect(await useCase.deleteTransaction(line), isTrue);
    });

    test('an incoming Document is judged on the sum of its lines per Good',
        () async {
      docRepo.docs[7] = Document()
        ..type = incoming
        ..storeId = 1;
      txRepo.seed(_tx(incoming, 3, documentId: 7));
      txRepo.seed(_tx(incoming, 3, documentId: 7));
      txRepo.seed(_tx(outgoing, 4, documentId: 8)); // stock 2, Document backs 6
      await expectLater(
          useCase.delete(7), throwsA(isA<InsufficientStockException>()));
      expect(docRepo.deleted, isEmpty);
    });

    test('an incoming Document with spare stock can be deleted', () async {
      docRepo.docs[7] = Document()
        ..type = incoming
        ..storeId = 1;
      txRepo.seed(_tx(incoming, 3, documentId: 7));
      txRepo.seed(_tx(incoming, 5, documentId: 9));
      txRepo.seed(_tx(outgoing, 4, documentId: 8));
      expect(await useCase.delete(7), isTrue);
      expect(docRepo.deleted, [7]);
    });

    test('an outgoing Document can always be deleted', () async {
      docRepo.docs[7] = Document()
        ..type = outgoing
        ..storeId = 1;
      txRepo.seed(_tx(outgoing, 50, documentId: 7));
      expect(await useCase.delete(7), isTrue);
      expect(docRepo.deleted, [7]);
    });

    test('with the switch on nothing is blocked', () async {
      setAllowNegative(true);
      docRepo.docs[7] = Document()
        ..type = incoming
        ..storeId = 1;
      txRepo.seed(_tx(incoming, 3, documentId: 7));
      txRepo.seed(_tx(outgoing, 4, documentId: 8));
      expect(await useCase.delete(7), isTrue);
    });
  });
}
