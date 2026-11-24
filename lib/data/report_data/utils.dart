import 'package:easy_localization/easy_localization.dart';

import '../../domain/entity/payment.dart';
import '../../util/quantity_format.dart';
import '../app_settings.dart';

String getDoubleText(double input) {
  final formatter = NumberFormat('#,###');
  return formatter.format(input);
}

/// A quantity cell of a report: the Store's decimals, thousands separators.
String getQuantityTextForReport(double value) =>
    formatQuantity(value, AppSettings.getQuantityDecimals(), grouping: true);

/// The total of a report column: quantity columns keep the Store's decimals,
/// every other column (money) keeps being shown as a whole number.
String formatColumnTotal(double sum, {required bool isQuantity}) =>
    isQuantity ? getQuantityTextForReport(sum) : getDoubleText(sum);
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

