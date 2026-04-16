import '../../domain/entity/entity.dart';
import 'filter_criteria.dart';

class FilterGoodByDescriptionCriteria extends FilterCriteria<Good> {
  FilterGoodByDescriptionCriteria(super.searchText);

  @override
  List<Good> meetCriteria(List<Good> items) {
    var keySearch = searchText.toLowerCase();
    return items
        .where(
          (item) => item.description.toLowerCase().contains(keySearch),
        )
        .toList();
  }
}
