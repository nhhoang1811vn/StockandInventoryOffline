import 'package:good_manager/presentation/criteria/criteria.dart';

abstract class FilterCriteria<T> extends Criteria<T> {
  final String searchText;

  FilterCriteria(this.searchText);
}
