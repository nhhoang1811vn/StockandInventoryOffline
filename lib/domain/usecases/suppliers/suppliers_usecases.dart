import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/usecases/base/items_usecases.dart';
abstract class SuppliersUseCase extends ItemsUseCase<Supplier>{
  Future<List<Supplier>> getAllByStoreId(int storeId);
}