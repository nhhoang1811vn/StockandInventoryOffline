import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/repositories/store_repositories.dart';

class GetStoresUseCase extends UseCase<List<Store>,void>{
  final StoreRepository _storeRepository;
  GetStoresUseCase(this._storeRepository);
  @override
  Future<Stream<List<Store>>> buildUseCaseStream(void params) async{
    final StreamController<List<Store>> controller = StreamController();
    try{
      List<Store> stores = await _storeRepository.getAll();
      controller.add(stores);
      controller.close();
    }catch(e){
      controller.addError(e);
    }
    return controller.stream;
  }
}