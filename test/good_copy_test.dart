import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/presentation/pages/goods/good_copy.dart';

Good _source() {
  final good = Good()
    ..id = 7
    ..name = 'Milk'
    ..description = 'Fresh'
    ..barCode = '123'
    ..purchasePrice = 1.5
    ..salePrice = 2.5
    ..minQuantity = 3
    ..quantity = 40
    ..storeId = 1
    ..groupId = 2
    ..files = [
      Uint8List.fromList([1, 2])
    ];
  return good;
}

void main() {
  test('copies kept fields', () {
    final copy = buildCopyOfGood(_source(), storeId: 1, groupId: 2);
    expect(copy.name, 'Milk (copy)');
    expect(copy.description, 'Fresh');
    expect(copy.barCode, '123');
    expect(copy.purchasePrice, 1.5);
    expect(copy.salePrice, 2.5);
    expect(copy.minQuantity, 3);
    expect(copy.files.length, 1);
    expect(copy.files.first, [1, 2]);
  });

  test('is a new unsaved good', () {
    final copy = buildCopyOfGood(_source(), storeId: 9, groupId: null);
    expect(copy.id, isNull);
    expect(copy.quantity, 0);
    expect(copy.storeId, 9);
    expect(copy.groupId, isNull);
  });

  test('keeps nulls as null', () {
    final source = Good()
      ..name = 'A'
      ..storeId = 1;
    final copy = buildCopyOfGood(source, storeId: 1);
    expect(copy.barCode, isNull);
    expect(copy.purchasePrice, isNull);
    expect(copy.salePrice, isNull);
    expect(copy.minQuantity, isNull);
  });

  test('files list is independent', () {
    final source = _source();
    final copy = buildCopyOfGood(source, storeId: 1);
    copy.files.add(Uint8List(1));
    expect(source.files.length, 1);
  });

  test('does not de-duplicate the suffix', () {
    final source = _source()..name = 'X (copy)';
    expect(buildCopyOfGood(source, storeId: 1).name, 'X (copy) (copy)');
  });
}
