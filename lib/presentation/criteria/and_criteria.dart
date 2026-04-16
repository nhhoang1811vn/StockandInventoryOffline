import 'composite_criteria.dart';

class AndCriteria<T> extends CompositeCriteria<T> {
  AndCriteria(super.items);

  @override
  List<T> meetCriteria(List<T> input) {
    var filtered = input;
    for (final criteria in items) {
      filtered = criteria.meetCriteria(filtered);
    }
    return filtered;
  }
}
