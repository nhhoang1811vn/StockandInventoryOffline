import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/domain/exception/insufficient_stock_exception.dart';
import 'package:good_manager/presentation/pages/base/insufficient_stock_message.dart';

String _tr(String key) => 'Not enough stock. In stock: %s';

void main() {
  test('shows the quantity in stock with the Store decimals', () {
    final e = InsufficientStockException(goodId: 1, available: 2.5);
    expect(
        insufficientStockMessage(e, 2, _tr), 'Not enough stock. In stock: 2.5');
    expect(
        insufficientStockMessage(e, 0, _tr), 'Not enough stock. In stock: 3');
  });

  test('names the Good when it is known', () {
    final e =
        InsufficientStockException(goodId: 1, goodName: 'Cola', available: 4);
    expect(insufficientStockMessage(e, 2, _tr),
        'Cola: Not enough stock. In stock: 4');
  });

  test('a negative stock is shown as it is', () {
    final e = InsufficientStockException(goodId: 1, available: -2);
    expect(
        insufficientStockMessage(e, 2, _tr), 'Not enough stock. In stock: -2');
  });
}
