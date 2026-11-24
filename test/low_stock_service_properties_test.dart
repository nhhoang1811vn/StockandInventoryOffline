import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/core/services/low_stock_service.dart';
import 'package:good_manager/domain/entity/entity.dart';

void main() {
  Good good(double quantity, double? min) => Good()
    ..quantity = quantity
    ..minQuantity = min;

  test('reports low stock when enabled and a good is below its minimum', () {
    expect(
        LowStockService.anyLowStock([good(10, null), good(1, 5)],
            enabled: true),
        isTrue);
  });

  test('never reports low stock when Minimum quantity is turned off', () {
    expect(LowStockService.anyLowStock([good(1, 5)], enabled: false), isFalse);
  });

  test('no low stock when nothing is below a minimum', () {
    expect(
        LowStockService.anyLowStock([good(5, 5), good(1, null)], enabled: true),
        isFalse);
  });
}
