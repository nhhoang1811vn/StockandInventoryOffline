import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/transaction.dart';

import '../entities/document.dart';
import '../entities/good.dart';
import '../repositories/document_repositories.dart';
import '../repositories/goods_repositories.dart';

class QuickInsertTransactionUseCase extends UseCase<bool, QuickInsertTransactionUseCaseParam>{
  final GoodsRepository goodRepository;
  final DocumentRepository documentRepository;
  QuickInsertTransactionUseCase(
      this.goodRepository,
      this.documentRepository);
  @override
  Future<Stream<bool>> buildUseCaseStream(QuickInsertTransactionUseCaseParam? params) async{
    final StreamController<bool> controller = StreamController();
    try {
      int goodId = params!.good.id;
      if (goodId != null){
        await goodRepository.update(params.good);
      }else{
        goodId = await goodRepository.insert(params.good);
      }
      List<DocumentTransaction> transactions = [];
      DocumentTransaction transaction = new DocumentTransaction();
      transaction.goodId = goodId;
      transaction.quantity = params.quantity;
      transaction.type = params.document.type;
      transactions.add(transaction);
      await documentRepository.insertDocument(params.document, transactions);
      controller.add(true);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }

}
class QuickInsertTransactionUseCaseParam {
  final Good good;
  final Document document;
  final int quantity;
  QuickInsertTransactionUseCaseParam(this.good, this.document, this.quantity);
}