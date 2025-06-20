import 'criteria.dart';

class AndCriteria<T> implements Criteria<T> {
  final List<Criteria<T>> criteriaList;

  AndCriteria(this.criteriaList);

  @override
  List<T> meetCriteria(List<T> input) {
    var filtered = input;
    for (final criteria in criteriaList) {
      filtered = criteria.meetCriteria(filtered);
    }
    return filtered;
  }
}
