import 'package:good_manager/presentation/pages/base/base_sort_items.dart';

import '../../../../domain/entity/entity.dart';

class SortByBarCodeAscendingGroup extends SortItems<Group> {
  @override
  int getResult(Group item1, Group item2) {
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

class SortByBarCodeDescendingGroup extends SortItems<Group> {
  @override
  int getResult(Group item1, Group item2) {
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
