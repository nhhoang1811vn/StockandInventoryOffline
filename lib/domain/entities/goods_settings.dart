import 'package:good_manager/domain/entities/base_settings.dart';
import 'package:good_manager/domain/entities/search_goods_type.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';

class GoodsSettings extends BaseSettings {
  SortByNumber sortByBarcode;
  SortByNumber sortByQuantity;

  SearchGoodsType searchGoodsType;
}
