import 'package:good_manager/presentation/criteria/criteria.dart';

import '../../../../domain/entity/entity.dart';

class ByDateCriteria extends Criteria<Payment> {
  final DateTime startDate;
  final DateTime endDate;

  ByDateCriteria(this.startDate, this.endDate);

  DateTime _toDateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  List<Payment> meetCriteria(List<Payment> input) {
    final start = _toDateOnly(startDate);
    final end = _toDateOnly(endDate);

    return input.where((payment) {
      final paymentDate = _toDateOnly(payment.date);
      return !paymentDate.isBefore(start) && !paymentDate.isAfter(end);
    }).toList();
  }
}
