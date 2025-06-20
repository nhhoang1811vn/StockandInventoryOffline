import 'criteria.dart';

class OrCriteria<T> implements Criteria<T> {
  final List<Criteria<T>> criteriaList;

  OrCriteria(this.criteriaList);

  @override
  List<T> meetCriteria(List<T> input) {
    final Set<T> resultSet = {};

    for (final criteria in criteriaList) {
      resultSet.addAll(criteria.meetCriteria(input));
    }

    return resultSet.toList();
  }
}