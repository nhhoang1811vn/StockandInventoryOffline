import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/presentation/criteria/criteria.dart';

class GroupByDescriptionCriteria extends Criteria<Group>{
  final String searchText;
  GroupByDescriptionCriteria(this.searchText);

  @override
  List<Group> meetCriteria(List<Group> items) {
    return items.where((item) => item.description.toLowerCase().contains(searchText.toLowerCase())).toList();
  }
}