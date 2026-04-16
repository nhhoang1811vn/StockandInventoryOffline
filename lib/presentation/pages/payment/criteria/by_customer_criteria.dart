import 'package:good_manager/presentation/criteria/criteria.dart';

import '../../../../domain/entity/entity.dart';

class ByCustomerCriteria extends Criteria<Payment> {
  final int id;

  ByCustomerCriteria(this.id);

  @override
  List<Payment> meetCriteria(List<Payment> input) {
    return input.where((payment) => payment.customerId == id).toList();
  }
}
