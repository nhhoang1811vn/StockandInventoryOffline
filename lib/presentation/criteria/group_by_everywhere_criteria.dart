import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/presentation/criteria/criteria.dart';

class GroupByEverywhereCriteria extends Criteria<Group>{
  final String searchText;
  GroupByEverywhereCriteria(this.searchText);

  @override
  List<Group> meetCriteria(List<Group> items) {
    return items.where((item) => item.name.toLowerCase().contains(searchText.toLowerCase()) ||
        item.description.toLowerCase().contains(searchText.toLowerCase()) ||
        (item.barCode?.contains(searchText) == true)).toList();
  }
}