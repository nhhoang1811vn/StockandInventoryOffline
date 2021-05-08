import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/Supplier.dart';
import 'package:good_manager/domain/repositories/Supplier_repositories.dart';

class UpdateSupplierUseCase extends CompletableUseCase<UpdateSupplierUseCaseParams>{
  SupplierRepository _supplierRepository;
  UpdateSupplierUseCase(this._supplierRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(UpdateSupplierUseCaseParams params) async {
    final StreamController<void> controller = StreamController();
    try{
      bool successful = await _supplierRepository.update(params.item);
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