import '../../domain/entity/entity.dart';
import 'filter_criteria.dart';

class FilterGoodByNameCriteria extends FilterCriteria<Good> {
  FilterGoodByNameCriteria(super.searchText);

  @override
  List<Good> meetCriteria(List<Good> items) {
    return items
        .where(
          (item) => item.name.toLowerCase().contains(searchText.toLowerCase()),
        )
        .toList();
  }
}
