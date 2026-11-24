import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/presentation/pages/goods/good_item_row.dart';

void main() {
  Good good({double quantity = 1, double? min = 5}) => Good()
    ..quantity = quantity
    ..minQuantity = min;

  group('GoodItemRow.showMinQuantityText', () {
    test('follows the list-settings switch when the property is on', () {
      expect(
          GoodItemRow.showMinQuantityText(listSetting: false, property: true),
          isFalse);
      expect(GoodItemRow.showMinQuantityText(listSetting: true, property: true),
          isTrue);
    });
    test('is off whenever the property is off', () {
      expect(
          GoodItemRow.showMinQuantityText(listSetting: true, property: false),
          isFalse);
    });
  });

  group('GoodItemRow.isLowStockFor', () {
    test('low stock when quantity is below minimum and indicator enabled', () {
      expect(GoodItemRow.isLowStockFor(good(), enabled: true), isTrue);
    });
    test('never low stock when the indicator is disabled', () {
      expect(GoodItemRow.isLowStockFor(good(), enabled: false), isFalse);
    });
    test('not low stock without a minimum or at/above the minimum', () {
      expect(
          GoodItemRow.isLowStockFor(good(min: null), enabled: true), isFalse);
      expect(
          GoodItemRow.isLowStockFor(good(quantity: 5), enabled: true), isFalse);
    });
  });
}
