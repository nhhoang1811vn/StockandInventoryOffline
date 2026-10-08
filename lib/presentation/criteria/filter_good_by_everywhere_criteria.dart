import '../../domain/entity/entity.dart';
import 'filter_criteria.dart';

class FilterGoodByEverywhereCriteria extends FilterCriteria<Good> {
  FilterGoodByEverywhereCriteria(super.searchText);

  @override
  List<Good> meetCriteria(List<Good> items) {
    return items
        .where(
          (item) =>
              (item.name.toLowerCase().contains(searchText.toLowerCase()) ||
                  item.description
                      .toLowerCase()
                      .contains(searchText.toLowerCase()) ||
              item.barCode?.toLowerCase().contains(searchText.toLowerCase()) ==
                  true),
        )
        .toList();
  }
}
