import 'package:good_manager/domain/entities/minimum_quantity_settings.dart';
import 'package:good_manager/domain/entities/my_company.dart';

abstract class AppSettings{
  Future<MyCompany?> getMyCompany();
  Future<void> setMyCompany(MyCompany obj);
  Future<MinimumQuantitySettings> getMinimumQuantitySettings();
  Future<void> setMinimumQuantitySettings(MinimumQuantitySettings obj);

}