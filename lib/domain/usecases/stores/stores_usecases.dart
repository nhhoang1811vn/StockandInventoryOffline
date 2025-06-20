import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/usecases/base/items_usecases.dart';
abstract class StoresUseCase extends ItemsUseCase<Store>{
  Future<int> getCount();
}