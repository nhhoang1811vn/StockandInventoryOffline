import '../../../domain/exception/insufficient_stock_exception.dart';
import '../../../util/quantity_format.dart';

/// The toast text for a rejected stock change: "Cola: Not enough stock. In
/// stock: 4" (the Good's name only when it is known), with the quantity shown
/// using the Store's number of [decimals].
String insufficientStockMessage(
  InsufficientStockException error,
  int decimals,
  String Function(String key) tr,
) {
  final text = tr("error_negative_stock")
      .replaceFirst('%s', formatQuantity(error.available, decimals));
  final name = error.goodName;
  return (name == null || name.isEmpty) ? text : '$name: $text';
}
