import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../data/app_settings.dart';
import '../../../repo/repo.dart';
import '../../entity/entity.dart';
import '../../exception/insufficient_stock_exception.dart';
import '../base/items_usecases.dart';

@LazySingleton()
class DocumentUseCases extends ItemsUseCase<Document> {
  final DocumentRepository repository;
  final DocumentTransactionRepository transactionRepository;

  DocumentUseCases({
    required this.repository,
    required this.transactionRepository,
  });

  /// Deletes a Document. With "Allow negative quantity in stock" off, an
  /// incoming Document cannot be deleted when that would make a Good's stock
  /// negative ([InsufficientStockException]).
  Future<bool> delete(int id) => _serial(() async {
        final document = await repository.get(id);
        if (document.type == DocumentType.incoming) {
          final storeId = document.storeId ?? AppSettings.getSelectedStoreId();
          if (!_allowsNegative(storeId)) {
            final lines = await transactionRepository.getTransactions(id);
            final changes = <int, _StockChange>{};
            for (final line in lines) {
              changes
                  .putIfAbsent(line.goodId, () => _StockChange(_nameOf(line)))
                  .delta -= line.quantity;
            }
            await _ensureNotNegative(changes);
          }
        }
        return _changed(await repository.delete(id));
      });

  Future<List<Document>> getAllByStoreId(int storeId) {
    return repository.getAllByStoreId(storeId);
  }

  Future<List<Document>> getInRange(DateTime start, DateTime end) {
    return repository.getInRange(start, end);
  }

  Future<List<Document>> getInRangeBySupplierId(
    int id,
    DateTime start,
    DateTime end,
  ) {
    return repository.getInRangeBySupplierId(id, start, end);
  }

  Future<List<Document>> getInRangeByCustomerId(
    int id,
    DateTime start,
    DateTime end,
  ) {
    return repository.getInRangeByCustomerId(id, start, end);
  }

  Future<int> insert(Document item) {
    int storeId = AppSettings.getSelectedStoreId();
    AppSettings.increaseAutoDocumentNo(storeId);
    return repository.insert(item);
  }

  Future<bool> update(Document item) {
    return repository.update(item);
  }

  Future<int> getCount(int storeId) {
    return repository.getCount(storeId);
  }

  /// Bumped after every successful transaction or Document write, so screens
  /// that show stock and stay alive (the Inventory tab) can reload.
  static final ValueNotifier<int> stockRevision = ValueNotifier(0);

  T _changed<T>(T result) {
    stockRevision.value++;
    return result;
  }

  // The stock check and the write that follows it must not interleave with
  // another change (two fast scans of the last unit), so they run one at a time.
  Future<void> _tail = Future<void>.value();

  Future<T> _serial<T>(Future<T> Function() action) {
    final run = _tail.then((_) => action());
    _tail = run.then<void>((_) {}, onError: (_) {});
    return run;
  }

  Future<int> insertTransaction(DocumentTransaction item) => _serial(() async {
        await ensureTransactionAllowed(item);
        return _changed(await transactionRepository.insert(item));
      });

  Future<bool> updateTransaction(DocumentTransaction item) => _serial(() async {
        await ensureTransactionAllowed(item);
        return _changed(await transactionRepository.update(item));
      });

  Future<bool> deleteTransaction(DocumentTransaction item) => _serial(() async {
        if (!_allowsNegative(item.storeId)) {
          final stored = await _storedLine(item);
          await _ensureNotNegative({
            (stored ?? item).goodId:
                _StockChange(_nameOf(stored ?? item), -_effect(stored ?? item)),
          });
        }
        return _changed(await transactionRepository.delete(item.id!));
      });

  /// Throws [InsufficientStockException] when "Allow negative quantity in
  /// stock" is off for the transaction's Store and adding ([transaction].id is
  /// null) or saving it would lower a Good's stock below zero. Call it before
  /// any write in flows that save several things. [goodId] overrides
  /// `transaction.goodId`; [isNewGood] says the Good is not saved yet (stock 0).
  Future<void> ensureTransactionAllowed(
    DocumentTransaction transaction, {
    int? goodId,
    bool isNewGood = false,
  }) async {
    if (_allowsNegative(transaction.storeId)) return;
    double delta = _effect(transaction);
    if (transaction.id != null) {
      final stored = await _storedLine(transaction);
      if (stored != null) delta -= _effect(stored);
    }
    if (isNewGood) {
      if (delta < 0 && delta < -_epsilon) {
        throw InsufficientStockException(
          goodId: goodId ?? 0,
          goodName: _nameOf(transaction),
          available: 0,
        );
      }
      return;
    }
    await _ensureNotNegative({
      goodId ?? transaction.goodId: _StockChange(_nameOf(transaction), delta),
    });
  }

  static const double _epsilon = 1e-9;

  /// Incoming lines add to the stock, outgoing lines take from it.
  double _effect(DocumentTransaction t) =>
      t.type == DocumentType.incoming ? t.quantity : -t.quantity;

  bool _allowsNegative(int storeId) =>
      AppSettings.getGoodPropertiesSettings(storeId: storeId)
          .allowNegativeStock;

  String? _nameOf(DocumentTransaction t) {
    try {
      return t.good.name;
    } catch (_) {
      return null; // the Good was not loaded with this line
    }
  }

  Future<DocumentTransaction?> _storedLine(DocumentTransaction t) async {
    final lines = await transactionRepository.getTransactions(t.documentId);
    for (final line in lines) {
      if (line.id == t.id) return line;
    }
    return null;
  }

  Future<double> _stock(int goodId) async {
    final incoming = await transactionRepository.getSumQuantityByGoodId(
        DocumentType.incoming, goodId);
    final outgoing = await transactionRepository.getSumQuantityByGoodId(
        DocumentType.outgoing, goodId);
    return incoming - outgoing;
  }

  /// Rejects the first change that lowers a Good's stock below zero. A change
  /// that does not lower the stock is never rejected, so a Good that is
  /// already negative can still be restocked.
  Future<void> _ensureNotNegative(Map<int, _StockChange> changes) async {
    for (final entry in changes.entries) {
      final change = entry.value;
      if (change.delta >= 0) continue;
      final stock = await _stock(entry.key);
      if (stock + change.delta < -_epsilon) {
        throw InsufficientStockException(
          goodId: entry.key,
          goodName: change.goodName,
          available: stock,
        );
      }
    }
  }

  Future<List<DocumentTransaction>> getTransactionsByDocumentId(
    int documentId,
  ) {
    return transactionRepository.getTransactions(documentId);
  }

  Future<Document> get(int id) {
    return repository.get(id);
  }
}

class _StockChange {
  final String? goodName;
  double delta;

  _StockChange(this.goodName, [this.delta = 0]);
}
