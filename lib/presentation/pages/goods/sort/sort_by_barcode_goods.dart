import 'package:good_manager/presentation/pages/base/base_sort_items.dart';

import '../../../../domain/entity/entity.dart';

class SortByBarCodeAscendingGood extends SortItems<Good> {
  @override
  int getResult(Good item1, Good item2) {
    if (item1.barCode == null && item2.barCode == null) {
      return 0;
    }
    if (item1.barCode == null) {
      return -1;
    }
    if (item2.barCode == null) {
      return 1;
    }
    return item1.barCode!.compareTo(item2.barCode!);
  }
}

class SortByBarCodeDescendingGood extends SortItems<Good> {
  @override
  int getResult(Good item1, Good item2) {
    if (item1.barCode == null && item2.barCode == null) {
      return 0;
    }
    if (item1.barCode == null) {
      return -1;
    }
    if (item2.barCode == null) {
      return 1;
    }
    return item2.barCode!.compareTo(item1.barCode!);
  }
}
