import 'package:good_manager/domain/entities/document.dart';

import '../../domain/entities/payment.dart';

abstract class ListItem {}
class HeaderItem implements ListItem {
  final DateTime date;

  HeaderItem(this.date);
}

class PaymentListItem implements ListItem {
  final Payment payment;

  PaymentListItem(this.payment);
}
class DocumentListItem implements ListItem{
  final Document document;

  DocumentListItem(this.document);
}