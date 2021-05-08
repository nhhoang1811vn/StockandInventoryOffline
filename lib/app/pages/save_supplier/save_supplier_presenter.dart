import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/Supplier.dart';
import 'package:good_manager/domain/usecases/insert_supplier_usecase.dart';
import 'package:good_manager/domain/usecases/update_supplier_usecase.dart';

class SaveSupplierPresenter extends Presenter{
  InsertSupplierUseCase insertSupplierUseCase;
  UpdateSupplierUseCase updateSupplierUseCase;
  SaveSupplierPresenter(repository){
    insertSupplierUseCase = InsertSupplierUseCase(repository);
    updateSupplierUseCase = UpdateSupplierUseCase(repository);
  }

  insert(Supplier item) => insertSupplierUseCase.execute(observer)
  update(Supplier item) => updateSupplierUseCase.execute(observer)

  @override
  void dispose() {
    insertSupplierUseCase.dispose();
    updateSupplierUseCase.dispose();
  }
}