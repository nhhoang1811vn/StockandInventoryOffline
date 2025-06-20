import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/presentation/criteria/criteria.dart';

class ByTypeCriteria extends Criteria<Payment>{
  final PaymentType type;
  ByTypeCriteria(this.type);

  @override
  List<Payment> meetCriteria(List<Payment> input) {
    return input.where((payment) => payment.type == type).toList();
  }
}