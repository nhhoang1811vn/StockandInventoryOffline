import 'package:good_manager/presentation/criteria/criteria.dart';

import '../../../../domain/entity/entity.dart';

class ByWalletCriteria extends Criteria<Payment> {
  final int id;

  ByWalletCriteria(this.id);

  @override
  List<Payment> meetCriteria(List<Payment> input) {
    return input.where((payment) => payment.walletId == id).toList();
  }
}
