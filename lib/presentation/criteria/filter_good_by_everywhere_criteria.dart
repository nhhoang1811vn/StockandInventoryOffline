import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/presentation/criteria/criteria.dart';

class FilterGoodByEverywhereCriteria extends Criteria<Good>{
  final String searchText;
  FilterGoodByEverywhereCriteria(this.searchText);

  @override
  List<Good> meetCriteria(List<Good> items) {
    return items.where((item) => (
        item.name.toLowerCase().contains(searchText.toLowerCase())
            || item.description.toLowerCase().contains(searchText.toLowerCase())
            || item.barCode?.contains(searchText) == true
    )).toList();
  }
}