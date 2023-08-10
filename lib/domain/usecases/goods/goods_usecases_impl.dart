import 'dart:async';

import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/repositories/goods_repositories.dart';
import 'package:good_manager/domain/usecases/goods/goods_usercases.dart';
import 'package:injectable/injectable.dart';

import '../../repositories/document_transaction_repositories.dart';

@Injectable(as: GoodsUseCases)
class GoodsUseCaseImpl implements GoodsUseCases{
  final GoodsRepository repository;
  final DocumentTransactionRepository documentTransactionRepository;
  GoodsUseCaseImpl({required this.repository, required this.documentTransactionRepository});
  @override
  Future<int> insert(Good item) {
      return repository.insert(item);
  }
  @override
  Future<bool> update(Good item) {
    return repository.update(item);
  }
  @override
  Future<bool> delete(int id) async{
    try {
      //final deleteTransactionsResult = await documentTransactionRepository.deleteByGoodId(id);
      final deleteGoodResult = await repository.delete(id);
      //return Future.value(deleteTransactionsResult && deleteGoodResult);
      return Future.value(true);
    } catch (e) {
      return Future.error("");
    }
  }
  @override
  Future<Good> getGoodsByBarCode(String barCode) {
    return repository.getGoodByBarcode(barCode);
  }
  @override
  Future<List<Good>> getGoodsByDirectory(String directory) {
    return repository.getGoodsByDirectory(directory);
  }

  @override
  Future<List<Good>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }
  @override
  Future<int> getCount(int storeId) {
    return repository.getCount(storeId);
  }
}