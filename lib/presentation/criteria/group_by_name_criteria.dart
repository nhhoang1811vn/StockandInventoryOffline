import '../../domain/entity/entity.dart';
import 'filter_criteria.dart';

class GroupByNameCriteria extends FilterCriteria<Group> {
  GroupByNameCriteria(super.searchText);

  @override
  List<Group> meetCriteria(List<Group> items) {
    return items
        .where(
          (item) => item.name.toLowerCase().contains(searchText.toLowerCase()),
        )
        .toList();
  }
}
