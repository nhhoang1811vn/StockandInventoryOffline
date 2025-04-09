import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/presentation/criteria/criteria.dart';

class GroupByNameCriteria extends Criteria<Group>{
  final String searchText;
  GroupByNameCriteria(this.searchText);

  @override
  List<Group> meetCriteria(List<Group> items) {
    return items.where((item) => item.name.toLowerCase().contains(searchText.toLowerCase())).toList();
  }
}