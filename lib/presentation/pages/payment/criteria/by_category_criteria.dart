import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/presentation/criteria/criteria.dart';

class ByCategoryCriteria extends Criteria<Payment>{
  final int id;
  ByCategoryCriteria(this.id);

  @override
  List<Payment> meetCriteria(List<Payment> input) {
    return input.where((payment) => payment.categoryId == id).toList();
  }
}