import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;

  setUpAll(() {
    Hive.init(Directory.systemTemp.createTempSync('qd_test').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
  });

  test('defaults to 2', () {
    expect(GoodPropertiesSettings().quantityDecimals, 2);
    AppSettings.setSelectedStoreId(1);
    expect(AppSettings.getQuantityDecimals(), 2);
  });

  test('is saved per store', () {
    AppSettings.setGoodPropertiesSettings(
        GoodPropertiesSettings(quantityDecimals: 4),
        storeId: 1);
    AppSettings.setSelectedStoreId(1);
    expect(AppSettings.getQuantityDecimals(), 4);
    AppSettings.setSelectedStoreId(2);
    expect(AppSettings.getQuantityDecimals(), 2);
  });

  test('old json without the key reads as 2', () async {
    await prefs.setString('GoodPropertiesSettings_6', '{"showImage":false}');
    AppSettings.setSelectedStoreId(6);
    expect(AppSettings.getQuantityDecimals(), 2);
  });

  test('stored out-of-range values are clamped', () async {
    await prefs.setString('GoodPropertiesSettings_7', '{"quantityDecimals":9}');
    await prefs.setString(
        'GoodPropertiesSettings_8', '{"quantityDecimals":-1}');
    AppSettings.setSelectedStoreId(7);
    expect(AppSettings.getQuantityDecimals(), 6);
    AppSettings.setSelectedStoreId(8);
    expect(AppSettings.getQuantityDecimals(), 0);
  });

  test('clampQuantityDecimals', () {
    expect(AppSettings.clampQuantityDecimals(-3), 0);
    expect(AppSettings.clampQuantityDecimals(3), 3);
    expect(AppSettings.clampQuantityDecimals(99), 6);
  });

  test('parseQuantityDecimals accepts 0..6 and rejects the rest', () {
    expect(AppSettings.parseQuantityDecimals('0'), 0);
    expect(AppSettings.parseQuantityDecimals(' 6 '), 6);
    for (final bad in ['7', '-1', '', null, '2.5', 'abc']) {
      expect(AppSettings.parseQuantityDecimals(bad), isNull, reason: '$bad');
    }
  });
}
