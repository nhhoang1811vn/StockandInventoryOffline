import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/data/report_data/column_info.dart';
import 'package:good_manager/data/report_data/utils.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.createTempSync('rq_test').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
    AppSettings.setSelectedStoreId(61);
  });

  void setDecimals(int n) => AppSettings.setGoodPropertiesSettings(
      GoodPropertiesSettings(quantityDecimals: n),
      storeId: 61);

  test('report quantities use the Store decimals with thousands separators',
      () {
    setDecimals(2);
    expect(getQuantityTextForReport(1234.5), '1,234.5');
    expect(getQuantityTextForReport(2.5), '2.5');
    setDecimals(0);
    expect(getQuantityTextForReport(1234.5), '1,235');
  });

  test('a quantity column total keeps decimals, a money total stays whole', () {
    setDecimals(2);
    expect(formatColumnTotal(1234.5, isQuantity: true), '1,234.5');
    expect(formatColumnTotal(1234.5, isQuantity: false), getDoubleText(1234.5));
    expect(formatColumnTotal(1234.5, isQuantity: false), isNot('1,234.5'));
  });

  test('column visibility keeps the isQuantity flag of the kept columns', () {
    final r = applyColumnVisibility(
      [
        ColumnInfo('quantity', isQuantity: true),
        ColumnInfo('barcode', visibleWhen: ColumnGate.barcode),
        ColumnInfo('amount'),
      ],
      [
        MapEntry(1, ['2.5', 'x', '10'])
      ],
      GoodPropertiesSettings(showBarcode: false),
    );
    expect(r.columns.map((c) => c.name), ['quantity', 'amount']);
    expect(r.columns.map((c) => c.isQuantity), [true, false]);
  });
}
