import 'package:good_manager/presentation/criteria/criteria.dart';

import '../../../../domain/entity/entity.dart';

class BySupplierCriteria extends Criteria<Payment> {
  final int id;

  BySupplierCriteria(this.id);

  @override
  List<Payment> meetCriteria(List<Payment> input) {
    return input.where((payment) => payment.supplierId == id).toList();
  }
}
