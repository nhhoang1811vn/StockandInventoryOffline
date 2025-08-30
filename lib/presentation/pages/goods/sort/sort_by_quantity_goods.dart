import 'package:good_manager/presentation/pages/base/base_sort_items.dart';

import '../../../../domain/entity/entity.dart';

class SortByQuantityAscendingGood extends SortItems<Good> {
  @override
  int getResult(Good item1, Good item2) {
    return item1.quantity.compareTo(item2.quantity);
  }
}

class SortByQuantityDescendingGood extends SortItems<Good> {
  @override
  int getResult(Good item1, Good item2) {
    return item2.quantity.compareTo(item1.quantity);
  }
}
