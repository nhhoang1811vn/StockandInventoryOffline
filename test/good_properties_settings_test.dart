import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;

  setUpAll(() {
    Hive.init(Directory.systemTemp.createTempSync('gp_test').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    // On repeat calls initialize() returns false (adapters already
    // registered) after assigning the storage; that is enough here.
    await AppSettings.initialize(PrefStorage(prefs: prefs));
  });

  void expectAllTrue(GoodPropertiesSettings s) {
    expect(s.showPurchasePrice, isTrue);
    expect(s.showSalePrice, isTrue);
    expect(s.showImage, isTrue);
    expect(s.showBarcode, isTrue);
    expect(s.showDescription, isTrue);
    expect(s.showMinQuantity, isTrue);
  }

  test('defaults are all true when nothing saved', () {
    expectAllTrue(AppSettings.getGoodPropertiesSettings(storeId: 1));
  });

  test('values are isolated per store', () {
    AppSettings.setGoodPropertiesSettings(
      GoodPropertiesSettings(showBarcode: false),
      storeId: 1,
    );
    expect(
        AppSettings.getGoodPropertiesSettings(storeId: 1).showBarcode, isFalse);
    expectAllTrue(AppSettings.getGoodPropertiesSettings(storeId: 2));
  });

  test('price flags persist per store and leave other flags alone', () {
    AppSettings.setGoodPropertiesSettings(
      GoodPropertiesSettings(showPurchasePrice: false, showSalePrice: false),
      storeId: 1,
    );
    final s1 = AppSettings.getGoodPropertiesSettings(storeId: 1);
    expect(s1.showPurchasePrice, isFalse);
    expect(s1.showSalePrice, isFalse);
    expect(s1.showBarcode, isTrue);
    expectAllTrue(AppSettings.getGoodPropertiesSettings(storeId: 2));
  });

  test('old saved json without price keys defaults them to true', () async {
    await prefs.setString(
        'GoodPropertiesSettings_9', '{"showImage":false,"showBarcode":true}');
    final s = AppSettings.getGoodPropertiesSettings(storeId: 9);
    expect(s.showImage, isFalse);
    expect(s.showPurchasePrice, isTrue);
    expect(s.showSalePrice, isTrue);
  });

  test('uses the selected store by default', () {
    AppSettings.setSelectedStoreId(5);
    AppSettings.setGoodPropertiesSettings(
      GoodPropertiesSettings(showImage: false),
    );
    expect(
        AppSettings.getGoodPropertiesSettings(storeId: 5).showImage, isFalse);
    expect(AppSettings.getGoodPropertiesSettings().showImage, isFalse);
  });

  test('corrupt json falls back to defaults', () async {
    await prefs.setString('GoodPropertiesSettings_3', '{not json');
    expectAllTrue(AppSettings.getGoodPropertiesSettings(storeId: 3));
  });

  test('no selected store (-1) returns defaults', () {
    expect(AppSettings.getSelectedStoreId(), -1);
    expectAllTrue(AppSettings.getGoodPropertiesSettings());
  });

  test('setting bumps the revision notifier', () {
    final before = AppSettings.goodPropertiesRevision.value;
    AppSettings.setGoodPropertiesSettings(
      GoodPropertiesSettings(showDescription: false),
      storeId: 1,
    );
    expect(AppSettings.goodPropertiesRevision.value, before + 1);
  });

  test('isMinQuantityEnabled follows showMinQuantity', () {
    AppSettings.setSelectedStoreId(7);
    expect(AppSettings.isMinQuantityEnabled(), isTrue);
    AppSettings.setGoodPropertiesSettings(
      GoodPropertiesSettings(showMinQuantity: false),
    );
    expect(AppSettings.isMinQuantityEnabled(), isFalse);
  });
}
