import 'package:good_manager/domain/entities/search_goods_type.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';

class GoodsSettings {
  SortByText sortByName;
  SortByNumber sortByBarcode;
  SortByNumber sortByQuantity;

  SearchGoodsType searchGoodsType;
}
