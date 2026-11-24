import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/presentation/pages/settings/good_properties/bloc/good_properties_cubit.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.createTempSync('qdc_test').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
    AppSettings.setSelectedStoreId(41);
  });

  test('init with nothing saved shows 2 digits', () {
    final cubit = GoodPropertiesCubit()..init();
    expect(cubit.state.quantityDecimals, 2);
  });

  test('onQuantityDecimalsChanged saves it and leaves the other flags', () {
    final cubit = GoodPropertiesCubit()..init();
    cubit.onQuantityDecimalsChanged(4);
    expect(cubit.state.quantityDecimals, 4);
    final saved = AppSettings.getGoodPropertiesSettings(storeId: 41);
    expect(saved.quantityDecimals, 4);
    expect(saved.showImage, isTrue);
    expect(saved.uniqueBarcode, isFalse);
  });

  test('values outside 0..6 are clamped', () {
    final cubit = GoodPropertiesCubit()..init();
    cubit.onQuantityDecimalsChanged(99);
    expect(AppSettings.getQuantityDecimals(), 6);
    cubit.onQuantityDecimalsChanged(-5);
    expect(AppSettings.getQuantityDecimals(), 0);
  });

  test('a fresh cubit restores the saved value and a save bumps the revision',
      () {
    final before = AppSettings.goodPropertiesRevision.value;
    GoodPropertiesCubit()
      ..init()
      ..onQuantityDecimalsChanged(3);
    expect(AppSettings.goodPropertiesRevision.value, greaterThan(before));
    final fresh = GoodPropertiesCubit()..init();
    expect(fresh.state.quantityDecimals, 3);
  });
}
