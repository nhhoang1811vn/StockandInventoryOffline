import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/presentation/criteria/criteria.dart';

class FilterGoodByBarcodeCriteria extends Criteria<Good>{
  final String searchText;
  FilterGoodByBarcodeCriteria(this.searchText);

  @override
  List<Good> meetCriteria(List<Good> items) {
    return items.where((item) => item.barCode?.contains(searchText) == true).toList();
  }
}