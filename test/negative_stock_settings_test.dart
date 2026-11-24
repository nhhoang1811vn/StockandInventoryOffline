import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/presentation/pages/settings/good_properties/bloc/good_properties_cubit.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;

  setUpAll(() {
    Hive.init(Directory.systemTemp.createTempSync('ns_test').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
    AppSettings.setSelectedStoreId(81);
  });

  test('negative stock is allowed by default', () {
    expect(GoodPropertiesSettings().allowNegativeStock, isTrue);
    expect(AppSettings.getGoodPropertiesSettings().allowNegativeStock, isTrue);
  });

  test('old json without the key reads true', () async {
    await prefs.setString('GoodPropertiesSettings_9', '{"showImage":false}');
    expect(AppSettings.getGoodPropertiesSettings(storeId: 9).allowNegativeStock,
        isTrue);
  });

  test('turning it off saves only it, for the selected store', () {
    final cubit = GoodPropertiesCubit()..init();
    expect(cubit.state.allowNegativeStock, isTrue);
    cubit.onQuantityDecimalsChanged(4);
    final before = AppSettings.goodPropertiesRevision.value;
    cubit.onAllowNegativeStockChanged(false);
    expect(cubit.state.allowNegativeStock, isFalse);
    expect(AppSettings.goodPropertiesRevision.value, greaterThan(before));

    final saved = AppSettings.getGoodPropertiesSettings(storeId: 81);
    expect(saved.allowNegativeStock, isFalse);
    expect(saved.quantityDecimals, 4);
    expect(saved.showImage, isTrue);
    expect(saved.uniqueBarcode, isFalse);
    expect(
        AppSettings.getGoodPropertiesSettings(storeId: 82).allowNegativeStock,
        isTrue);
  });

  test('a fresh cubit restores the saved value', () {
    GoodPropertiesCubit()
      ..init()
      ..onAllowNegativeStockChanged(false);
    final fresh = GoodPropertiesCubit()..init();
    expect(fresh.state.allowNegativeStock, isFalse);
  });
}
