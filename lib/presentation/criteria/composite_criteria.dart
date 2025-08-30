import 'criteria.dart';

abstract class CompositeCriteria<T> extends Criteria<T> {
  final List<Criteria<T>> items;

  CompositeCriteria(this.items);
}
