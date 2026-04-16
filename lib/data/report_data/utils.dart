import 'package:easy_localization/easy_localization.dart';

import '../../domain/entity/payment.dart';

String getDoubleText(double input) {
  final formatter = NumberFormat('#,###');
  return formatter.format(input);
}
double getRevenue(List<Payment> payments) {
  double inAmount = payments
      .where((payment) => payment.type == PaymentType.inbound)
      .toList()
      .fold(0.0, (sum, payment) => sum + (payment.amount ?? 0.0));
  double outAmount = payments
      .where((payment) => payment.type == PaymentType.outbound)
      .toList()
      .fold(0.0, (sum, payment) => sum + (payment.amount ?? 0.0));
  return inAmount - outAmount;
}
double getTotal(List<Payment> payments) {
  return payments
      .toList()
      .fold(0.0, (sum, payment) => sum + (payment.amount ?? 0.0));
}

