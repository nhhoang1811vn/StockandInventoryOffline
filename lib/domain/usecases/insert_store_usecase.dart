import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/Store.dart';
import 'package:good_manager/domain/repositories/store_repositories.dart';

class InsertStoreUseCase extends CompletableUseCase<InsertStoreUseCaseParams>{
  final StoreRepository _storeRepository;
  InsertStoreUseCase(this._storeRepository);
  @override
  Future<Stream<void>> buildUseCaseStream(InsertStoreUseCaseParams params) async {
    final StreamController<void> controller = StreamController();
    try{
      bool successful = await _storeRepository.insert(params.store);
      if (successful){
        controller.close();
      }else{
        throw Exception("insert failed");
      }
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