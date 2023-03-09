import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/good.dart';

import '../../../domain/entities/document.dart';
import '../../../domain/usecases/quick_insert_transaction_use_case.dart';
import '../base/base_save_item_presenter.dart';

class SaveGoodPresenter extends BaseSaveItemPresenter<Good> {
  QuickInsertTransactionUseCase _quickInsertTransactionUseCase;

  SaveGoodPresenter(goodRepository, documentRepository) : super(goodRepository){
    _quickInsertTransactionUseCase = QuickInsertTransactionUseCase(goodRepository, documentRepository);
  }

  Function quickInsertTransactionOnNext;
  Function quickInsertTransactionOnError;



  quickInsertTransaction(Good good, Document document, int quantity) => _quickInsertTransactionUseCase.execute(
      _QuickInsertTransactionUseCaseObserver(this), QuickInsertTransactionUseCaseParam(good, document, quantity));

  @override
  void dispose() {
    super.dispose();
    _quickInsertTransactionUseCase.dispose();
  }
}

class _QuickInsertTransactionUseCaseObserver implements Observer<bool> {
  SaveGoodPresenter _presenter;

  _QuickInsertTransactionUseCaseObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.quickInsertTransactionOnError(e);
  }

  @override
  void onNext(bool val) {
    _presenter.quickInsertTransactionOnNext(val);
  }
}

