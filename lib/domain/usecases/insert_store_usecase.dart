import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/Store.dart';
import 'package:good_manager/domain/repositories/store_repositories.dart';

class InsertStoreUseCase extends CompletableUseCase<InsertStoreUseCaseParams>{
  StoreRepository _storeRepository;
  InsertStoreUseCase(this._storeRepository) : super();
  @override
  Future<Stream<void>> buildUseCaseStream(InsertStoreUseCaseParams params) async {
    final StreamController<void> controller = StreamController();
    try{
      int result = await _storeRepository.insert(params.store);
      if (result == 1){
      }else{
      }
      controller.close();
    }catch(e){
      controller.addError(e);
    }
    return controller.stream;
  }
}
class InsertStoreUseCaseParams{
  final Store store;
  InsertStoreUseCaseParams(this.store);
}