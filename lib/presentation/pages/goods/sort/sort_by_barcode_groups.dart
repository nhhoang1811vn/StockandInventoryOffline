import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/presentation/pages/base/base_sort_items.dart';

class SortByBarCodeAscendingGroup extends SortItems<Group> {
  @override
  int getResult(Group item1, Group item2) {
    return item1.barCode.compareTo(item2.barCode);
  }
}

class SortByBarCodeDescendingGroup extends SortItems<Group> {
  @override
  int getResult(Group item1, Group item2) {
    return item2.barCode.compareTo(item1.barCode);
  }
}
