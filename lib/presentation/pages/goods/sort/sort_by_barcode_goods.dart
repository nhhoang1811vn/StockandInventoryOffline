import 'package:good_manager/presentation/pages/base/base_sort_items.dart';
import 'package:good_manager/domain/entities/good.dart';

class SortByBarCodeAscendingGood extends SortItems<Good> {
  @override
  int getResult(Good item1, Good item2) {
    return item1.barCode.compareTo(item2.barCode);
  }
}

class SortByBarCodeDescendingGood extends SortItems<Good> {
  @override
  int getResult(Good item1, Good item2) {
    return item2.barCode.compareTo(item1.barCode);
  }
}
