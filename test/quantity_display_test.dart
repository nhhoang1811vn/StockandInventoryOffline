import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/util/string_utils.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.createTempSync('qdisp_test').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
    AppSettings.setSelectedStoreId(51);
  });

  void setDecimals(int n) => AppSettings.setGoodPropertiesSettings(
      GoodPropertiesSettings(quantityDecimals: n),
      storeId: 51);

  test('getQuantityText follows the Store setting', () {
    setDecimals(2);
    expect(StringUtils.getQuantityText(5.126), '5.13');
    setDecimals(1);
    expect(StringUtils.getQuantityText(5.126), '5.1');
    setDecimals(0);
    expect(StringUtils.getQuantityText(5.126), '5');
  });

  test('whole and trimmed values keep their natural text', () {
    setDecimals(2);
    expect(StringUtils.getQuantityText(100.0), '100');
    expect(StringUtils.getQuantityText(5.2), '5.2');
    expect(StringUtils.getQuantityText(5.12), '5.12');
  });

  test('default (nothing saved) is 2 so existing fractions look the same', () {
    expect(StringUtils.getQuantityText(2.5), '2.5');
    expect(StringUtils.getQuantityText(1.25), '1.25');
  });
}
