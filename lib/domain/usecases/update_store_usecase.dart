import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/Store.dart';
import 'package:good_manager/domain/repositories/store_repositories.dart';

class UpdateStoreUseCase extends CompletableUseCase<UpdateStoreUseCaseParams>{
  StoreRepository _storeRepository;
  UpdateStoreUseCase(this._storeRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(UpdateStoreUseCaseParams params) async {
    final StreamController<void> controller = StreamController();
    try{
      bool successful = await _storeRepository.update(params.store);
      if (successful){
        controller.close();
      }else{
        throw Exception("update failed");
      }
    }catch(e){
      controller.addError(e);
    }
    return controller.stream;
  }
}
class UpdateStoreUseCaseParams{
  final Store store;
  UpdateStoreUseCaseParams(this.store);
}