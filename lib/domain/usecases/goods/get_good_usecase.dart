import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/repositories/good_repositories.dart';

class GetGoodsUseCase extends UseCase<List<Good>,GetGoodsUseCaseParams>{
  final GoodRepository _repository;

  GetGoodsUseCase(this._repository);

  @override
  Future<Stream<List<Good>>> buildUseCaseStream(GetGoodsUseCaseParams params) async{
    final StreamController<List<Good>> controller = StreamController();
    try{
      List<Good> items= await _repository.getGoods(params.storeId, params.groupId);
      controller.add(items);
      controller.close();
    }catch(e){
      controller.addError(e);
    }
    return controller.stream;
  }
}
class GetGoodsUseCaseParams {
  final int storeId;
  final int groupId;

  GetGoodsUseCaseParams(this.storeId, this.groupId);
}