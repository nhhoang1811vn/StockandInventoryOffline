import '../../domain/entity/entity.dart';
import 'filter_criteria.dart';

class GroupByBarcodeCriteria extends FilterCriteria<Group> {
  GroupByBarcodeCriteria(super.searchText);

  @override
  List<Group> meetCriteria(List<Group> items) {
    return items
        .where((item) => item.barCode?.contains(searchText) == true)
        .toList();
  }
}
