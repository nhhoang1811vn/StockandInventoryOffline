import '../../domain/entity/entity.dart';
import 'filter_criteria.dart';

class GroupByDescriptionCriteria extends FilterCriteria<Group> {
  GroupByDescriptionCriteria(super.searchText);

  @override
  List<Group> meetCriteria(List<Group> items) {
    return items
        .where(
          (item) =>
              item.description.toLowerCase().contains(searchText.toLowerCase()),
        )
        .toList();
  }
}
