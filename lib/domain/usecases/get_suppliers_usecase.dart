import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/Supplier.dart';
import 'package:good_manager/domain/repositories/supplier_repositories.dart';

class GetSuppliersUseCase extends UseCase<List<Supplier>,void>{
  final SupplierRepository _supplierRepository;
  GetSuppliersUseCase(this._supplierRepository);
  @override
  Future<Stream<List<Supplier>>> buildUseCaseStream(void params) async{
    final StreamController<List<Supplier>> controller = StreamController();
    try{
      List<Supplier> suppliers = await _supplierRepository.getAll();
      controller.add(suppliers);
      controller.close();
    }catch(e){
      controller.addError(e);
    }
    return controller.stream;
  }
}