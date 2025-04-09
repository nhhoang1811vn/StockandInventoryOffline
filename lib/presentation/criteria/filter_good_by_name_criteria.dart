import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/presentation/criteria/criteria.dart';

class FilterGoodByNameCriteria extends Criteria<Good>{
  final String searchText;
  FilterGoodByNameCriteria(this.searchText);

  @override
  List<Good> meetCriteria(List<Good> items) {
    return items.where((item) => item.name.toLowerCase().contains(searchText.toLowerCase())).toList();
  }
}