import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/presentation/criteria/criteria.dart';

class GroupByBarcodeCriteria extends Criteria<Group>{
  final String searchText;
  GroupByBarcodeCriteria(this.searchText);

  @override
  List<Group> meetCriteria(List<Group> items) {
    return items.where((item) => item.barCode?.contains(searchText) == true).toList();
  }
}