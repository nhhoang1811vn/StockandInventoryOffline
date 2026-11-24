import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/presentation/pages/settings/good_properties/bloc/good_properties_cubit.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.createTempSync('gp_cubit_test').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
    AppSettings.setSelectedStoreId(11);
  });

  test('init with nothing saved shows all four properties', () {
    final cubit = GoodPropertiesCubit()..init();
    expect(cubit.state.showImage, isTrue);
    expect(cubit.state.showBarcode, isTrue);
    expect(cubit.state.showDescription, isTrue);
    expect(cubit.state.showMinQuantity, isTrue);
  });

  test('turning barcode off saves only barcode for the selected store', () {
    final cubit = GoodPropertiesCubit()..init();
    cubit.onShowBarcodeChanged(false);
    expect(cubit.state.showBarcode, isFalse);
    final saved = AppSettings.getGoodPropertiesSettings(storeId: 11);
    expect(saved.showBarcode, isFalse);
    expect(saved.showImage, isTrue);
    expect(saved.showDescription, isTrue);
    expect(saved.showMinQuantity, isTrue);
  });

  test('turning prices off saves them without touching the others', () {
    final cubit = GoodPropertiesCubit()..init();
    cubit.onShowPurchasePriceChanged(false);
    cubit.onShowSalePriceChanged(false);
    final saved = AppSettings.getGoodPropertiesSettings(storeId: 11);
    expect(saved.showPurchasePrice, isFalse);
    expect(saved.showSalePrice, isFalse);
    expect(saved.showImage, isTrue);
    expect(saved.showMinQuantity, isTrue);
    final fresh = GoodPropertiesCubit()..init();
    expect(fresh.state.showPurchasePrice, isFalse);
    expect(fresh.state.showSalePrice, isFalse);
  });

  test('init restores saved values', () {
    GoodPropertiesCubit()
      ..init()
      ..onShowMinQuantityChanged(false);
    final fresh = GoodPropertiesCubit()..init();
    expect(fresh.state.showMinQuantity, isFalse);
  });
}
