import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/repositories/supplier_repositories.dart';

class UpdateSupplierUseCase extends CompletableUseCase<UpdateSupplierUseCaseParams>{
  final SupplierRepository _repository;
  UpdateSupplierUseCase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(UpdateSupplierUseCaseParams params) async {
    final StreamController<void> controller = StreamController();
    try{
      bool successful = await _repository.update(params.item);
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
class UpdateSupplierUseCaseParams{
  final Supplier item;
  UpdateSupplierUseCaseParams(this.item);
}