import 'composite_criteria.dart';

class OrCriteria<T> extends CompositeCriteria<T> {
  OrCriteria(super.items);

  @override
  List<T> meetCriteria(List<T> input) {
    final Set<T> resultSet = {};

    for (final criteria in items) {
      resultSet.addAll(criteria.meetCriteria(input));
    }

    return resultSet.toList();
  }
}
