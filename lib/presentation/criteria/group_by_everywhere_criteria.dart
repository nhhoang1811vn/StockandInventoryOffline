import '../../domain/entity/entity.dart';
import 'filter_criteria.dart';

class GroupByEverywhereCriteria extends FilterCriteria<Group> {
  GroupByEverywhereCriteria(super.searchText);

  @override
  List<Group> meetCriteria(List<Group> items) {
    return items
        .where(
          (item) =>
              item.name.toLowerCase().contains(searchText.toLowerCase()) ||
              item.description
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              (item.barCode?.contains(searchText) == true),
        )
        .toList();
  }
}
