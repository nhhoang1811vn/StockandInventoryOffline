import '../../domain/entity/entity.dart';
import 'filter_criteria.dart';

class FilterGoodByBarcodeCriteria extends FilterCriteria<Good> {
  FilterGoodByBarcodeCriteria(super.searchText);

  @override
  List<Good> meetCriteria(List<Good> items) {
    return items
        .where((item) =>
            item.barCode?.toLowerCase().contains(searchText.toLowerCase()) ==
            true)
        .toList();
  }
}
