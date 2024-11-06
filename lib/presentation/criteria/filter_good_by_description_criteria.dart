import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/presentation/criteria/criteria.dart';

class FilterGoodByDescriptionCriteria extends Criteria<Good>{
  final String searchText;
  FilterGoodByDescriptionCriteria(this.searchText);

  @override
  List<Good> meetCriteria(List<Good> items) {
    return items.where((item) => item.description.toLowerCase().contains(searchText.toLowerCase())).toList();
  }
}